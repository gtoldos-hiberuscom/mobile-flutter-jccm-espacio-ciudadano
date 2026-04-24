import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';

/// Lifecycle of the life-events selection screen (STORY-54).
///
/// `initial` is emitted before the first load completes; `loaded` covers the
/// idle interactive state; `saving` and `saved` are short-lived transitions
/// triggered by the explicit save action; `error` covers both load and
/// persistence failures (the notifier exposes the originating action through
/// [LifeEventsSelection.errorMessage]); `empty` is reserved for the case
/// where the catalog returns no items.
enum LifeEventsLoadState {
  initial,
  loading,
  loaded,
  saving,
  saved,
  error,
  empty,
}

/// Immutable snapshot exposed by the life-events notifier.
///
/// Holds the catalog of available [LifeEvent]s, the currently selected ids,
/// the baseline (last persisted) selection used to detect dirty state, and
/// the lifecycle [state]. Pure Dart on purpose — no Flutter, no Riverpod,
/// no infrastructure imports.
final class LifeEventsSelection {
  const LifeEventsSelection({
    required this.items,
    required this.selectedIds,
    required this.baselineIds,
    required this.state,
    this.errorMessage,
  });

  /// Initial empty value used by the notifier before the first load.
  factory LifeEventsSelection.initial() => const LifeEventsSelection(
        items: <LifeEvent>[],
        selectedIds: <String>{},
        baselineIds: <String>{},
        state: LifeEventsLoadState.initial,
      );

  final List<LifeEvent> items;
  final Set<String> selectedIds;
  final Set<String> baselineIds;
  final LifeEventsLoadState state;
  final String? errorMessage;

  /// Whether the current selection differs from the last persisted baseline.
  bool get isDirty {
    if (selectedIds.length != baselineIds.length) {
      return true;
    }
    return !selectedIds.containsAll(baselineIds);
  }

  bool isSelected(final String id) => selectedIds.contains(id);

  LifeEventsSelection copyWith({
    final List<LifeEvent>? items,
    final Set<String>? selectedIds,
    final Set<String>? baselineIds,
    final LifeEventsLoadState? state,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return LifeEventsSelection(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      baselineIds: baselineIds ?? this.baselineIds,
      state: state ?? this.state,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
