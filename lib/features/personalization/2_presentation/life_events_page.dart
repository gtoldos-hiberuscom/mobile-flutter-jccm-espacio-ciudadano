import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_list.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_notifier.dart';
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
  const LifeEventsPage({super.key});

  @override
  ConsumerState<LifeEventsPage> createState() => _LifeEventsPageState();
}

class _LifeEventsPageState extends ConsumerState<LifeEventsPage> {
  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final claims = ref.watch(jwtClaimsProvider);
    final idAgente = claims?.idAgente ?? '';
    final lifeState = ref.watch(lifeEventsProvider(idAgente));
    final notifier = ref.read(lifeEventsProvider(idAgente).notifier);

    // ── Side-effect listener (Rule 3.11) ──────────────────────────────────
    ref.listen<LifeEventsState>(
      lifeEventsProvider(idAgente),
      (final prev, final next) {
        _handleSideEffects(context, l10n, prev, next, notifier);
      },
    );

    final isSaving = lifeState.status == LifeEventsStatus.saving;
    final isResetting = lifeState.status == LifeEventsStatus.resetting;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero header with heading ─────────────────────────────────────
          _HeroHeader(l10n: l10n),

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
          _BottomActionBar(
            l10n: l10n,
            isSaving: isSaving,
            isDirty: lifeState.isDirty,
            onSave: (lifeState.isDirty && !isSaving) ? notifier.save : null,
            onReset: notifier.requestReset,
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
      _showFeedback(context, l10n.lifeEventsSavedFeedback);
    }
    if (next.status == LifeEventsStatus.saveError) {
      _showFeedback(
        context,
        next.errorMessage ?? l10n.lifeEventsErrorFeedback,
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

  void _showFeedback(final BuildContext context, final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    // Rule 3.11 — announce for screen readers
    SemanticsService.announce(message, TextDirection.ltr);
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
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Checklist ─────────────────────────────────────────────────
          AppList(
            variant: AppListVariant.checklist,
            children: lifeState.events
                .map(
                  (final event) => _LifeEventCheckRow(
                    event: event,
                    onToggle: () => notifier.toggle(event.id),
                  ),
                )
                .toList(),
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

// ═══════════════════════════════════════════════════════════════════════════════
// HERO HEADER — Dark navy header matching Figma design
// ═══════════════════════════════════════════════════════════════════════════════

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Rule 3.1 + 3.2 — H1 heading announced first, 1×1 px node
            Positioned(
              top: 0,
              left: 0,
              child: Semantics(
                label: l10n.lifeEventsTitle,
                header: true,
                headingLevel: 1,
                focusable: true,
                child: const SizedBox(width: 1, height: 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space24,
                AppDimensions.space16,
                AppDimensions.space24,
                AppDimensions.space24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button — Rule 3.5: 48 dp min touch target
                  Semantics(
                    label: 'Volver',
                    button: true,
                    enabled: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).maybePop(),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: AppDimensions.minTouchTarget,
                          minHeight: AppDimensions.minTouchTarget,
                        ),
                        child: const ExcludeSemantics(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textOnPrimary,
                              size: AppDimensions.iconMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  // Title — visual (semantic H1 is the Positioned node above)
                  ExcludeSemantics(
                    child: Text(
                      l10n.lifeEventsTitle,
                      style: AppTypography.h1.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  // Description
                  ExcludeSemantics(
                    child: Text(
                      l10n.lifeEventsHeaderDescription,
                      style: AppTypography.bodyBase.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIFE EVENT CHECK ROW — Individual selectable row
// ═══════════════════════════════════════════════════════════════════════════════

/// Single life-event selection row using DS check indicator.
///
/// Accessibility: Rule 3.4 — unified Semantics node wrapping all content.
class _LifeEventCheckRow extends StatelessWidget {
  const _LifeEventCheckRow({
    required this.event,
    required this.onToggle,
  });

  final LifeEvent event;
  final VoidCallback onToggle;

  /// Figma selected-row background — soft green tint.
  static const Color _selectedBackground = Color(0xFFE8F5E9);

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
            color: event.selected ? _selectedBackground : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    event.label,
                    style: AppTypography.bodyBase.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                _CheckboxIndicator(isChecked: event.selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom checkbox indicator matching Figma spec —
/// green filled when selected, dark outline when unselected.
class _CheckboxIndicator extends StatelessWidget {
  const _CheckboxIndicator({required this.isChecked});

  final bool isChecked;

  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: AppDimensions.iconMedium,
      height: AppDimensions.iconMedium,
      decoration: BoxDecoration(
        color: isChecked ? AppColors.success : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        border: Border.all(
          color: isChecked ? AppColors.success : AppColors.neutral800,
          width: 2,
        ),
      ),
      child: isChecked
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.onSuccess,
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BOTTOM ACTION BAR — Sticky save + reset actions
// ═══════════════════════════════════════════════════════════════════════════════

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.l10n,
    required this.isSaving,
    required this.isDirty,
    required this.onSave,
    required this.onReset,
  });

  final AppLocalizations l10n;
  final bool isSaving;
  final bool isDirty;
  final Future<void> Function()? onSave;
  final VoidCallback onReset;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Save button ──────────────────────────────────────────────
              AppButton(
                label: l10n.lifeEventsSaveAction,
                semanticsLabel: l10n.lifeEventsSaveAction,
                onPressed: onSave == null ? null : () => unawaited(onSave!()),
                isLoading: isSaving,
                isExpanded: true,
              ),
              const SizedBox(height: AppDimensions.space12),

              // ── Reset preferences — destructive text button ──────────────
              AppButton(
                label: l10n.lifeEventsResetAction,
                semanticsLabel: l10n.lifeEventsResetAction,
                onPressed: onReset,
                hierarchy: AppButtonHierarchy.ghost,
                intent: AppButtonIntent.destructive,
                isExpanded: true,
              ),
            ],
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
