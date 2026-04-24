import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_query.dart';

/// Lifecycle of a casework search (STORY-39).
///
/// The presentation layer maps each value to a `core/ui_states/`
/// scaffold (loading, empty, error) plus a dedicated "no results found"
/// state distinct from validation errors.
enum CaseworkSearchStatus {
  /// No search has been executed yet.
  idle,

  /// A search is in flight.
  searching,

  /// Search succeeded and yielded one or more items.
  results,

  /// Search succeeded but returned zero items.
  noResults,

  /// Search failed (network, server, parsing…).
  error,
}

/// Outcome of a casework search request.
///
/// Pure Dart — no Flutter, Riverpod or infrastructure imports.
final class CaseworkSearchResult {
  const CaseworkSearchResult({
    required this.status,
    this.items = const <CaseworkItem>[],
    this.executedField,
  });

  /// Initial result — before any search.
  static const CaseworkSearchResult idle = CaseworkSearchResult(
    status: CaseworkSearchStatus.idle,
  );

  factory CaseworkSearchResult.searching({
    required final CaseworkSearchField field,
  }) => CaseworkSearchResult(
    status: CaseworkSearchStatus.searching,
    executedField: field,
  );

  factory CaseworkSearchResult.success({
    required final CaseworkSearchField field,
    required final List<CaseworkItem> items,
  }) => CaseworkSearchResult(
    status: items.isEmpty ? CaseworkSearchStatus.noResults : CaseworkSearchStatus.results,
    items: items,
    executedField: field,
  );

  factory CaseworkSearchResult.failure({
    required final CaseworkSearchField field,
  }) => CaseworkSearchResult(
    status: CaseworkSearchStatus.error,
    executedField: field,
  );

  final CaseworkSearchStatus status;
  final List<CaseworkItem> items;

  /// Field that was used to execute the last search (null when [status]
  /// is [CaseworkSearchStatus.idle]).
  final CaseworkSearchField? executedField;
}
