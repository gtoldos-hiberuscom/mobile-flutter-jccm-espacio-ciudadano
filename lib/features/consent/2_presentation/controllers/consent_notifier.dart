import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/accept_consent_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/load_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/mark_life_events_onboarding_seen_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/save_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_usecase_providers.dart';

/// Marker recorded in [ConsentState.errorMessage] when [ConsentNotifier.accept]
/// was blocked because the clause catalogue never loaded (P-04 guard). Pages
/// map it to a curated localized message; it is never shown raw.
const consentClauseCatalogueUnavailable = 'consent-clause-catalogue-unavailable';

// ── Status ────────────────────────────────────────────────────────────────────

enum ConsentStatus {
  /// Clause catalogue is being fetched.
  loading,

  /// The clause catalogue could not be loaded — show an explicit error with
  /// retry instead of a legal screen with zero authorisations.
  loadError,

  /// Step 1 — citizen has not yet scrolled to the bottom of the legal text.
  step1Locked,

  /// Step 1 — citizen reached the end of the scroll; CTA is now active.
  step1Unlocked,

  /// Step 2 — optional authorisation checkboxes.
  step2,

  /// Saving acceptance to storage.
  saving,

  /// Acceptance persisted — navigate forward.
  accepted,

  /// Citizen rejected the consent — clear session and navigate to landing.
  rejected,

  /// Saving failed — show error feedback, stay in step 2.
  saveError,
}

// ── State ─────────────────────────────────────────────────────────────────────

/// Immutable UI state for the two-step consent onboarding flow.
final class ConsentState {
  const ConsentState({
    this.status = ConsentStatus.loading,
    this.clauses = const [],
    this.errorMessage,
  });

  final ConsentStatus status;
  final List<Clause> clauses;
  final String? errorMessage;

