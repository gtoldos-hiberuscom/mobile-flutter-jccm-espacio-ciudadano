import 'dart:async' show unawaited;

import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/mark_life_events_onboarding_seen_usecase.dart';
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

  /// Last reset completed successfully.
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
  }) => LifeEventsState(
    status: status ?? this.status,
    events: events ?? this.events,
    isDirty: isDirty ?? this.isDirty,
    errorMessage: errorMessage ?? this.errorMessage,
    showResetConfirm: showResetConfirm ?? this.showResetConfirm,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

typedef LifeEventsProviderArgs = ({
  String idAgente,
  bool clearSelectionsOnLoad,
});

/// Owns all business logic for the life-events selection screen.
///
/// In Riverpod 3 the family argument is passed to the constructor via the
/// `NotifierProvider.family` create function; [Notifier.build] has no
/// parameters. The arguments are stored from the constructor for use in async
/// operations.
class LifeEventsNotifier extends Notifier<LifeEventsState> {
  LifeEventsNotifier(this._args);

  final LifeEventsProviderArgs _args;

  String get _idAgente => _args.idAgente;

  bool get _clearSelectionsOnLoad => _args.clearSelectionsOnLoad;

  @override
  LifeEventsState build() {
    // Kick off the load after the current frame so `build` returns synchronously.
    unawaited(Future.microtask(_load));
    return const LifeEventsState(status: LifeEventsStatus.loading);
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<MarkLifeEventsOnboardingSeenResult?> _markOnboardingSeen() async {
    if (!_clearSelectionsOnLoad || _idAgente.isEmpty) {
      return null;
    }
    return ref.read(markLifeEventsOnboardingSeenUsecaseProvider).execute(idAgente: _idAgente);
  }

  Future<void> _load() async {
    state = const LifeEventsState(status: LifeEventsStatus.loading);
    final result = await ref.read(loadLifeEventsUsecaseProvider).execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case LoadLifeEventsSuccess(:final events):
        final resolvedEvents = _clearSelectionsOnLoad ? events.map((final event) => event.copyWith(selected: false)).toList(growable: false) : events;
        state = resolvedEvents.isEmpty ? const LifeEventsState(status: LifeEventsStatus.empty) : LifeEventsState(status: LifeEventsStatus.loaded, events: resolvedEvents);
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
    final updated = state.events.map((final e) => e.id == id ? e.copyWith(selected: !e.selected) : e).toList(growable: false);
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
    await _refreshSessionIfNeeded();
    var result = await _saveCurrentEvents();
    if (result case SaveLifeEventsFailed(:final cause) when _isUnauthorized(cause)) {
      final refreshed = await _refreshSession(force: true);
      if (ref.mounted && refreshed) {
        result = await _saveCurrentEvents();
      }
    }
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case SaveLifeEventsSuccess():
        final onboardingResult = await _markOnboardingSeen();
        if (!ref.mounted) {
          return;
        }
        if (onboardingResult case MarkLifeEventsOnboardingSeenFailed(:final message)) {
          state = state.copyWith(
            status: LifeEventsStatus.saveError,
            errorMessage: message,
          );
          return;
        }
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

  /// Executes the preference reset and restores the catalogue without selections.
  Future<void> confirmReset() async {
    final clearedEvents = state.events.map((final event) => event.copyWith(selected: false)).toList(growable: false);
    state = state.copyWith(
      showResetConfirm: false,
      status: LifeEventsStatus.resetting,
    );
    // DELETE /preferencias leaves GET /hechos/{idAgente} failing with 500.
    // Persist the existing catalogue cleared instead: this action removes only
    // the selected life events described by the confirmation dialog.
    final result = await ref
        .read(saveLifeEventsUsecaseProvider)
        .execute(
          idAgente: _idAgente,
          events: clearedEvents,
        );
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case SaveLifeEventsSuccess():
        state = LifeEventsState(
          status: clearedEvents.isEmpty ? LifeEventsStatus.empty : LifeEventsStatus.resetSuccess,
          events: clearedEvents,
        );
      case SaveLifeEventsFailed(:final message):
        state = state.copyWith(
          status: LifeEventsStatus.resetError,
          errorMessage: message,
        );
    }
  }

  /// Retries a failed load operation.
  Future<void> retry() => _load();

  Future<SaveLifeEventsResult> _saveCurrentEvents() {
    return ref
        .read(saveLifeEventsUsecaseProvider)
        .execute(
          idAgente: _idAgente,
          events: state.events,
        );
  }

  Future<void> _refreshSessionIfNeeded() async {
    final expiresAt = ref.read(tokenResponseProvider)?.accessTokenExpirationDateTime;
    if (expiresAt == null || expiresAt.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
      await _refreshSession();
    }
  }

  Future<bool> _refreshSession({final bool force = false}) async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final currentExpiry = ref.read(tokenResponseProvider)?.accessTokenExpirationDateTime;
    if (!force && currentExpiry != null && currentExpiry.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
      return true;
    }

    try {
      final TokenResponse newSession = await ref.read(authRepositoryProvider).refreshToken(refreshToken: refreshToken);
      await Future.wait([
        if (newSession.accessToken != null) storage.write(StorageKeys.accessToken, newSession.accessToken!),
        if (newSession.refreshToken != null) storage.write(StorageKeys.refreshToken, newSession.refreshToken!),
        if (newSession.accessTokenExpirationDateTime != null)
          storage.write(
            StorageKeys.sessionExpiresAt,
            newSession.accessTokenExpirationDateTime!.toIso8601String(),
          ),
      ]);
      if (!ref.mounted) {
        return false;
      }
      ref.read(tokenResponseProvider.notifier).update(newSession);
      return true;
    } on Object {
      await Future.wait([
        storage.delete(StorageKeys.accessToken),
        storage.delete(StorageKeys.refreshToken),
        storage.delete(StorageKeys.sessionExpiresAt),
      ]);
      if (ref.mounted) {
        ref.read(tokenResponseProvider.notifier).update(null);
      }
      return false;
    }
  }

  bool _isUnauthorized(final Object? cause) {
    return cause is DioException && cause.error is UnauthorizedError;
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Family provider keyed by `idAgente` and entry mode.
///
/// Usage:
/// `ref.watch(lifeEventsProvider((idAgente: idAgente, clearSelectionsOnLoad: true)))`.
final lifeEventsProvider = NotifierProvider.family<LifeEventsNotifier, LifeEventsState, LifeEventsProviderArgs>(LifeEventsNotifier.new);
