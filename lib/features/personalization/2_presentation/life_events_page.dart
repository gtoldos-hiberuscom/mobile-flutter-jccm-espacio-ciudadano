import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/auth/session_state_provider.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_events_selection.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hechos vitales — life-events selection screen (STORY-54).
///
/// Renders the catalog grouped by category as multi-select checkboxes,
/// exposes an explicit save action with persistence feedback, and a reset
/// action behind a confirmation dialog. Mocked data — the underlying
/// repository carries the `TODO(future-sprint)` for Dio wiring against
/// `/hechos-vitales/hechos/{idAgente}`, `PATCH /hechos-vitales/hechos`
/// and `DELETE /hechos-vitales/preferencias/{idAgente}`.
class LifeEventsPage extends ConsumerStatefulWidget {
  const LifeEventsPage({super.key, this.idAgente});

  /// Optional override. When omitted, the page reads `idAgente` from the
  /// shared `sessionStateProvider`. As a last resort (no session yet during
  /// development) a stable stub is used so the screen remains testable.
  final String? idAgente;

  /// Stub used when no real session is available (dev / preview).
  static const String stubIdAgente = 'stub-idagente';

  @override
  ConsumerState<LifeEventsPage> createState() => _LifeEventsPageState();
}

class _LifeEventsPageState extends ConsumerState<LifeEventsPage> {
  LifeEventsLoadState? _previousState;

  String _resolveIdAgente() {
    if (widget.idAgente != null && widget.idAgente!.isNotEmpty) {
      return widget.idAgente!;
    }
    final sessionToken = ref.read(sessionStateProvider);
    if (sessionToken != null && sessionToken.isNotEmpty) {
      return sessionToken;
    }
    return LifeEventsPage.stubIdAgente;
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idAgente = _resolveIdAgente();
    final asyncSelection = ref.watch(lifeEventsProvider(idAgente));

    // Side-effects on lifecycle transitions (saved → snackbar, error → snackbar).
    ref.listen<AsyncValue<LifeEventsSelection>>(
      lifeEventsProvider(idAgente),
      (final previous, final next) {
        final value = next.value;
        if (value == null) {
          return;
        }
        if (value.state == LifeEventsLoadState.saved &&
            _previousState != LifeEventsLoadState.saved) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.lifeEventsSavedFeedback)),
            );
          // Auto-acknowledge so the screen returns to the idle baseline.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(lifeEventsProvider(idAgente).notifier)
                  .acknowledgeSaved();
            }
          });
        } else if (value.state == LifeEventsLoadState.error &&
            _previousState != LifeEventsLoadState.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.lifeEventsErrorFeedback)),
            );
        }
        _previousState = value.state;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lifeEventsTitle),
        actions: <Widget>[
          asyncSelection.maybeWhen<Widget>(
            data: (final selection) => _SaveAction(
              selection: selection,
              onSave: () => ref
                  .read(lifeEventsProvider(idAgente).notifier)
                  .save(),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: asyncSelection.when(
        loading: () => LoadingStateWidget(message: l10n.loadingStateDefault),
        error: (final err, final _) => ErrorStateWidget(
          message: l10n.lifeEventsLoadError,
          onRetry: () => ref
              .read(lifeEventsProvider(idAgente).notifier)
              .refresh(),
        ),
        data: (final selection) => _LifeEventsBody(
          selection: selection,
          onToggle: (final id) => ref
              .read(lifeEventsProvider(idAgente).notifier)
              .toggle(id),
          onReset: () => _confirmReset(context, l10n, idAgente),
        ),
      ),
    );
  }

  Future<void> _confirmReset(
    final BuildContext context,
    final AppLocalizations l10n,
    final String idAgente,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final dialogCtx) => AlertDialog(
        title: Text(l10n.lifeEventsResetConfirmTitle),
        content: Text(l10n.lifeEventsResetConfirmBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l10n.lifeEventsResetCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l10n.lifeEventsResetConfirm),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref
          .read(lifeEventsProvider(idAgente).notifier)
          .resetPreferencias();
    }
  }
}

class _SaveAction extends StatelessWidget {
  const _SaveAction({required this.selection, required this.onSave});

  final LifeEventsSelection selection;
  final VoidCallback onSave;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSaving = selection.state == LifeEventsLoadState.saving;
    if (isSaving) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final canSave = selection.isDirty &&
        selection.state != LifeEventsLoadState.saving;
    return TextButton(
      onPressed: canSave ? onSave : null,
      child: Text(l10n.lifeEventsSaveAction),
    );
  }
}

class _LifeEventsBody extends StatelessWidget {
  const _LifeEventsBody({
    required this.selection,
    required this.onToggle,
    required this.onReset,
  });

  final LifeEventsSelection selection;
  final ValueChanged<String> onToggle;
  final VoidCallback onReset;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (selection.state == LifeEventsLoadState.empty ||
        selection.items.isEmpty) {
      return EmptyStateWidget(message: l10n.lifeEventsEmpty);
    }
    final grouped = LifeEventsNotifier.groupByCategory(selection.items);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.space12,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                child: Text(
                  l10n.lifeEventsHeaderDescription,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    key: const ValueKey<String>(
                      'life-events-data-consent-cta',
                    ),
                    onPressed: () =>
                        context.go(Routes.preferencesConsent),
                    icon: const Icon(Icons.shield_outlined),
                    label: Text(l10n.dataConsentNavCta),
                  ),
                ),
              ),
              for (final entry in grouped.entries) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.space16,
                    AppDimensions.space12,
                    AppDimensions.space16,
                    AppDimensions.space4,
                  ),
                  child: Text(
                    _categoryLabel(l10n, entry.key),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                for (final event in entry.value)
                  CheckboxListTile(
                    key: ValueKey<String>('life-event-tile-${event.id}'),
                    title: Text(event.label),
                    value: selection.isSelected(event.id),
                    onChanged: selection.state == LifeEventsLoadState.saving
                        ? null
                        : (_) => onToggle(event.id),
                  ),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: OutlinedButton.icon(
              key: const ValueKey<String>('life-events-reset-button'),
              onPressed: selection.state == LifeEventsLoadState.saving
                  ? null
                  : onReset,
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.lifeEventsResetAction),
            ),
          ),
        ),
      ],
    );
  }

  String _categoryLabel(
    final AppLocalizations l10n,
    final LifeEventCategory category,
  ) {
    switch (category) {
      case LifeEventCategory.familia:
        return l10n.lifeEventsCategoryFamilia;
      case LifeEventCategory.salud:
        return l10n.lifeEventsCategorySalud;
      case LifeEventCategory.empleo:
        return l10n.lifeEventsCategoryEmpleo;
      case LifeEventCategory.vivienda:
        return l10n.lifeEventsCategoryVivienda;
      case LifeEventCategory.educacion:
        return l10n.lifeEventsCategoryEducacion;
    }
  }
}
