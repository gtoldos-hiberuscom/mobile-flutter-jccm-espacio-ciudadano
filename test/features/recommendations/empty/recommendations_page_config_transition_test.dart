import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_source.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_config_source_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';

class _MutableSource implements RecommendationsConfigSource {
  _MutableSource(this._state);
  RecommendationsConfigState _state;

  // ignore: use_setters_to_change_properties
  void set(final RecommendationsConfigState next) => _state = next;

  @override
  Future<RecommendationsConfigState> loadState() async => _state;

  @override
  Future<void> markPreferencesAcknowledged() async {
    _state = RecommendationsConfigState.configured;
  }
}

class _StaticRepo implements RecommendationsRepository {
  _StaticRepo(this.items);
  final List<Recommendation> items;

  @override
  Future<RecommendationsConfigState> loadConfigState() async => RecommendationsConfigState.configured;

  @override
  Future<RecommendationsPageResult> loadAll({final String? cursor}) async => RecommendationsPageResult(items: items, hasMore: false);

  @override
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  }) async => RecommendationsPageResult(items: items, hasMore: false);
}

GoRouter _routerFor(final Widget child) => GoRouter(
  initialLocation: '/host',
  routes: [
    GoRoute(path: '/host', builder: (final c, final s) => child),
    GoRoute(
      path: Routes.preferencesConsent,
      builder: (final c, final s) => const Scaffold(body: Text('PREFERENCES_CONSENT_PAGE')),
    ),
  ],
);

void main() {
  testWidgets(
    'page rebuilds and lists items after the mock config flips from unconfigured to configured',
    (final tester) async {
      final source = _MutableSource(RecommendationsConfigState.unconfigured);
      final repo = _StaticRepo([
        const Recommendation(
          id: 'r-1',
          title: 'After-config card',
          isImmediateProcessing: false,
        ),
      ]);

      final container = ProviderContainer(
        overrides: [
          recommendationsConfigSourceProvider.overrideWithValue(source),
          recommendationsRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: _routerFor(const RecommendationsPage()),
            localizationsDelegates: AppLocalization.delegates,
            supportedLocales: AppLocalization.supportedLocales,
            locale: const Locale('es'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // First render — onboarding empty view.
      expect(
        find.text('Aún no tienes recomendaciones personalizadas'),
        findsOneWidget,
      );
      expect(find.text('After-config card'), findsNothing);

      // Citizen completes the consent flow → flip + invalidate.
      source.set(RecommendationsConfigState.configured);
      container.invalidate(recommendationsConfigProvider);
      await tester.pumpAndSettle();

      expect(
        find.text('Aún no tienes recomendaciones personalizadas'),
        findsNothing,
      );
      expect(find.text('After-config card'), findsOneWidget);
    },
  );
}
