import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/data_consent_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_consent_notifier.g.dart';

/// Owns the data-consent (`clausulas`) state for a given `idAgente`
/// (STORY-55).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).
@riverpod
class DataConsentNotifier extends _$DataConsentNotifier {
  @override
  Future<DataConsentSnapshot> build(final String idAgente) async {
    return _load(idAgente);
  }

  Future<DataConsentSnapshot> _load(final String idAgente) async {
    final repo = ref.read(dataConsentRepositoryProvider);
    final result = await repo.loadClausulas(idAgente);
    final draft = <String, bool>{
      for (final c in result.items) c.id: c.accepted,
    };
    final baseline = <String, bool>{
      for (final c in result.items) c.id: c.accepted,
    };
    return DataConsentSnapshot(
      items: result.items,
      draft: draft,
      baseline: baseline,
      state: result.items.isEmpty ? DataConsentLoadState.empty : DataConsentLoadState.loaded,
    );
  }

  /// Toggles [consentId] in the draft. No-op if no data is loaded.
  void toggle(final String consentId) {
    final current = state.value;
    if (current == null) {
      return;
    }
    if (!current.draft.containsKey(consentId)) {
      return;
    }
    final next = Map<String, bool>.from(current.draft);
    next[consentId] = !(next[consentId] ?? false);
    state = AsyncValue<DataConsentSnapshot>.data(
      current.copyWith(
        draft: next,
        state: DataConsentLoadState.loaded,
        clearError: true,
      ),
    );
  }

  /// Persists the current draft. Emits `saving` then `saved`, advances the
  /// baseline on success, and surfaces an error snapshot on failure.
  Future<void> save() async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<DataConsentSnapshot>.data(
      current.copyWith(
        state: DataConsentLoadState.saving,
        clearError: true,
      ),
    );
    try {
      final acceptance = <DataConsentType, bool>{
        for (final c in current.items) c.type: current.draft[c.id] ?? false,
      };
      await ref.read(dataConsentRepositoryProvider).saveClausulas(idAgente, acceptance);
      state = AsyncValue<DataConsentSnapshot>.data(
        current.copyWith(
          baseline: Map<String, bool>.from(current.draft),
          state: DataConsentLoadState.saved,
          clearError: true,
        ),
      );
    } catch (e) {
      state = AsyncValue<DataConsentSnapshot>.data(
        current.copyWith(
          state: DataConsentLoadState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Acknowledges the transient `saved` flash and returns to `loaded`.
  void acknowledgeSaved() {
    final current = state.value;
    if (current == null || current.state != DataConsentLoadState.saved) {
      return;
    }
    state = AsyncValue<DataConsentSnapshot>.data(
      current.copyWith(state: DataConsentLoadState.loaded),
    );
  }

  /// Revokes every consent via
  /// `DELETE /hechos-vitales/preferencias/{idAgente}` (mocked) and resets
  /// both the draft and the baseline to all-false.
  Future<void> revokeAll() async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<DataConsentSnapshot>.data(
      current.copyWith(
        state: DataConsentLoadState.saving,
        clearError: true,
      ),
    );
    try {
      await ref.read(dataConsentRepositoryProvider).revokeAll(idAgente);
      final cleared = <String, bool>{
        for (final c in current.items) c.id: false,
      };
      state = AsyncValue<DataConsentSnapshot>.data(
        current.copyWith(
          draft: cleared,
          baseline: Map<String, bool>.from(cleared),
          state: DataConsentLoadState.saved,
          clearError: true,
        ),
      );
    } catch (e) {
      state = AsyncValue<DataConsentSnapshot>.data(
        current.copyWith(
          state: DataConsentLoadState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Reloads the catalog from the repository, discarding any unsaved edits.
  Future<void> refresh() async {
    state = const AsyncValue<DataConsentSnapshot>.loading();
    state = await AsyncValue.guard<DataConsentSnapshot>(
      () => _load(idAgente),
    );
  }
}
