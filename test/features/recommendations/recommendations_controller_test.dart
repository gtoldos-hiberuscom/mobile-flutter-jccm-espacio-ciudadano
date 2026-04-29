import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_controller.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';

class _FakeRecommendationsRepository implements RecommendationsRepository {
  _FakeRecommendationsRepository({
    required this.pages,
    this.failOnLoadMore = false,
    this.failInitial = false,
  });

  /// Successive pages returned by every `loadAll` / `loadBucket` call,
  /// in order. The last entry is reused indefinitely.
  final List<RecommendationsPageResult> pages;
  final bool failOnLoadMore;
  final bool failInitial;
  int callCount = 0;

  @override
  Future<RecommendationsPageResult> loadAll({final String? cursor}) async =>
      _serve(cursor);

  @override
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  }) async => _serve(cursor);

  @override
  Future<RecommendationsConfigState> loadConfigState() async =>
      RecommendationsConfigState.configured;

  Future<RecommendationsPageResult> _serve(final String? cursor) async {
    if (failInitial && cursor == null) {
      throw StateError('boom-initial');
    }
    if (failOnLoadMore && cursor != null) {
      throw StateError('boom-loadmore');
    }
    final index = callCount.clamp(0, pages.length - 1);
    callCount += 1;
    return pages[index];
  }
}

Recommendation _rec(final String id) => Recommendation(
  id: id,
  title: 'Title $id',
  isImmediateProcessing: false,
);

void main() {
  group('RecommendationsController', () {
    test('loadInitial happy path exposes data and hasMore', () async {
      final repo = _FakeRecommendationsRepository(
        pages: [
          RecommendationsPageResult(
            items: [_rec('a'), _rec('b')],
            hasMore: true,
            nextCursor: '2',
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [recommendationsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final state = await container.read(
        recommendationsControllerProvider(RecommendationBucket.todos).future,
      );
      expect(state.items.map((final r) => r.id), ['a', 'b']);
      expect(state.hasMore, isTrue);
      expect(state.nextCursor, '2');
    });

    test('loadMore appends items and flips hasMore on the last page', () async {
      final repo = _FakeRecommendationsRepository(
        pages: [
          RecommendationsPageResult(
            items: [_rec('a'), _rec('b')],
            hasMore: true,
            nextCursor: '2',
          ),
          RecommendationsPageResult(
            items: [_rec('c')],
            hasMore: false,
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [recommendationsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      // Trigger initial.
      await container.read(
        recommendationsControllerProvider(RecommendationBucket.todos).future,
      );
      final notifier = container.read(
        recommendationsControllerProvider(RecommendationBucket.todos).notifier,
      );
      await notifier.loadMore();

      final state = container
          .read(recommendationsControllerProvider(RecommendationBucket.todos))
          .requireValue;
      expect(state.items.map((final r) => r.id), ['a', 'b', 'c']);
      expect(state.hasMore, isFalse);
      expect(state.nextCursor, isNull);

      // Subsequent loadMore is a no-op.
      await notifier.loadMore();
      final after = container
          .read(recommendationsControllerProvider(RecommendationBucket.todos))
          .requireValue;
      expect(after.items, hasLength(3));
    });

    test('initial error surfaces as AsyncError', () async {
      final repo = _FakeRecommendationsRepository(
        pages: [
          RecommendationsPageResult(items: const <Recommendation>[], hasMore: false),
        ],
        failInitial: true,
      );
      final container = ProviderContainer(
        overrides: [recommendationsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(
          recommendationsControllerProvider(RecommendationBucket.todos).future,
        ),
        throwsA(isA<StateError>()),
      );
      final state = container.read(
        recommendationsControllerProvider(RecommendationBucket.todos),
      );
      expect(state.hasError, isTrue);
    });

    test('loadMore error transitions to AsyncError', () async {
      final repo = _FakeRecommendationsRepository(
        pages: [
          RecommendationsPageResult(
            items: [_rec('a')],
            hasMore: true,
            nextCursor: '1',
          ),
        ],
        failOnLoadMore: true,
      );
      final container = ProviderContainer(
        overrides: [recommendationsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(
        recommendationsControllerProvider(RecommendationBucket.todos).future,
      );
      final notifier = container.read(
        recommendationsControllerProvider(RecommendationBucket.todos).notifier,
      );
      await notifier.loadMore();

      final state = container.read(
        recommendationsControllerProvider(RecommendationBucket.todos),
      );
      expect(state.hasError, isTrue);
      expect(state.error, isA<StateError>());
    });
  });
}
