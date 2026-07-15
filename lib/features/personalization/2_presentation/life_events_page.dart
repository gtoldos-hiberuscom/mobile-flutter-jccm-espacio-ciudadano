import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Mis Hechos Vitales" screen — Figma node `41779:22465`.
///
/// Displays selectable life-event checkboxes for personalisation.
/// Uses DS components exclusively with full WCAG 2.1 AA accessibility.
///
/// Accessibility contract:
/// - Rule 3.1: single H1 heading announced first
/// - Rule 3.4: unified Semantics nodes on interactive rows
/// - Rule 3.10: loading/saving states announced via SemanticsService
/// - Rule 3.11: save/error feedback announced
/// - Rule 3.14: expandable sections indicate expanded state
class LifeEventsPage extends ConsumerStatefulWidget {
  const LifeEventsPage({
    super.key,
    this.isOnboarding = false,
    this.returnTo = Routes.home,
  });

  final bool isOnboarding;
  final String returnTo;

  @override
  ConsumerState<LifeEventsPage> createState() => _LifeEventsPageState();
}

class _LifeEventsPageState extends ConsumerState<LifeEventsPage> {
  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final claims = ref.watch(jwtClaimsProvider);
    final idAgente = claims?.idAgente ?? '';
    final providerArgs = (
      idAgente: idAgente,
      clearSelectionsOnLoad: widget.isOnboarding,
    );
    final lifeState = ref.watch(lifeEventsProvider(providerArgs));
    final notifier = ref.read(lifeEventsProvider(providerArgs).notifier);

    // ── Side-effect listener (Rule 3.11) ──────────────────────────────────
    ref.listen<LifeEventsState>(
      lifeEventsProvider(providerArgs),
      (final prev, final next) {
        _handleSideEffects(context, l10n, prev, next, notifier);
      },
    );

