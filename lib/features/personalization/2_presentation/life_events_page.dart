import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Full-page screen for selecting and saving life-event preferences.
///
/// Reads [jwtClaimsProvider] internally to obtain the citizen identifier —
/// no constructor parameter is needed, keeping the router free of auth
/// dependencies.
///
/// All orchestration is delegated to [LifeEventsNotifier]. Snackbars and
/// dialogs are driven by `ref.listen` side-effect callbacks.
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

    // ── Side-effect listener ───────────────────────────────────────────────
    ref.listen<LifeEventsState>(
      lifeEventsProvider(idAgente),
      (final prev, final next) {
        if (next.status == LifeEventsStatus.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.lifeEventsSavedFeedback)),
          );
        }
        if (next.status == LifeEventsStatus.saveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage ?? l10n.lifeEventsErrorFeedback),
            ),
          );
        }
        // Show reset-confirm dialog when the flag flips to true.
        if (next.showResetConfirm && !(prev?.showResetConfirm ?? false)) {
          unawaited(
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => _ResetConfirmDialog(
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
      },
    );

    // ── Layout ────────────────────────────────────────────────────────────
    final isSaving = lifeState.status == LifeEventsStatus.saving;
    final isResetting = lifeState.status == LifeEventsStatus.resetting;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lifeEventsTitle),
        leading: BackButton(
          onPressed: Navigator.of(context).maybePop,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildBody(
              context,
              l10n,
              lifeState,
              isResetting,
              notifier,
            ),
          ),
          _BottomActionBar(
            l10n: l10n,
            isSaving: isSaving,
            isDirty: lifeState.isDirty,
            onSave: (lifeState.isDirty && !isSaving)
                ? notifier.save
                : null,
            onReset: notifier.requestReset,
          ),
        ],
      ),
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

    if (status == LifeEventsStatus.loading ||
        status == LifeEventsStatus.initial) {
      return const AppLoadingIndicator();
    }

    if (status == LifeEventsStatus.empty) {
      return EmptyStateWidget(
        icon: Icons.check_box_outline_blank,
        message: l10n.lifeEventsEmpty,
      );
    }

    if (status == LifeEventsStatus.loadError) {
      return EmptyStateWidget(
        icon: Icons.error_outline,
        message: l10n.lifeEventsLoadError,
        action: AppButton(
          label: 'Reintentar',
          onPressed: notifier.retry,
        ),
      );
    }

    // loaded / saving / saveSuccess / saveError / resetting / resetSuccess / resetError
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppDimensions.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space24,
              AppDimensions.space24,
              AppDimensions.space24,
              AppDimensions.space8,
            ),
            child: Text(
              l10n.lifeEventsTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space24,
            ),
            child: Text(
              l10n.lifeEventsHeaderDescription,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // ── Events list ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
            ),
            child: _LifeEventsList(
              events: lifeState.events,
              onToggle: notifier.toggle,
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

// ── Life events list ───────────────────────────────────────────────────────────

class _LifeEventsList extends StatelessWidget {
  const _LifeEventsList({
    required this.events,
    required this.onToggle,
  });

  final List<LifeEvent> events;
  final void Function(int id) onToggle;

  static const _selectedBackground = Color(0xFFE8F5E9);

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        separatorBuilder: (final _, final unused) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.divider,
        ),
        itemBuilder: (final context, final index) {
          final event = events[index];
          return _LifeEventRow(
            event: event,
            selectedBackground: _selectedBackground,
            onToggle: () => onToggle(event.id),
          );
        },
      ),
    );
  }
}

// ── Single life-event row ──────────────────────────────────────────────────────

class _LifeEventRow extends StatelessWidget {
  const _LifeEventRow({
    required this.event,
    required this.selectedBackground,
    required this.onToggle,
  });

  final LifeEvent event;
  final Color selectedBackground;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: event.label,
      checked: event.selected,
      button: true,
      child: InkWell(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: event.selected ? selectedBackground : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  event.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              Checkbox(
                value: event.selected,
                // Full-row tap handles toggling; checkbox is visual-only.
                onChanged: (_) => onToggle(),
                activeColor: AppColors.success,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimensions.radiusSmall),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sticky bottom action bar ───────────────────────────────────────────────────

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
    final textTheme = Theme.of(context).textTheme;

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
              ),
              const SizedBox(height: AppDimensions.space12),

              // ── Reset preferences text link ───────────────────────────────
              Center(
                child: TextButton(
                  onPressed: onReset,
                  child: Text(
                    l10n.lifeEventsResetAction,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reset confirmation dialog ──────────────────────────────────────────────────

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
    return AlertDialog(
      title: Text(l10n.lifeEventsResetConfirmTitle),
      content: Text(l10n.lifeEventsResetConfirmBody),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(l10n.lifeEventsResetCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.textOnPrimary,
          ),
          onPressed: onConfirm,
          child: Text(l10n.lifeEventsResetConfirm),
        ),
      ],
    );
  }
}
