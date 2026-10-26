import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_personalization_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_recommendations_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_personalization_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_recommendations_routes.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_impl.dart';

void main() {
  final fixedNow = DateTime(2026, 10, 16, 10, 30);
  const idAgente = DemoSession.idAgente;
  final sedeBaseUrl = Uri.parse('https://sede.demo.invalid/');

  late DemoPersonalizationState personalization;
  late RecommendationsRepositoryImpl repository;

  setUp(() {
    personalization = DemoPersonalizationState(now: () => fixedNow);
    final dio = _demoDio(demoRecommendationsRoutes(personalization: personalization, now: () => fixedNow), fixedNow);
    // Como `recommendationsRepositoryProvider`.
    repository = RecommendationsRepositoryImpl(dio: dio, sedeBaseUrl: sedeBaseUrl);
  });

  Future<List<Recommendation>> load(final RecommendationsSegment segment) => repository.loadRecommendations(idAgente: idAgente, lifeEventIds: personalization.selectedIds.toList(growable: false), segment: segment);

  group('demoRecommendationsRoutes', () {
    test('"Todos" devuelve los trámites de los hechos marcados, agrupados por hecho y con sus datos', () async {
      final all = await load(RecommendationsSegment.all);

      expect(all, isNotEmpty);
      expect(all, hasLength(demoProceduresCatalogue.where((final procedure) => demoInitiallySelectedLifeEventIds.contains(procedure.lifeEventId)).length));
      expect(all.map((final recommendation) => recommendation.lifeEventId).toSet(), demoInitiallySelectedLifeEventIds);
      for (final recommendation in all) {
        expect(recommendation.title, isNotEmpty);
        expect(recommendation.lifeEventName, demoLifeEventName(recommendation.lifeEventId));
        expect(recommendation.responsibleUnit, isNotNull);
        expect(recommendation.submissionStartDate, isNotNull);
        expect(recommendation.badges, isEmpty);
        expect(recommendation.detailUrl.toString(), startsWith('https://sede.demo.invalid/tramites/'));
      }
    });

    test('cambiar la selección de hechos cambia la lista', () async {
      personalization.apply(<int, bool>{1: false, 4: false, 6: true});

      final list = await load(RecommendationsSegment.all);

      expect(list, isNotEmpty);
      expect(list.map((final recommendation) => recommendation.lifeEventId).toSet(), <int>{6});
    });

    test('sin trámites para los hechos marcados responde 404.01 y el repositorio lo traduce a vacío', () async {
      personalization.reset();

      // El repositorio corta antes de llamar si la lista de hechos va vacía;
      // se le pasa un id fuera del catálogo para que la ruta llegue a contestar.
      final list = await repository.loadRecommendations(idAgente: idAgente, lifeEventIds: const <int>[999], segment: RecommendationsSegment.all);

      expect(list, isEmpty);
    });

    test('últimos, novedades y plazo inmediato son subconjuntos etiquetados y distintos de "Todos"', () async {
      final allIds = (await load(RecommendationsSegment.all)).map((final recommendation) => recommendation.id).toSet();
      final recent = await load(RecommendationsSegment.recent);
      final news = await load(RecommendationsSegment.news);
      final immediate = await load(RecommendationsSegment.immediate);

      for (final (list, badge) in <(List<Recommendation>, RecommendationBadge)>[(recent, RecommendationBadge.recent), (news, RecommendationBadge.news), (immediate, RecommendationBadge.immediate)]) {
        expect(list, isNotEmpty);
        expect(list.every((final recommendation) => recommendation.badges.contains(badge)), isTrue);
        expect(allIds.containsAll(list.map((final recommendation) => recommendation.id)), isTrue);
        expect(list.length, lessThan(allIds.length));
      }
      final today = DateTime(fixedNow.year, fixedNow.month, fixedNow.day);
      expect(recent.every((final recommendation) => !recommendation.submissionStartDate!.isBefore(today.subtract(const Duration(days: 30)))), isTrue);
      expect(immediate.every((final recommendation) => !recommendation.submissionEndDate!.isAfter(today.add(const Duration(days: 15)))), isTrue);
      expect(recent.map((final recommendation) => recommendation.id).toSet(), isNot(news.map((final recommendation) => recommendation.id).toSet()));
    });
  });
}

Dio _demoDio(final List<DemoRoute> routes, final DateTime now) => Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
  ..httpClientAdapter = DemoHttpClientAdapter(
    DemoBackend(routes: routes, now: () => now),
    latency: Duration.zero,
  );
