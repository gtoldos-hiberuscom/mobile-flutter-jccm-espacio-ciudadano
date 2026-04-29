import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';
import 'package:meta/meta.dart';

/// Per-bucket state held by [RecommendationsController].
///
/// Pure data — exposed publicly so widget tests can assert against
/// `hasMore` without reaching for repository internals.
@immutable
final class RecommendationsBucketState {
  const RecommendationsBucketState({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  static const RecommendationsBucketState empty = RecommendationsBucketState(
    items: <Recommendation>[],
    hasMore: false,
  );

  final List<Recommendation> items;
  final bool hasMore;
  final String? nextCursor;
}

/// Riverpod controller for one segmentation bucket of *Mis
/// Recomendaciones*.
///
/// Plain Riverpod (no codegen). Family argument is the
/// [RecommendationBucket] — the same notifier class is reused for all
/// four buckets. The argument is accessed via `ref.$arg` per the
/// Riverpod 3 family contract.
class RecommendationsController extends AsyncNotifier<RecommendationsBucketState> {
  RecommendationsController(this.bucket);

  /// Family argument — the segmentation bucket this controller owns.
  final RecommendationBucket bucket;

  @override
  Future<RecommendationsBucketState> build() async {
    final repo = ref.read(recommendationsRepositoryProvider);
    final page = await _fetch(repo, bucket, cursor: null);
    return RecommendationsBucketState(
      items: page.items,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  /// Re-runs the initial fetch for this bucket. Useful for explicit
  /// retry from the error state.
  Future<void> loadInitial() async {
    state = const AsyncValue<RecommendationsBucketState>.loading();
    state = await AsyncValue.guard<RecommendationsBucketState>(() async {
      final repo = ref.read(recommendationsRepositoryProvider);
      final page = await _fetch(repo, bucket, cursor: null);
      return RecommendationsBucketState(
        items: page.items,
        hasMore: page.hasMore,
        nextCursor: page.nextCursor,
      );
    });
  }

  /// Appends the next page when [RecommendationsBucketState.hasMore] is
  /// `true`. Silent no-op otherwise so callers can safely fire it from
  /// scroll listeners without double-checking.
  ///
  /// On failure, the notifier transitions to [AsyncError] — callers
  /// (widgets / tests) can react via `ref.listen`.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore) {
      return;
    }
    final cursor = current.nextCursor;
    if (cursor == null) {
      return;
    }
    final repo = ref.read(recommendationsRepositoryProvider);
    try {
      final page = await _fetch(repo, bucket, cursor: cursor);
      state = AsyncValue<RecommendationsBucketState>.data(
        RecommendationsBucketState(
          items: <Recommendation>[...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
        ),
      );
    } on Object catch (error, stack) {
      state = AsyncValue<RecommendationsBucketState>.error(error, stack);
    }
  }

  Future<RecommendationsPageResult> _fetch(
    final RecommendationsRepository repo,
    final RecommendationBucket bucket, {
    required final String? cursor,
  }) {
    if (bucket == RecommendationBucket.todos) {
      return repo.loadAll(cursor: cursor);
    }
    return repo.loadBucket(bucket, cursor: cursor);
  }
}

/// Family provider keyed by [RecommendationBucket].
final recommendationsControllerProvider =
    AsyncNotifierProvider.family<
      RecommendationsController,
      RecommendationsBucketState,
      RecommendationBucket
    >(RecommendationsController.new);
