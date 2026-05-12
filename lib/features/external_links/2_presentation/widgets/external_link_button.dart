import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Reusable button that opens an [ExternalLink] in the platform browser.
///
/// Centralises the outbound-navigation interaction so every consumer
/// (home dashboard, landings, sitemap) gets:
/// - the same hardened launch path (canon §24),
/// - the same accessibility contract (`Semantics` link + hint),
/// - the same failure feedback (a localised SnackBar).
///
/// The widget never accepts a raw URL — only an [ExternalLink] obtained
/// from the catalog provider — so misuse cannot bypass the allow-list.
class ExternalLinkButton extends ConsumerWidget {
  const ExternalLinkButton({
    required this.link,
    required this.label,
    super.key,
    this.variant = AppButtonVariant.outlined,
    this.icon,
  });

  /// The outbound destination. Resolved against the catalog at launch
  /// time as a defence-in-depth measure.
  final ExternalLink link;

  /// Already-localised user-facing label (callers resolve the link's
  /// `displayKey` via `AppLocalizations` and pass the result here).
  final String label;

  /// Visual variant — defaults to [AppButtonVariant.outlined] because most
  /// outbound links are secondary actions.
  final AppButtonVariant variant;

  /// Optional leading icon. If null, an `open_in_new` icon is used.
  final Widget? icon;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hint = l10n.externalLinkA11yHint;

    return Semantics(
      label: label,
      hint: hint,
      button: true,
      link: true,
      child: AppButton(
        label: label,
        variant: variant,
        icon:
            icon ??
            const Icon(
              Icons.open_in_new,
              size: AppDimensions.iconSmall,
            ),
        semanticsLabel: label,
        onPressed: () => _onPressed(context, ref),
      ),
    );
  }

  Future<void> _onPressed(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final launcher = ref.read(externalLinkLauncherProvider);
    final result = await launcher.launch(link);
    if (!context.mounted) {
      return;
    }
    if (result is ExternalLinkLaunchFailure) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.externalLinkOpenFailed),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
