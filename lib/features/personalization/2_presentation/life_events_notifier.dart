import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/reset_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/save_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_usecase_providers.dart';

// ── State ─────────────────────────────────────────────────────────────────────

/// Possible lifecycle statuses for the life-events screen.
enum LifeEventsStatus {
  /// Initial value before any load has started.
  initial,

  /// A network load is in progress.
  loading,

  /// Events have been loaded and at least one event exists.
  loaded,

  /// Events loaded successfully but the list is empty.
  empty,

  /// A load attempt failed.
  loadError,

  /// A save operation is in progress.
  saving,

  /// Last save completed successfully.
  saveSuccess,

  /// Last save failed.
  saveError,

  /// A preference-reset operation is in progress.
  resetting,

  /// Last reset completed successfully (transient — immediately followed by reload).
  resetSuccess,

  /// Last reset failed.
  resetError,
}

/// Immutable UI state for the life-events selection screen.
final class LifeEventsState {
  const LifeEventsState({
    this.status = LifeEventsStatus.initial,
    this.events = const [],
    this.isDirty = false,
    this.errorMessage,
    this.showResetConfirm = false,
  });

  /// Current lifecycle status.
  final LifeEventsStatus status;

  /// Ordered list of life events — empty until first successful load.
  final List<LifeEvent> events;

  /// `true` when any event selection has changed since the last save/reset.
  final bool isDirty;

  /// Human-readable error detail. Non-null only on error statuses.
  final String? errorMessage;

  /// When `true` the reset-confirmation dialog should be displayed.
  final bool showResetConfirm;

  /// Returns a copy with the given fields replaced.
  LifeEventsState copyWith({
    final LifeEventsStatus? status,
    final List<LifeEvent>? events,
    final bool? isDirty,
    final String? errorMessage,
    final bool? showResetConfirm,
  }) =>
      LifeEventsState(
        status: status ?? this.status,
        events: events ?? this.events,
        isDirty: isDirty ?? this.isDirty,
        errorMessage: errorMessage ?? this.errorMessage,
        showResetConfirm: showResetConfirm ?? this.showResetConfirm,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Owns all business logic for the life-events selection screen.
///
/// In Riverpod 3 the family argument is passed to the constructor via the
/// `NotifierProvider.family` create function; [Notifier.build] has no
/// parameters. [_idAgente] is stored from the constructor for use in async
/// operations.
class LifeEventsNotifier extends Notifier<LifeEventsState> {
  LifeEventsNotifier(this._idAgente);

  /// The citizen identifier supplied when the family was constructed.
  final String _idAgente;

  @override
  LifeEventsState build() {
    // Kick off the load after the current frame so `build` returns synchronously.
    unawaited(Future.microtask(_load));
    // Mark onboarding seen as a silent best-effort side-effect.
    unawaited(Future.microtask(_markOnboardingSeen));
    return const LifeEventsState(status: LifeEventsStatus.loading);
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _markOnboardingSeen() async {
    if (_idAgente.isEmpty) {
      return;
    }
    await ref
        .read(markLifeEventsOnboardingSeenUsecaseProvider)
        .execute(idAgente: _idAgente);
  }

  Future<void> _load() async {
    state = const LifeEventsState(status: LifeEventsStatus.loading);
    final result = await ref
        .read(loadLifeEventsUsecaseProvider)
        .execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case LoadLifeEventsSuccess(:final events):
        state = events.isEmpty
            ? const LifeEventsState(status: LifeEventsStatus.empty)
            : LifeEventsState(status: LifeEventsStatus.loaded, events: events);
      case LoadLifeEventsFailed(:final message):
        state = LifeEventsState(
          status: LifeEventsStatus.loadError,
          errorMessage: message,
        );
    }
  }

  // ── Public actions ────────────────────────────────────────────────────────

  /// Flips the selection state of the event with the given [id].
  void toggle(final int id) {
    final updated = state.events
        .map((final e) => e.id == id ? e.copyWith(selected: !e.selected) : e)
        .toList(growable: false);
    state = state.copyWith(
      status: LifeEventsStatus.loaded,
      events: updated,
      isDirty: true,
    );
  }

  /// Persists the current selection to the backend.
  Future<void> save() async {
    if (state.status == LifeEventsStatus.saving) {
      return;
    }
    state = state.copyWith(status: LifeEventsStatus.saving);
    final result = await ref.read(saveLifeEventsUsecaseProvider).execute(
          idAgente: _idAgente,
          events: state.events,
        );
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case SaveLifeEventsSuccess():
        state = state.copyWith(
          status: LifeEventsStatus.saveSuccess,
          isDirty: false,
        );
      case SaveLifeEventsFailed(:final message):
        state = state.copyWith(
          status: LifeEventsStatus.saveError,
          errorMessage: message,
        );
    }
  }

  /// Requests display of the reset-confirmation dialog.
  void requestReset() => state = state.copyWith(showResetConfirm: true);

  /// Dismisses the reset-confirmation dialog without taking action.
  void cancelReset() => state = state.copyWith(showResetConfirm: false);

  /// Executes the preference reset and reloads the catalogue.
  Future<void> confirmReset() async {
    state = state.copyWith(
      showResetConfirm: false,
      status: LifeEventsStatus.resetting,
    );
    final result = await ref
        .read(resetLifeEventsUsecaseProvider)
        .execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case ResetLifeEventsSuccess():
        state = const LifeEventsState(status: LifeEventsStatus.resetSuccess);
        await _load();
      case ResetLifeEventsFailed(:final message):
        state = state.copyWith(
          status: LifeEventsStatus.resetError,
          errorMessage: message,
        );
    }
  }

  /// Retries a failed load operation.
  Future<void> retry() => _load();
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Family provider keyed by `idAgente`.
///
/// Usage: `ref.watch(lifeEventsProvider(idAgente))`.
final lifeEventsProvider = NotifierProvider.family<
    LifeEventsNotifier,
    LifeEventsState,
    String>(LifeEventsNotifier.new);
