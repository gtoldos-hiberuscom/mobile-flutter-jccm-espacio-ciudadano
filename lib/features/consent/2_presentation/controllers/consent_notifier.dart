import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/accept_consent_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/load_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

// ── Status ────────────────────────────────────────────────────────────────────

enum ConsentStatus {
  /// Clause catalogue is being fetched.
  loading,

  /// Step 1 — citizen has not yet scrolled to the bottom of the legal text.
  step1Locked,

  /// Step 1 — citizen reached the end of the scroll; CTA is now active.
  step1Unlocked,

  /// Step 2 — authorisation checkboxes; at least one clause is unchecked.
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

  bool get allClausesSelected =>
      clauses.isNotEmpty && clauses.every((final c) => c.isSelected);

  ConsentState copyWith({
    final ConsentStatus? status,
    final List<Clause>? clauses,
    final String? errorMessage,
  }) =>
      ConsentState(
        status: status ?? this.status,
        clauses: clauses ?? this.clauses,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Owns all business logic for the two-step legal-consent onboarding flow.
///
/// Keyed by [idAgente] so each citizen session gets a fresh notifier state.
/// This avoids stale terminal states (accepted / rejected) if the user
/// re-authenticates within the same app session.
class ConsentNotifier extends Notifier<ConsentState> {
  ConsentNotifier(this._idAgente);
  final String _idAgente;

  @override
  ConsentState build() {
    unawaited(Future.microtask(_loadClauses));
    return const ConsentState();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _loadClauses() async {
    final result =
        await ref.read(loadClausesUsecaseProvider).execute();
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case LoadClausesSuccess(:final clauses):
        state = ConsentState(
          status: ConsentStatus.step1Locked,
          clauses: clauses,
        );
      case LoadClausesFailed():
        // Degrade gracefully — show step 1 with empty clause list so the
        // citizen can still read the legal text and accept.
        state = const ConsentState(status: ConsentStatus.step1Locked);
    }
  }

  // ── Public actions ────────────────────────────────────────────────────────

  /// Called when the citizen's scroll position reaches the bottom of the
  /// legal text in step 1. Unlocks the "Aceptar y continuar" CTA.
  void onScrollReachedEnd() {
    if (state.status == ConsentStatus.step1Locked) {
      state = state.copyWith(status: ConsentStatus.step1Unlocked);
    }
  }

  /// Advances from step 1 to step 2 (authorisation checkboxes).
  void proceedToStep2() {
    if (state.status != ConsentStatus.step1Unlocked) {
      return;
    }
    state = state.copyWith(status: ConsentStatus.step2);
  }

  /// Toggles the selected state of the clause with the given [id].
  void toggleClause(final int id) {
    if (state.status != ConsentStatus.step2 &&
        state.status != ConsentStatus.saveError) {
      return;
    }
    final updated = state.clauses
        .map(
          (final c) => c.id == id ? c.copyWith(isSelected: !c.isSelected) : c,
        )
        .toList(growable: false);
    state = state.copyWith(status: ConsentStatus.step2, clauses: updated);
  }

  /// Marks all clauses as selected.
  void markAll() {
    if (state.status != ConsentStatus.step2 &&
        state.status != ConsentStatus.saveError) {
      return;
    }
    final updated = state.clauses
        .map((final c) => c.copyWith(isSelected: true))
        .toList(growable: false);
    state = state.copyWith(status: ConsentStatus.step2, clauses: updated);
  }

  /// Persists consent acceptance and signals the page to navigate forward.
  Future<void> accept() async {
    if (!state.allClausesSelected ||
        state.status == ConsentStatus.saving) {
      return;
    }
    state = state.copyWith(status: ConsentStatus.saving);
    final result = await ref
        .read(acceptConsentUsecaseProvider)
        .execute(idAgente: _idAgente);
    if (!ref.mounted) {
      return;
    }
    switch (result) {
      case AcceptConsentSuccess():
        state = state.copyWith(status: ConsentStatus.accepted);
      case AcceptConsentFailed(:final message):
        state = state.copyWith(
          status: ConsentStatus.saveError,
          errorMessage: message,
        );
    }
  }

  /// Rejects the consent gate. Clears the in-memory session so the
  /// SessionGuard will not allow re-entry into authenticated routes.
  void reject() {
    ref.read(tokenResponseProvider.notifier).update(null);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(status: ConsentStatus.rejected);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Family provider keyed by `idAgente`.
///
/// Usage: `ref.watch(consentProvider(idAgente))`.
final consentProvider = NotifierProvider.family<
    ConsentNotifier,
    ConsentState,
    String>(ConsentNotifier.new);
