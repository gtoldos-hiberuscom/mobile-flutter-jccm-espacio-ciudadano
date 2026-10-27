import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_personalization_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_consent_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_personalization_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_recommendations_routes.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/repositories/consent_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_impl.dart';

void main() {
  final fixedNow = DateTime(2026, 10, 16, 10, 30);
  const idAgente = DemoSession.idAgente;

  late DemoPersonalizationState personalization;
  late DemoConsentState consent;
  late Dio dio;
  late LifeEventsRepositoryImpl repository;

  setUp(() {
    personalization = DemoPersonalizationState(now: () => fixedNow);
    consent = DemoConsentState(now: () => fixedNow);
    dio = _demoDio(<DemoRoute>[
      ...demoPersonalizationRoutes(personalization, consent: consent),
      ...demoConsentRoutes(consent),
      ...demoRecommendationsRoutes(personalization: personalization, now: () => fixedNow),
    ], fixedNow);
    // Como `lifeEventsRepositoryProvider`: `sub_alt` en la ruta y el agente
    // efectivo en el cuerpo, que en demo son el mismo valor.
    repository = LifeEventsRepositoryImpl(dio: dio, agentId: idAgente);
  });

  group('demoPersonalizationRoutes', () {
    test('loadLifeEvents devuelve el catálogo entero con la selección inicial marcada', () async {
      final events = await repository.loadLifeEvents(idAgente: idAgente);

      expect(events, hasLength(demoLifeEventsCatalogue.length));
      expect(events.map((final event) => event.id), demoLifeEventsCatalogue.map((final fixture) => fixture.id));
      expect(events.every((final event) => event.label.isNotEmpty), isTrue);
      expect(events.where((final event) => event.selected).map((final event) => event.id).toSet(), demoInitiallySelectedLifeEventIds);
    });

    test('saveLifeEvents cambia la selección y la lectura siguiente la refleja', () async {
      final events = await repository.loadLifeEvents(idAgente: idAgente);
      final updated = events.map((final event) => event.copyWith(selected: event.id == 3 || event.id == 7)).toList(growable: false);

      await repository.saveLifeEvents(idAgente: idAgente, events: updated);

      final reloaded = await repository.loadLifeEvents(idAgente: idAgente);
      expect(reloaded.where((final event) => event.selected).map((final event) => event.id).toSet(), <int>{3, 7});
      expect(personalization.selectedIds, <int>{3, 7});
    });

    test('las recomendaciones siguen a la selección de hechos', () async {
      final recommendations = RecommendationsRepositoryImpl(dio: dio, sedeBaseUrl: Uri.parse('https://sede.demo.invalid/'));
      Future<Set<int>> recommendedLifeEvents() async {
        final events = await repository.loadLifeEvents(idAgente: idAgente);
        final selectedIds = events.where((final event) => event.selected).map((final event) => event.id).toList(growable: false);
        final list = await recommendations.loadRecommendations(idAgente: idAgente, lifeEventIds: selectedIds, segment: RecommendationsSegment.all);
        return list.map((final recommendation) => recommendation.lifeEventId).toSet();
      }

      expect(await recommendedLifeEvents(), demoInitiallySelectedLifeEventIds);

      final events = await repository.loadLifeEvents(idAgente: idAgente);
      await repository.saveLifeEvents(
        idAgente: idAgente,
        events: events.map((final event) => event.copyWith(selected: event.id == 6)).toList(growable: false),
      );

      expect(await recommendedLifeEvents(), <int>{6});
    });

    test('resetPreferences desmarca todos los hechos y devuelve el consentimiento a pendiente', () async {
      final consentRepository = ConsentRepositoryImpl(storage: _MemoryAppStorage(), dio: dio, agentId: idAgente);
      await consentRepository.markConsentAccepted(
        idAgente: idAgente,
        clauses: const <Clause>[
          Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: true, version: '1'),
          Clause(id: recommendationsConsentClauseId, label: 'Recomendaciones', isSelected: true, version: '1'),
        ],
      );
      expect(await consentRepository.hasAcceptedConsent(idAgente: idAgente), isTrue);

      await repository.resetPreferences(idAgente: idAgente);

      final events = await repository.loadLifeEvents(idAgente: idAgente);
      expect(events, hasLength(demoLifeEventsCatalogue.length));
      expect(events.any((final event) => event.selected), isFalse);
      // La copia en memoria del repositorio no sabe del borrado: se relee, que
      // es lo que hace la app al decidir un cierre de sesión.
      final reloaded = await consentRepository.refreshClauses(idAgente: idAgente);
      expect(reloaded.every((final clause) => clause.isPending && !clause.isSelected), isTrue);
      expect(await consentRepository.hasAcceptedConsent(idAgente: idAgente), isFalse);
    });
  });
}

Dio _demoDio(final List<DemoRoute> routes, final DateTime now) => Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
  ..httpClientAdapter = DemoHttpClientAdapter(
    DemoBackend(routes: routes, now: () => now),
    latency: Duration.zero,
  );

final class _MemoryAppStorage implements AppStorage {
  final Map<String, Object> _values = <String, Object>{};

  @override
  T? read<T>(final String key) => _values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    _values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _values.clear();
    return true;
  }
}
