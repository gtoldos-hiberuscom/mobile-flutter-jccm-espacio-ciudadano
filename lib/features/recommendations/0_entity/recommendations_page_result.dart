import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:meta/meta.dart';

/// One page of recommendations returned by the repository.
///
/// Cursor-based pagination per TASK-58 §D6. The mock encodes the cursor
/// as a stringified offset; the live implementation may switch to opaque
/// continuation tokens without changing this contract.
@immutable
final class RecommendationsPageResult {
  const RecommendationsPageResult({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  final List<Recommendation> items;

  /// `true` when at least one more page is available for the same query.
  final bool hasMore;

  /// Opaque cursor passed back into the repository to fetch the next
  /// page. `null` when [hasMore] is `false`.
  final String? nextCursor;

  /// Convenience for an empty terminal page.
  static const RecommendationsPageResult empty = RecommendationsPageResult(
    items: <Recommendation>[],
    hasMore: false,
  );
}