    final isSaving = lifeState.status == LifeEventsStatus.saving;
    final isResetting = lifeState.status == LifeEventsStatus.resetting;
    final isPreferencesEditing = widget.returnTo == Routes.preferences;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      // Figma node 41779:22466 — bg #f1f8f9, border bluemuted-lighter, Shadow/Low
      appBar: AppNavBar(
        type: widget.isOnboarding ? AppNavBarType.detail : AppNavBarType.level2,
        title: l10n.lifeEventsTitle,
        leading: widget.isOnboarding
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: AppDimensions.iconLarge,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(widget.returnTo);
                  }
                },
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              )
            : null,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(widget.returnTo);
          }
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
            tooltip: 'Información',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Intro heading + description ─────────────────────────────────
          _IntroSection(l10n: l10n),

          // ── Body content ────────────────────────────────────────────────
          Expanded(
            child: _buildBody(
              context,
              l10n,
              lifeState,
              isResetting,
              notifier,
            ),
          ),

          // ── Sticky bottom bar ───────────────────────────────────────────
          if (widget.isOnboarding)
            _OnboardingStickyBar(
              l10n: l10n,
              canSave: !isSaving,
              isSaving: isSaving,
              onFillLater: () => unawaited(notifier.skipOnboarding()),
              onClearAll: notifier.clearSelection,
              onSave: () => unawaited(notifier.save()),
            )
          else
            AppStickyBar(
              type: AppStickyBarType.dicotomy,
              secondaryLabel: isPreferencesEditing ? 'Limpiar' : l10n.lifeEventsResetCancel,
              onSecondary: isPreferencesEditing ? notifier.clearSelection : notifier.requestReset,
              secondaryHierarchy: AppButtonHierarchy.tertiary,
              secondaryLeadingIcon: Icons.highlight_off,
              primaryLabel: l10n.lifeEventsSaveAction,
              onPrimary: (lifeState.isDirty && !isSaving) ? () => unawaited(notifier.save()) : null,
              isPrimaryLoading: isSaving,
              primaryLeadingIcon: Icons.check,
            ),
        ],
      ),
    );
  }

  void _handleSideEffects(
    final BuildContext context,
    final AppLocalizations l10n,
    final LifeEventsState? prev,
    final LifeEventsState next,
    final LifeEventsNotifier notifier,
  ) {
    // Rule 3.11 — announce feedback to screen readers
    if (next.status == LifeEventsStatus.saveSuccess) {
      _showFeedback(
        context,
        l10n.lifeEventsSavedFeedback,
        severity: AppAlertSeverity.success,
      );
      if (widget.returnTo == Routes.recommendations) {
        ref.invalidate(recommendationsProvider);
      }
      if (widget.returnTo == Routes.preferences && context.canPop()) {
        context.pop();
        return;
      }
      context.go(widget.returnTo);
    }
    if (next.status == LifeEventsStatus.onboardingSkipped) {
      context.go(widget.returnTo);
    }
    if (next.status == LifeEventsStatus.saveError) {
      // Never surface raw backend/exception detail to the user; only a curated
      // localized message reaches the UI. The technical detail goes to logs.
      if (next.errorMessage != null) {
        logger.w('LifeEvents saveError: ${next.errorMessage}');
      }
      _showFeedback(
        context,
        l10n.lifeEventsErrorFeedback,
        severity: AppAlertSeverity.error,
      );
    }
    // Show reset-confirm dialog when the flag flips to true.
    if (next.showResetConfirm && !(prev?.showResetConfirm ?? false)) {
      unawaited(
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (final _) => _ResetConfirmDialog(
            l10n: l10n,
            onCancel: () {
              Navigator.of(context).pop();
              notifier.cancelReset();
            },
            onConfirm: () {
              Navigator.of(context).pop();
              unawaited(notifier.confirmReset());
            },
          ),
        ),
      );
    }
  }

  void _showFeedback(
    final BuildContext context,
    final String message, {
    required final AppAlertSeverity severity,
  }) {
    AppAlertSnackbar.show(
      context,
      message: message,
      severity: severity,
    );
  }

  Widget _buildBody(
    final BuildContext context,
    final AppLocalizations l10n,
    final LifeEventsState lifeState,
    final bool isResetting,
    final LifeEventsNotifier notifier,
  ) {
    final status = lifeState.status;

    if (status == LifeEventsStatus.loading || status == LifeEventsStatus.initial) {
      return const AppLoadingIndicator();
    }

    if (status == LifeEventsStatus.empty) {
      return EmptyStateWidget(
        icon: Icons.check_box_outline_blank,
        message: l10n.lifeEventsEmpty,
      );
    }

    if (status == LifeEventsStatus.loadError) {
      return ErrorStateWidget(
        message: l10n.lifeEventsLoadError,
        onRetry: notifier.retry,
      );
    }

    return SingleChildScrollView(
      // Figma node 41779:22467 — content area px:16 py:24 (top handled by IntroSection)
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        0,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Figma node 41779:13486 — white card, border rgba(12,13,13,0.05),
          // Shadow/Medium, borderRadius 4, padding 16
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              border: Border.all(
                color: const Color(0x0D0C0D0D), // rgba(12,13,13,0.05)
              ),
              boxShadow: AppShadows.medium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...lifeState.events.map(
                  (final event) => _LifeEventCheckRow(
                    event: event,
                    onToggle: () => notifier.toggle(event.id),
                    isLast: event == lifeState.events.last,
                  ),
                ),
              ],
            ),
          ),

          // Resetting-state loading overlay
          if (isResetting)
            const Padding(
              padding: EdgeInsets.only(top: AppDimensions.space24),
              child: AppLoadingIndicator(),
            ),
        ],
      ),
    );
  }
}

class _OnboardingStickyBar extends StatelessWidget {
  const _OnboardingStickyBar({
    required this.l10n,
    required this.canSave,
    required this.isSaving,
    required this.onFillLater,
    required this.onClearAll,
    required this.onSave,
  });

