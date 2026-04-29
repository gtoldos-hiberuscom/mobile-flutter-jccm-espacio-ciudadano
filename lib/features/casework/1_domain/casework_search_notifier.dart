import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_result.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'casework_search_notifier.g.dart';

/// Aggregated screen state for the casework search page (STORY-39).
///
/// Holds the raw [query] (so inputs round-trip on rebuild), the latest
/// [validation] outcome and the search [result]. The presentation layer
/// renders a single state — there is no implicit cross-coupling with the
/// workspace tabs.
final class CaseworkSearchState {
  const CaseworkSearchState({
    required this.query,
    required this.validation,
    required this.result,
    this.showValidation = false,
  });

  /// Initial idle state used when the screen is opened.
  static const CaseworkSearchState initial = CaseworkSearchState(
    query: CaseworkSearchQuery.empty,
    validation: CaseworkSearchValidation(),
    result: CaseworkSearchResult.idle,
  );

  final CaseworkSearchQuery query;
  final CaseworkSearchValidation validation;
  final CaseworkSearchResult result;

  /// Whether validation messages should be visible. Toggled to true on
  /// the first submit attempt so users are not surprised with errors
  /// before they have interacted with the form.
  final bool showValidation;

  CaseworkSearchState copyWith({
    final CaseworkSearchQuery? query,
    final CaseworkSearchValidation? validation,
    final CaseworkSearchResult? result,
    final bool? showValidation,
  }) => CaseworkSearchState(
    query: query ?? this.query,
    validation: validation ?? this.validation,
    result: result ?? this.result,
    showValidation: showValidation ?? this.showValidation,
  );
}

/// Owns the casework search screen state (STORY-39).
///
/// Validation lives in `0_entity/CaseworkSearchQuery` (pure Dart). The
/// notifier is a thin coordinator that:
///   - keeps the form inputs in sync,
///   - re-validates on every change,
///   - executes the right repository call when the query is valid,
///   - exposes `idle | searching | results | noResults | error` to the UI.
@riverpod
class CaseworkSearchNotifier extends _$CaseworkSearchNotifier {
  @override
  CaseworkSearchState build() => CaseworkSearchState.initial;

  void updateField(final CaseworkSearchField field, final String value) {
    final query = switch (field) {
      CaseworkSearchField.identification => state.query.copyWith(identification: value),
      CaseworkSearchField.expedienteNumber => state.query.copyWith(expedienteNumber: value),
      CaseworkSearchField.registroNumber => state.query.copyWith(registroNumber: value),
    };
    state = state.copyWith(
      query: query,
      validation: query.validate(),
    );
  }

  /// Resets the form back to the idle state — used by the
  /// "Buscar otra cosa" CTA when results are visible.
  void reset() {
    state = CaseworkSearchState.initial;
  }

  /// Executes a search if the query is valid. Surfaces validation
  /// messages otherwise.
  Future<void> submit() async {
    final validation = state.query.validate();
    if (!validation.isValid) {
      state = state.copyWith(
        validation: validation,
        showValidation: true,
      );
      return;
    }
    final field = state.query.firstFilledField;
    if (field == null) {
      // Defensive — `validate()` would have surfaced this already.
      return;
    }
    state = state.copyWith(
      validation: validation,
      showValidation: true,
      result: CaseworkSearchResult.searching(field: field),
    );

    final repo = ref.read(caseworkRepositoryProvider);
    final value = state.query.valueFor(field);
    try {
      final List<CaseworkItem> items = await _execute(repo, field, value);
      state = state.copyWith(
        result: CaseworkSearchResult.success(field: field, items: items),
      );
    } on Object {
      state = state.copyWith(
        result: CaseworkSearchResult.failure(field: field),
      );
    }
  }

  static Future<List<CaseworkItem>> _execute(
    final CaseworkRepository repo,
    final CaseworkSearchField field,
    final String value,
  ) {
    switch (field) {
      case CaseworkSearchField.identification:
        return repo.searchByNif(value);
      case CaseworkSearchField.expedienteNumber:
        return repo.searchByExpedienteNumber(value);
      case CaseworkSearchField.registroNumber:
        return repo.searchByRegistroNumber(value);
    }
  }
}
