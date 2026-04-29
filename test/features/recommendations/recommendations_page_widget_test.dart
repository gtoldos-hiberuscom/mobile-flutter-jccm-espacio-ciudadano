import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/app/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';

class _FakeRepo implements RecommendationsRepository {
  _FakeRepo({
    required this.byBucket,
    this.configState = RecommendationsConfigState.configured,
  });

  final Map<RecommendationBucket, List<RecommendationsPageResult>> byBucket;
  final RecommendationsConfigState configState;

  final Map<RecommendationBucket, int> _calls = {};

  @override
  Future<RecommendationsConfigState> loadConfigState() async => configState;

  @override
  Future<RecommendationsPageResult> loadAll({final String? cursor}) =>
      _serve(RecommendationBucket.todos);

  @override
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  }) => _serve(bucket);

  Future<RecommendationsPageResult> _serve(final RecommendationBucket bucket) async {
    final pages = byBucket[bucket] ?? const <RecommendationsPageResult>[];
    if (pages.isEmpty) {
      return RecommendationsPageResult.empty;
    }
    final idx = (_calls[bucket] ?? 0).clamp(0, pages.length - 1);
    _calls[bucket] = (_calls[bucket] ?? 0) + 1;
    return pages[idx];
  }
}

Recommendation _rec(final String id, {final String? title}) => Recommendation(
  id: id,
  title: title ?? 'Title $id',
  isImmediateProcessing: false,
);

Widget _wrap(final Widget child, final RecommendationsRepository repo) {
  return ProviderScope(
    overrides: [recommendationsRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      localizationsDelegates: AppLocalization.delegates,
      supportedLocales: AppLocalization.supportedLocales,
      locale: const Locale('es'),
      home: child,
    ),
  );
}

void main() {
  testWidgets('renders cards for the first tab and shows the load-more button when hasMore', (
    final tester,
  ) async {
    final repo = _FakeRepo(
      byBucket: {
        RecommendationBucket.todos: [
          RecommendationsPageResult(
            items: [_rec('a', title: 'Card A'), _rec('b', title: 'Card B')],
            hasMore: true,
            nextCursor: '2',
          ),
          RecommendationsPageResult(
            items: [_rec('c', title: 'Card C')],
            hasMore: false,
          ),
        ],
        RecommendationBucket.ultimosDias: const [],
        RecommendationBucket.novedades: const [],
        RecommendationBucket.tramitacionInmediata: const [],
      },
    );

    await tester.pumpWidget(_wrap(const RecommendationsPage(), repo));
    await tester.pumpAndSettle();

    expect(find.text('Card A'), findsOneWidget);
    expect(find.text('Card B'), findsOneWidget);
    // Load-more button visible while hasMore is true.
    expect(find.text('Ver más'), findsOneWidget);

    // Tap load-more → appends third card and hides the button.
    await tester.tap(find.text('Ver más'));
    await tester.pumpAndSettle();
    expect(find.text('Card C'), findsOneWidget);
    expect(find.text('Ver más'), findsNothing);
  });

  testWidgets('switching tabs triggers a per-bucket fetch', (final tester) async {
    final repo = _FakeRepo(
      byBucket: {
        RecommendationBucket.todos: [
          RecommendationsPageResult(
            items: [_rec('all-1', title: 'All entry')],
            hasMore: false,
          ),
        ],
        RecommendationBucket.ultimosDias: [
          RecommendationsPageResult(
            items: [_rec('rec-1', title: 'Recent entry')],
            hasMore: false,
          ),
        ],
        RecommendationBucket.novedades: const [],
        RecommendationBucket.tramitacionInmediata: const [],
      },
    );

    await tester.pumpWidget(_wrap(const RecommendationsPage(), repo));
    await tester.pumpAndSettle();
    expect(find.text('All entry'), findsOneWidget);

    // Switch to "Últimos días".
    await tester.tap(find.text('Últimos días'));
    await tester.pumpAndSettle();
    expect(find.text('Recent entry'), findsOneWidget);
  });

  testWidgets('renders the configured-but-empty variant when a bucket has no items', (
    final tester,
  ) async {
    final repo = _FakeRepo(
      byBucket: {
        RecommendationBucket.todos: const [
          RecommendationsPageResult(items: <Recommendation>[], hasMore: false),
        ],
        RecommendationBucket.ultimosDias: const [],
        RecommendationBucket.novedades: const [],
        RecommendationBucket.tramitacionInmediata: const [],
      },
    );

    await tester.pumpWidget(_wrap(const RecommendationsPage(), repo));
    await tester.pumpAndSettle();
    expect(find.text('Todo listo, sin novedades por ahora'), findsOneWidget);
  });
}
