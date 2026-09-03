import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';

void main() {
  group('ResolveAuthorizationFailureUsecase', () {
    test('la cláusula obligatoria sin aceptar es revocación', () async {
      final repository = _FakeConsentRepository(
        clauses: _clauses({requiredConsentClauseId: false, jccmDataConsentClauseId: true}),
      );

      final result = await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
      );

      expect(result, isA<ConsentRevoked>());
    });

    test('con la obligatoria aceptada, señala la cláusula concreta que falta', () async {
      final repository = _FakeConsentRepository(
        clauses: _clauses({requiredConsentClauseId: true, jccmDataConsentClauseId: false}),
      );

      final result = await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
      );

      expect(result, isA<ClauseMissing>());
      expect((result as ClauseMissing).clauseId, jccmDataConsentClauseId);
    });

    test('si el servicio de cláusulas no responde, NUNCA es revocación', () async {
      final repository = _FakeConsentRepository(
        error: const ConsentStatusUnknownException(message: 'Clausulas endpoint unavailable', statusCode: 500),
      );

      final result = await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {requiredConsentClauseId},
      );

      // El gateway falla cerrado y emite el mismo sobre cuando no puede leer
      // preferencias: dar eso por revocación expulsaría usuarios en cada bache.
      expect(result, isA<AuthorizationUnknown>());
    });

    test('con todas las cláusulas exigidas aceptadas, el rechazo no era de consentimiento', () async {
      final repository = _FakeConsentRepository(
        clauses: _clauses({requiredConsentClauseId: true, ageDataConsentClauseId: true}),
      );

      final result = await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {requiredConsentClauseId, ageDataConsentClauseId},
      );

      expect(result, isA<AuthorizationUnknown>());
    });

    test('una cláusula ausente del listado cuenta como no aceptada', () async {
      final repository = _FakeConsentRepository(
        clauses: _clauses({requiredConsentClauseId: true}),
      );

      final result = await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {requiredConsentClauseId, ageDataConsentClauseId},
      );

      expect((result as ClauseMissing).clauseId, ageDataConsentClauseId);
    });

    test('con varias cláusulas pendientes devuelve la menor, de forma estable', () async {
      final repository = _FakeConsentRepository(
        clauses: _clauses({
          requiredConsentClauseId: true,
          jccmDataConsentClauseId: false,
          ageDataConsentClauseId: false,
        }),
      );

      final result = await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {ageDataConsentClauseId, jccmDataConsentClauseId, requiredConsentClauseId},
      );

      expect((result as ClauseMissing).clauseId, jccmDataConsentClauseId);
    });

    test('relee siempre saltándose la caché', () async {
      final repository = _FakeConsentRepository(
        clauses: _clauses({requiredConsentClauseId: true, jccmDataConsentClauseId: false}),
      );

      await ResolveAuthorizationFailureUsecase(repository).execute(
        idAgente: 'PER9998003',
        requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
      );

      expect(repository.refreshCalls, ['PER9998003']);
      expect(repository.fetchCalls, isEmpty);
    });
  });
}

List<Clause> _clauses(final Map<int, bool> selection) {
  return [
    for (final entry in selection.entries) Clause(id: entry.key, label: 'Cláusula ${entry.key}', isSelected: entry.value),
  ];
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({this.clauses = const [], this.error});

  final List<Clause> clauses;
  final Exception? error;
  final List<String> refreshCalls = [];
  final List<String?> fetchCalls = [];

  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) async {
    refreshCalls.add(idAgente);
    final pending = error;
    if (pending != null) {
      throw pending;
    }
    return clauses;
  }

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) async {
    fetchCalls.add(idAgente);
    return clauses;
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) => throw UnimplementedError();
}
