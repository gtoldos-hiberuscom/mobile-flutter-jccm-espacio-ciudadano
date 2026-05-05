import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen consent page shown once after a successful Cl@ve login.
///
/// ## Flow
/// - Shows data protection and terms of use information.
/// - Reject button calls [ConsentNotifier.reject] then exits the app via
///   [SystemNavigator.pop].
/// - Accept button calls [ConsentNotifier.accept] then navigates to
///   [Routes.home].
///
/// ## Accessibility
/// - Every interactive element carries a [Semantics] label.
/// - A [Semantics] liveRegion wraps the async status feedback area so that
///   screen readers announce changes.
/// - The scrollable body uses [Semantics] with `label` to describe the
///   content region.
class ConsentPage extends ConsumerWidget {
  const ConsentPage({super.key});

  static const String _privacyPolicyUrl = 'https://www.jccm.es/proteccion-datos';

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final consentAsync = ref.watch(consentProvider);

    // React to state transitions: Accepted -> home, Rejected -> exit.
    ref.listen<AsyncValue<ConsentState>>(
      consentProvider,
      (final previous, final next) {
        next.whenData((final state) {
          switch (state) {
            case ConsentAccepted():
              context.go(Routes.home);
            case ConsentRejected():
              unawaited(SystemNavigator.pop());
            default:
              break;
          }
        });
      },
    );

    final isLoading = consentAsync.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Semantics(
          label: l10n.consentPageSemantics,
          child: Column(
            children: [
              // Header
              _ConsentHeader(textTheme: textTheme, l10n: l10n),

              // Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space24,
                    vertical: AppDimensions.space16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.consentPageBody,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space24),
                      _PrivacyPolicyLink(l10n: l10n),
                      const SizedBox(height: AppDimensions.space32),
                    ],
                  ),
                ),
              ),

              // Status live region
              Semantics(
                liveRegion: true,
                child: consentAsync.hasError
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space24,
                          vertical: AppDimensions.space8,
                        ),
                        child: Text(
                          consentAsync.error?.toString() ?? '',
                          style: textTheme.bodySmall?.copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Action buttons
              _ConsentActions(l10n: l10n, ref: ref, isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}

// -- Header -------------------------------------------------------------------

class _ConsentHeader extends StatelessWidget {
  const _ConsentHeader({required this.textTheme, required this.l10n});

  final TextTheme textTheme;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space24,
        vertical: AppDimensions.space32,
      ),
      child: Column(
        children: [
          Semantics(
            label: 'Logotipo de la Junta de Comunidades de Castilla-La Mancha',
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
              ),
              child: const Icon(
                Icons.account_balance_outlined,
                size: AppDimensions.iconLarge,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            l10n.consentPageTitle,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.consentPageSubtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// -- Privacy policy link -------------------------------------------------------

class _PrivacyPolicyLink extends StatelessWidget {
  const _PrivacyPolicyLink({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      link: true,
      label: l10n.consentPagePrivacyLink,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(ConsentPage._privacyPolicyUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.open_in_new,
                size: AppDimensions.iconSmall,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimensions.space8),
              Text(
                l10n.consentPagePrivacyLink,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -- Action buttons ------------------------------------------------------------

class _ConsentActions extends StatelessWidget {
  const _ConsentActions({
    required this.l10n,
    required this.ref,
    required this.isLoading,
  });

  final AppLocalizations l10n;
  final WidgetRef ref;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: l10n.consentAcceptButton,
            semanticsLabel: l10n.consentAcceptButton,
            isLoading: isLoading,
            onPressed: isLoading ? null : () => unawaited(ref.read(consentProvider.notifier).accept()),
          ),
          const SizedBox(height: AppDimensions.space12),
          AppButton(
            label: l10n.consentRejectButton,
            semanticsLabel: l10n.consentRejectButton,
            variant: AppButtonVariant.outlined,
            isLoading: isLoading,
            onPressed: isLoading ? null : () => unawaited(ref.read(consentProvider.notifier).reject()),
          ),
        ],
      ),
    );
  }
}