  ConsentState copyWith({
    final ConsentStatus? status,
    final List<Clause>? clauses,
    final String? errorMessage,
  }) => ConsentState(
    status: status ?? this.status,
    clauses: clauses ?? this.clauses,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Owns all business logic for the two-step legal-consent onboarding flow.
///
/// Keyed by idAgente so each citizen session gets a fresh notifier state.
/// This avoids stale terminal states (accepted / rejected) if the user
/// re-authenticates within the same app session.
class ConsentNotifier extends Notifier<ConsentState> {
  ConsentNotifier(this._idAgente);
  final String _idAgente;
  bool _isPreferencesEditing = false;
  bool _hasReachedLegalTextEnd = false;
  Set<int> _initialSelectedClauseIds = const {};

  @override
  ConsentState build() {
    unawaited(Future.microtask(_loadClauses));
    return const ConsentState();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _loadClauses() async {
    final result = await ref.read(loadClausesUsecaseProvider).execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return;
    }
    if (_isPreferencesEditing) {
      return;
    }
    switch (result) {
      case LoadClausesSuccess(:final clauses):
        state = ConsentState(
          status: _hasReachedLegalTextEnd ? ConsentStatus.step1Unlocked : ConsentStatus.step1Locked,
          clauses: clauses,
        );
      case LoadClausesFailed(:final message):
        // Error explícito con reintento: degradar a un paso legal sin ninguna
        // autorización visible confundía "catálogo caído" con "no hay
        // autorizaciones opcionales" (el guard P-04 bloqueaba después, pero
        // demasiado tarde para explicar qué pasaba).
        logger.e('Consent clause catalogue load failed: $message');
        state = const ConsentState(status: ConsentStatus.loadError);
    }
  }

  /// Reintento manual tras [ConsentStatus.loadError].
  Future<void> retryLoadClauses() {
    state = const ConsentState();
    return _loadClauses();
  }

  // ── Public actions ────────────────────────────────────────────────────────

  /// Called when the citizen's scroll position reaches the bottom of the
  /// legal text in step 1. Unlocks the "Continuar" CTA.
  void onScrollReachedEnd() {
    _hasReachedLegalTextEnd = true;
    if (state.status == ConsentStatus.step1Locked) {
      state = state.copyWith(status: ConsentStatus.step1Unlocked);
    }
  }

  /// Advances from the data-protection screen to the authorisation checkboxes.
  void proceedToStep2() {
    if (state.status != ConsentStatus.step1Locked && state.status != ConsentStatus.step1Unlocked) {
      return;
    }
    state = state.copyWith(status: ConsentStatus.step2);
  }

  /// Toggles the selected state of the clause with the given [id].
  void toggleClause(final int id) {
    if (id == requiredConsentClauseId) {
      return;
    }
    if (state.status != ConsentStatus.step2 && state.status != ConsentStatus.saveError) {
      return;
    }
    final updated = state.clauses
        .map(
          (final c) => c.id == id ? c.copyWith(isSelected: !c.isSelected) : c,
        )
        .toList(growable: false);
    state = state.copyWith(status: ConsentStatus.step2, clauses: updated);
  }

  /// Persists consent choices and signals the page to navigate forward.
  Future<void> accept({
    final bool persistSession = true,
  }) async {
    if (state.status == ConsentStatus.saving) {
      return;
    }
    var clausesToPersist = _clausesForPersistence(state.clauses);
    if (!_isPreferencesEditing && !clausesToPersist.any((final clause) => clause.id == requiredConsentClauseId)) {
      // P-04 guard: the catalogue never loaded, so accepting would POST a body
      // without clause 0 — the backend records it and every later read reports
      // the consent as pending forever. Retry the load once, then block.
      state = state.copyWith(status: ConsentStatus.saving);
      final reload = await ref.read(loadClausesUsecaseProvider).execute(idAgente: _idAgente);
      if (!ref.mounted) {
        return;
      }
      final reloadedClauses = switch (reload) {
        LoadClausesSuccess(:final clauses) => clauses,
        LoadClausesFailed() => const <Clause>[],
      };
      if (!reloadedClauses.any((final clause) => clause.id == requiredConsentClauseId)) {
        logger.e('Consent accept blocked: clause catalogue unavailable (P-04 guard)');
        state = state.copyWith(
          status: ConsentStatus.saveError,
          errorMessage: consentClauseCatalogueUnavailable,
        );
        return;
      }
      clausesToPersist = _clausesForPersistence(reloadedClauses);
      state = state.copyWith(clauses: reloadedClauses);
    }
    state = state.copyWith(status: ConsentStatus.saving);
    // La limpieza de hechos vitales va ANTES de persistir las cláusulas: se
    // ejecuta con la autorización de recomendaciones todavía viva en el
    // backend, y si falla no se ha tocado nada — reintentar deja todo íntegro.
    final clearError = await _clearLifeEventsSelectionIfRecommendationsClauseRevoked(clausesToPersist);
    if (!ref.mounted) {
      return;
    }
    if (clearError != null) {
      state = state.copyWith(
        status: ConsentStatus.saveError,
        errorMessage: clearError,
      );
      return;
    }
    final result = await ref.read(acceptConsentUsecaseProvider).execute(idAgente: _idAgente, clauses: clausesToPersist);
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case AcceptConsentSuccess():
        final onboardingError = await _skipLifeEventsOnboardingIfClauseWasEnabledFromPreferences(clausesToPersist);
        if (!ref.mounted) {
          return;
        }
        if (onboardingError != null) {
          state = ConsentState(
            status: ConsentStatus.saveError,
            clauses: clausesToPersist,
            errorMessage: onboardingError,
          );
          return;
        }
        if (persistSession) {
          final sessionPersisted = await _persistCurrentSession();
          if (!ref.mounted) {
            return;
          }
          if (!sessionPersisted) {
            state = ConsentState(
              status: ConsentStatus.saveError,
              clauses: clausesToPersist,
            );
            return;
          }
        }
        state = state.copyWith(status: ConsentStatus.accepted);
      case AcceptConsentFailed(:final message):
        state = state.copyWith(
          status: ConsentStatus.saveError,
          errorMessage: message,
        );
    }
  }

  List<Clause> _clausesForPersistence(final List<Clause> clauses) {
    return clauses
        .map(
          (final clause) => clause.id == requiredConsentClauseId ? clause.copyWith(isSelected: true) : clause,
        )
        .toList(growable: false);
  }

  Future<String?> _skipLifeEventsOnboardingIfClauseWasEnabledFromPreferences(final List<Clause> clauses) async {
    if (!_isPreferencesEditing || _initialSelectedClauseIds.contains(recommendationsConsentClauseId)) {
      return null;
    }
    final lifeEventsClauseSelected = clauses.any((final clause) => clause.id == recommendationsConsentClauseId && clause.isSelected);
    if (!lifeEventsClauseSelected) {
      return null;
    }
    final result = await ref.read(markLifeEventsOnboardingSeenUsecaseProvider).execute(idAgente: _idAgente);
    return switch (result) {
      MarkLifeEventsOnboardingSeenSuccess() => null,
      MarkLifeEventsOnboardingSeenFailed(:final message) => message,
    };
  }

  /// Limpia la selección de hechos vitales cuando la cláusula de
  /// recomendaciones pasa de aceptada a retirada editando desde Preferencias.
  ///
  /// Mismo esquive que `LifeEventsNotifier.confirmReset`: se persiste el
  /// catálogo deseleccionado (`PATCH /hechos`), nunca `DELETE /preferencias` —
  /// en el gateway ese DELETE arrasa el soporte completo del ciudadano,
  /// cláusulas incluidas, y lo deja irrecuperable: todo pasa a responder el
  /// sobre 412.00/3034 y ni re-aceptar el consentimiento lo repara.
  Future<String?> _clearLifeEventsSelectionIfRecommendationsClauseRevoked(final List<Clause> clauses) async {
    if (!_isPreferencesEditing || !_initialSelectedClauseIds.contains(recommendationsConsentClauseId)) {
      return null;
    }
    final recommendationsClauseSelected = clauses.any(
      (final clause) => clause.id == recommendationsConsentClauseId && clause.isSelected,
    );
    if (recommendationsClauseSelected) {
      return null;
    }
    final loadResult = await ref.read(loadLifeEventsUsecaseProvider).execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return null;
    }
    final List<LifeEvent> events;
    switch (loadResult) {
      case LoadLifeEventsSuccess(events: final loadedEvents):
        events = loadedEvents;
      case LoadLifeEventsFailed(:final message):
        return message;
    }
    if (events.every((final event) => !event.selected)) {
      return null;
    }
    final clearedEvents = events.map((final event) => event.copyWith(selected: false)).toList(growable: false);
    final saveResult = await ref.read(saveLifeEventsUsecaseProvider).execute(idAgente: _idAgente, events: clearedEvents);
    return switch (saveResult) {
      SaveLifeEventsSuccess() => null,
      SaveLifeEventsFailed(:final message) => message,
    };
  }