  final AppLocalizations l10n;
  final bool canSave;
  final bool isSaving;
  final VoidCallback onFillLater;
  final VoidCallback? onClearAll;
  final VoidCallback onSave;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E2E1)),
        ),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: l10n.lifeEventsFillLaterAction,
            onPressed: onFillLater,
            hierarchy: AppButtonHierarchy.tertiary,
          ),
          const SizedBox(height: AppDimensions.space16),
          AppButton(
            label: l10n.lifeEventsClearAllAction,
            onPressed: onClearAll,
            hierarchy: AppButtonHierarchy.secondary,
            leadingIcon: Icons.sync,
          ),
          const SizedBox(height: AppDimensions.space16),
          AppButton(
            label: l10n.lifeEventsAcceptAction,
            onPressed: canSave ? onSave : null,
            isLoading: isSaving,
            leadingIcon: Icons.check,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INTRO SECTION — Heading only, Figma node 41779:22621
// px-content:16 py-content:24  +  inner TextBlocks px:4 py:8
// ═══════════════════════════════════════════════════════════════════════════════

class _IntroSection extends StatelessWidget {
  const _IntroSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    // Figma content area: px:16, pt:24 → TextBlocks adds px:4, py:8
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16 + AppDimensions.space4, // 20
        AppDimensions.space24 + AppDimensions.space8, // 32
        AppDimensions.space16 + AppDimensions.space4, // 20
        AppDimensions.space8,
      ),
      child: Text(
        l10n.lifeEventsIntroHeading,
        // Figma: H2 SemiBold 24px lineHeight:1.5 color:textBase #0c0d0d
        style: AppTypography.h2.copyWith(color: AppColors.textBase),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIFE EVENT CHECK ROW — Figma node BuildingBlocks/SelectOption
// padding:8, border-bottom rgba(12,13,13,0.08), label color primary,
// checkbox trailing; selected: bg successLight, border-bottom success
// ═══════════════════════════════════════════════════════════════════════════════

class _LifeEventCheckRow extends StatelessWidget {
  const _LifeEventCheckRow({
    required this.event,
    required this.onToggle,
    required this.isLast,
  });

  final LifeEvent event;
  final VoidCallback onToggle;

  /// Last row has no bottom border per Figma.
  final bool isLast;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: event.label,
      checked: event.selected,
      enabled: true,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: event.selected
                  ? AppColors
                        .successLight // #d7f4e3
                  : Colors.transparent,
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        // selected → success green, unselected → rgba(12,13,13,0.08)
                        color: event.selected
                            ? AppColors
                                  .success // #22a85a
                            : const Color(0x140C0D0D), // rgba(12,13,13,0.08)
                      ),
                    ),
            ),
            padding: const EdgeInsets.all(AppDimensions.space8),
            child: Row(
              children: [
                // Label — flex:1, color primary #002855, body/regular
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.space4,
                    ),
                    child: Text(
                      event.label,
                      style: AppTypography.bodyBase.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                // Checkbox icon trailing — 24×24
                Icon(
                  event.selected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: AppDimensions.iconMedium,
                  color: event.selected ? AppColors.success : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// RESET CONFIRMATION DIALOG — Rule 3.9: scopesRoute + OrdinalSortKey
// ═══════════════════════════════════════════════════════════════════════════════

class _ResetConfirmDialog extends StatelessWidget {
  const _ResetConfirmDialog({
    required this.l10n,
    required this.onCancel,
    required this.onConfirm,
  });

  final AppLocalizations l10n;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(final BuildContext context) {
    // Rule 3.9 — isolate focus within the dialog
    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: l10n.lifeEventsResetConfirmTitle,
      child: AlertDialog(
        title: Semantics(
          header: true,
          headingLevel: 1,
          sortKey: const OrdinalSortKey(1),
          child: Text(l10n.lifeEventsResetConfirmTitle),
        ),
        content: Semantics(
          sortKey: const OrdinalSortKey(2),
          child: Text(l10n.lifeEventsResetConfirmBody),
        ),
        actions: [
          Semantics(
            sortKey: const OrdinalSortKey(3),
            child: AppButton(
              label: l10n.lifeEventsResetCancel,
              onPressed: onCancel,
              hierarchy: AppButtonHierarchy.ghost,
            ),
          ),
          Semantics(
            sortKey: const OrdinalSortKey(4),
            child: AppButton(
              label: l10n.lifeEventsResetConfirm,
              onPressed: onConfirm,
              intent: AppButtonIntent.destructive,
            ),
          ),
        ],
      ),
    );
  }
}
