import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_label.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Card variant for dashboard surfaces whose Sprint-3 implementation is
/// shipped as an outbound link via the [ExternalLinkCatalog]
/// (TASK-27 EXTERNAL_LINK decision).
///
/// Renders a localized title, an explanatory paragraph and an
/// [ExternalLinkButton] resolved from a catalog `id` so the allow-list
/// contract is preserved (no raw URL inputs).
class ExternalLinkCard extends ConsumerWidget {
  const ExternalLinkCard({
    required this.title,
    required this.description,
    required this.linkId,
    super.key,
  });

  final String title;
  final String description;

  /// Stable id from the [ExternalLinkCatalog].
  final String linkId;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ExternalLink? link = ref.watch(externalLinkCatalogProvider).findById(linkId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppDimensions.space12),
            if (link != null)
              Align(
                alignment: Alignment.centerLeft,
                child: ExternalLinkButton(
                  link: link,
                  label: resolveExternalLinkLabel(l10n, link.displayKey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