  Future<bool> _persistCurrentSession() async {
    try {
      return await ref.read(authSessionControllerProvider).persistCurrentSession();
    } on Object {
      return false;
    }
  }

  /// Rejects the consent gate. Clears persisted and in-memory session state so
  /// the SessionGuard will not allow re-entry into authenticated routes. When
  /// possible it also terminates the federated Cl@ve session so the next access
  /// asks for credentials again.
  Future<void> reject() async {
    try {
      final idToken = ref.read(tokenResponseProvider)?.idToken ?? '';
      if (idToken.isNotEmpty) {
        await ref.read(logoutUseCaseProvider).call(idToken: idToken);
      }
    } finally {
      await ref.read(authSessionControllerProvider).clear();
    }
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(status: ConsentStatus.rejected);
  }

  /// Opens the authorisation list as an editable preference surface.
  ///
  /// This bypasses the legal-text gate because the citizen has already
  /// accepted the global consent flow; it only edits optional clauses.
  Future<void> enterPreferencesEditing() async {
    if (state.status == ConsentStatus.step2 || state.status == ConsentStatus.saving) {
      return;
    }
    _isPreferencesEditing = true;
    state = const ConsentState();
    final result = await ref.read(loadClausesUsecaseProvider).execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case LoadClausesSuccess(:final clauses):
        _initialSelectedClauseIds = clauses.where((final clause) => clause.isSelected).map((final clause) => clause.id).toSet();
        state = ConsentState(
          status: ConsentStatus.step2,
          clauses: clauses,
        );
      case LoadClausesFailed(:final message):
        state = ConsentState(
          status: ConsentStatus.saveError,
          errorMessage: message,
        );
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Family provider keyed by `idAgente`.
///
/// Usage: `ref.watch(consentProvider(idAgente))`.
final consentProvider = NotifierProvider.autoDispose.family<ConsentNotifier, ConsentState, String>(ConsentNotifier.new);
