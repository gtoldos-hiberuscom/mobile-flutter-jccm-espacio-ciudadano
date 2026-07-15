import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Two-step mandatory legal-consent onboarding gate (JCCMEC-11).
///
/// **Step 1** — Scrollable legal text. The "Aceptar y continuar" CTA is locked
/// until the citizen scrolls to the very bottom of the content.
///
/// **Step 2** — Variable list of optional authorisation checkboxes. "Aceptar"
/// persists the citizen's chosen combination.
/// The `info` icon in the app bar reopens the full legal text without losing
/// checkbox state.
///
/// Rejection (step 1 or step 2 `X`) clears the in-memory session and navigates
/// the citizen back to the public landing page.
class ConsentPage extends ConsumerWidget {
  const ConsentPage({
    super.key,
    this.isOnboarding = false,
    this.isPreferencesEditing = false,
    this.returnTo = Routes.home,
  });

  final bool isOnboarding;
  final bool isPreferencesEditing;
  final String returnTo;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final idAgente = ref.watch(jwtClaimsProvider)?.idAgente ?? '';
    final state = ref.watch(consentProvider(idAgente));
    final notifier = ref.read(consentProvider(idAgente).notifier);

    // ── Side-effect listener ──────────────────────────────────────────────
    ref.listen<ConsentState>(
      consentProvider(idAgente),
      (final prev, final next) {
        if (!context.mounted) {
          return;
        }
        switch (next.status) {
          case ConsentStatus.accepted:
            if (isPreferencesEditing && context.canPop()) {
              ref
                ..invalidate(jccmDataAuthorizationProvider)
                ..invalidate(ageDataAuthorizationProvider);
              context.pop();
            } else {
              context.go(isPreferencesEditing ? returnTo : Routes.home);
            }
          case ConsentStatus.rejected:
            context.go(Routes.landing);
          case ConsentStatus.saveError:
            // Never surface raw backend/exception detail to the user; only a
            // curated localized message reaches the UI. Detail goes to logs.
            if (next.errorMessage != null) {
              logger.w('Consent saveError: ${next.errorMessage}');
            }
            AppAlertSnackbar.show(
              context,
              message: l10n.consentSaveError,
              severity: AppAlertSeverity.error,
            );
          case ConsentStatus.loading:
          case ConsentStatus.step1Locked:
          case ConsentStatus.step1Unlocked:
          case ConsentStatus.step2:
          case ConsentStatus.saving:
            break;
        }
      },
    );

    final isBeforeClauses = state.status == ConsentStatus.loading || state.status == ConsentStatus.step1Locked || state.status == ConsentStatus.step1Unlocked;

    final shouldLoadPreferencesClauses = isPreferencesEditing && state.status != ConsentStatus.step2 && state.status != ConsentStatus.saving && state.status != ConsentStatus.saveError;

    if (shouldLoadPreferencesClauses) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (context.mounted) {
          unawaited(notifier.enterPreferencesEditing());
        }
      });
      return const Scaffold(
        body: SafeArea(child: AppLoadingIndicator()),
      );
    }

    if (isBeforeClauses) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (context.mounted) {
          context.go(
            Uri(
              path: Routes.legalPrivacy,
              queryParameters: {
                if (isOnboarding) 'mode': 'onboarding',
              },
            ).toString(),
          );
        }
      });
      return const Scaffold(
        body: SafeArea(child: AppLoadingIndicator()),
      );
    }

    return _Step2Scaffold(
      l10n: l10n,
      state: state,
      notifier: notifier,
      isOnboarding: isOnboarding,
      isPreferencesEditing: isPreferencesEditing,
      returnTo: returnTo,
      onShowLegalInfo: () => context.push(Routes.legalPrivacy),
    );
  }
}

// ── Step 2 scaffold ────────────────────────────────────────────────────────────

class _Step2Scaffold extends StatelessWidget {
  const _Step2Scaffold({
    required this.l10n,
    required this.state,
    required this.notifier,
    required this.isOnboarding,
    required this.isPreferencesEditing,
    required this.returnTo,
    required this.onShowLegalInfo,
  });

  final AppLocalizations l10n;
  final ConsentState state;
  final ConsentNotifier notifier;
  final bool isOnboarding;
  final bool isPreferencesEditing;
  final String returnTo;
  final VoidCallback onShowLegalInfo;

  @override
  Widget build(final BuildContext context) {
    final isSaving = state.status == ConsentStatus.saving;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: l10n.consentStep1FullTitle,
        showLeading: !isOnboarding,
        leading: isOnboarding
            ? null
            : IconButton(
                icon: const AppIcon(
                  AppIcons.arrowBack,
                  size: AppDimensions.iconLarge,
                  color: AppColors.textPrimary,
                ),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(returnTo);
                  }
                },
              ),
        actions: isOnboarding
            ? const []
            : [
                Semantics(
                  label: l10n.consentInfoButtonSemantics,
                  button: true,
                  child: ExcludeSemantics(
                    child: IconButton(
                      icon: const AppIcon(
                        AppIcons.info,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: onShowLegalInfo,
                    ),
                  ),
                ),
              ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              children: [
                AppTextBlock(
                  text: l10n.consentStep1FullTitle,
                  variant: AppTextBlockVariant.h2,
                  showLeadingIcon: false,
                  showTrailingIcon: false,
                  color: AppColors.textBase,
                ),
                const SizedBox(height: AppDimensions.space8),
                for (final clause in state.clauses.where((final clause) => clause.id != requiredConsentClauseId))
                  AppCheckbox(
                    label: consentClauseLabel(clause.id, clause.label),
                    value: clause.isSelected,
                    labelStyle: AppTypography.leadingMedium,
                    onChanged: (final _) => notifier.toggleClause(clause.id),
                  ),
              ],
            ),
          ),
          AppStickyBar(
            type: AppStickyBarType.vertical,
            primaryLabel: l10n.consentFinalAcceptButton,
            primaryLeadingIcon: AppIcons.check,
            onPrimary: !isSaving ? () => unawaited(notifier.accept(persistSession: !isPreferencesEditing)) : null,
            isPrimaryLoading: isSaving,
          ),
        ],
      ),
    );
  }
}
