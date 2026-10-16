import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_consent_routes.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/repositories/consent_repository_impl.dart';

void main() {
  final fixedNow = DateTime(2026, 10, 16, 10, 30);
  const idAgente = DemoSession.idAgente;

  // Como `consentRepositoryProvider`. Cada instancia nace sin caché en
  // memoria: construir una nueva equivale a lo que ve la app tras reiniciar.
  ConsentRepositoryImpl repositoryFor(final Dio dio) => ConsentRepositoryImpl(storage: _MemoryAppStorage(), dio: dio, agentId: idAgente);

  group('demoConsentRoutes · ciudadano nuevo', () {
    late DemoConsentState state;
    late Dio dio;

    setUp(() {
      state = DemoConsentState(now: () => fixedNow);
      dio = _demoDio(demoConsentRoutes(state), fixedNow);
    });

    test('GET sirve el catálogo pendiente con 200, no un 404: el gate legal tiene que poder cargarlo', () {
      final backend = DemoBackend(routes: demoConsentRoutes(state), now: () => fixedNow);

      final response = backend.handle(DemoRequest(method: 'GET', uri: Uri.parse('https://demo.invalid/api/v1/ciudadanos/$idAgente/clausulas')));

      expect(response.statusCode, 200);
      final body = response.json?['body'];
      expect(body, isA<Map<String, Object?>>().having((final map) => map['clausulaPendiente'], 'clausulaPendiente', isTrue));
    });

    test('fetchClauses carga el catálogo completo, sin nada contestado', () async {
      final clauses = await repositoryFor(dio).fetchClauses(idAgente: idAgente);

      expect(clauses.map((final clause) => clause.id), <int>[requiredConsentClauseId, jccmDataConsentClauseId, ageDataConsentClauseId, recommendationsConsentClauseId, digitalCardsConsentClauseId]);
      expect(clauses.every((final clause) => clause.label.isNotEmpty && !clause.isSelected && clause.isPending), isTrue);
    });

    test('el consentimiento no está aceptado y las cláusulas opcionales tampoco', () async {
      final repository = repositoryFor(dio);

      expect(await repository.hasAcceptedConsent(idAgente: idAgente), isFalse);
      expect(await repository.hasAcceptedClause(idAgente: idAgente, clauseId: jccmDataConsentClauseId), isFalse);
      expect(await repository.hasAcceptedClause(idAgente: idAgente, clauseId: recommendationsConsentClauseId), isFalse);
    });

    test('aceptar registra las cláusulas y una sesión nueva las lee aceptadas', () async {
      final clauses = await repositoryFor(dio).fetchClauses(idAgente: idAgente);
      final answered = clauses.map((final clause) => clause.copyWith(isSelected: clause.id != ageDataConsentClauseId)).toList(growable: false);

      await repositoryFor(dio).markConsentAccepted(idAgente: idAgente, clauses: answered);

      expect(state.isRegistered, isTrue);
      expect(state.hasPending, isFalse);
      expect(state.acceptedClauseIds, <int>{requiredConsentClauseId, jccmDataConsentClauseId, recommendationsConsentClauseId, digitalCardsConsentClauseId});

      final fresh = repositoryFor(dio);
      expect(await fresh.hasAcceptedConsent(idAgente: idAgente), isTrue);
      expect(await fresh.hasAcceptedClause(idAgente: idAgente, clauseId: jccmDataConsentClauseId), isTrue);
      expect(await fresh.hasAcceptedClause(idAgente: idAgente, clauseId: recommendationsConsentClauseId), isTrue);
      expect(await fresh.hasAcceptedClause(idAgente: idAgente, clauseId: ageDataConsentClauseId), isFalse);
      final reloaded = await fresh.fetchClauses(idAgente: idAgente);
      expect(reloaded.every((final clause) => !clause.isPending), isTrue);
    });

    test('revocar desde Preferencias actualiza lo registrado y cierra el gate', () async {
      final clauses = await repositoryFor(dio).fetchClauses(idAgente: idAgente);
      await repositoryFor(dio).markConsentAccepted(idAgente: idAgente, clauses: clauses.map((final clause) => clause.copyWith(isSelected: true)).toList(growable: false));

      await repositoryFor(dio).resetConsentClauses(idAgente: idAgente);

      expect(state.acceptedClauseIds, isEmpty);
      expect(state.hasPending, isFalse, reason: 'una revocación es una respuesta en negativo, no una cláusula sin contestar');
      final fresh = repositoryFor(dio);
      expect(await fresh.hasAcceptedConsent(idAgente: idAgente), isFalse);
      expect(await fresh.hasAcceptedClause(idAgente: idAgente, clauseId: jccmDataConsentClauseId), isFalse);
    });

    test('reset vuelve al ciudadano nuevo: todo pendiente y sin registro', () async {
      final clauses = await repositoryFor(dio).fetchClauses(idAgente: idAgente);
      await repositoryFor(dio).markConsentAccepted(idAgente: idAgente, clauses: clauses.map((final clause) => clause.copyWith(isSelected: true)).toList(growable: false));

      state.reset();

      expect(state.isRegistered, isFalse);
      expect(state.hasPending, isTrue);
      expect(await repositoryFor(dio).hasAcceptedConsent(idAgente: idAgente), isFalse);
    });
  });

  group('demoConsentRoutes · sesión reanudada', () {
    test('seededAccepted arranca con la cláusula 0 y las opcionales indicadas aceptadas', () async {
      final state = DemoConsentState(now: () => fixedNow, seededAccepted: true, seededAcceptedClauseIds: const <int>{jccmDataConsentClauseId, recommendationsConsentClauseId});
      final repository = repositoryFor(_demoDio(demoConsentRoutes(state), fixedNow));

      expect(await repository.hasAcceptedConsent(idAgente: idAgente), isTrue);
      expect(await repository.hasAcceptedClause(idAgente: idAgente, clauseId: jccmDataConsentClauseId), isTrue);
      expect(await repository.hasAcceptedClause(idAgente: idAgente, clauseId: recommendationsConsentClauseId), isTrue);
      expect(await repository.hasAcceptedClause(idAgente: idAgente, clauseId: ageDataConsentClauseId), isFalse);
      expect(await repository.hasAcceptedClause(idAgente: idAgente, clauseId: digitalCardsConsentClauseId), isFalse);
      final clauses = await repository.fetchClauses(idAgente: idAgente);
      expect(clauses.every((final clause) => !clause.isPending), isTrue);
    });

    test('seededAccepted sin opcionales deja solo la obligatoria', () async {
      final state = DemoConsentState(now: () => fixedNow, seededAccepted: true);

      expect(state.isRegistered, isTrue);
      expect(state.acceptedClauseIds, <int>{requiredConsentClauseId});
      expect(await repositoryFor(_demoDio(demoConsentRoutes(state), fixedNow)).hasAcceptedConsent(idAgente: idAgente), isTrue);
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
