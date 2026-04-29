import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_mock.dart';

void main() {
  group('RecommendationsRepositoryMock', () {
    test('loadConfigState returns the configured value', () async {
      final repo = RecommendationsRepositoryMock();
      expect(await repo.loadConfigState(), RecommendationsConfigState.configured);

      final unconfigured = RecommendationsRepositoryMock(
        configState: RecommendationsConfigState.unconfigured,
      );
      expect(
        await unconfigured.loadConfigState(),
        RecommendationsConfigState.unconfigured,
      );
    });

    test('loadAll paginates all 14 fixture entries with page size 6', () async {
      final repo = RecommendationsRepositoryMock();
      final p1 = await repo.loadAll();
      expect(p1.items, hasLength(6));
      expect(p1.hasMore, isTrue);
      expect(p1.nextCursor, '6');

      final p2 = await repo.loadAll(cursor: p1.nextCursor);
      expect(p2.items, hasLength(6));
      expect(p2.hasMore, isTrue);
      expect(p2.nextCursor, '12');

      final p3 = await repo.loadAll(cursor: p2.nextCursor);
      expect(p3.items, hasLength(2));
      expect(p3.hasMore, isFalse);
      expect(p3.nextCursor, isNull);

      final all = <String>[
        for (final r in p1.items) r.id,
        for (final r in p2.items) r.id,
        for (final r in p3.items) r.id,
      ];
      expect(all.toSet(), hasLength(14));
    });

    test('past-the-end cursor yields the empty terminal page', () async {
      final repo = RecommendationsRepositoryMock();
      final result = await repo.loadAll(cursor: '999');
      expect(result.items, isEmpty);
      expect(result.hasMore, isFalse);
      expect(result.nextCursor, isNull);
    });

    test('invalid cursor falls back to offset 0', () async {
      final repo = RecommendationsRepositoryMock();
      final result = await repo.loadAll(cursor: 'not-a-number');
      expect(result.items, hasLength(6));
    });

    test('loadBucket(todos) is symmetric with loadAll', () async {
      final repo = RecommendationsRepositoryMock();
      final viaBucket = await repo.loadBucket(RecommendationBucket.todos);
      final viaAll = await repo.loadAll();
      expect(
        viaBucket.items.map((final r) => r.id),
        viaAll.items.map((final r) => r.id),
      );
    });

    test('ultimosDias bucket returns ~4 entries within last 7 days', () async {
      final repo = RecommendationsRepositoryMock();
      final p1 = await repo.loadBucket(RecommendationBucket.ultimosDias);
      // Fixture spec: ~4 items in last 7d. Page size 6 → fits in one page.
      expect(p1.items, hasLength(4));
      expect(p1.hasMore, isFalse);
    });

    test('novedades bucket returns ~7 entries within last 30 days', () async {
      final repo = RecommendationsRepositoryMock();
      // "Novedades" is the ≤30d window in the mock — that includes the
      // 4 últimos-días + 3 mid-range entries = 7 total.
      final p1 = await repo.loadBucket(RecommendationBucket.novedades);
      expect(p1.items, hasLength(6));
      expect(p1.hasMore, isTrue);
      final p2 = await repo.loadBucket(
        RecommendationBucket.novedades,
        cursor: p1.nextCursor,
      );
      expect(p2.items, hasLength(1));
      expect(p2.hasMore, isFalse);
    });

    test('tramitacionInmediata bucket returns the immediate-processing entries', () async {
      final repo = RecommendationsRepositoryMock();
      final p1 = await repo.loadBucket(
        RecommendationBucket.tramitacionInmediata,
      );
      // Fixture spec (TASK-58 §D4): ~5 immediate entries — actual mock
      // ships 6, all flagged as immediate.
      expect(p1.items, hasLength(6));
      expect(p1.hasMore, isFalse);
      expect(
        p1.items.every((final r) => r.isImmediateProcessing),
        isTrue,
      );
    });

    test('respects a custom page size', () async {
      final repo = RecommendationsRepositoryMock(pageSize: 3);
      final p1 = await repo.loadAll();
      expect(p1.items, hasLength(3));
      expect(p1.hasMore, isTrue);
      expect(p1.nextCursor, '3');
    });
  });
}
