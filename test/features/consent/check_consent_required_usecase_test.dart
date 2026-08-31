import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_consent_required_usecase.dart';

/// Locks the domain seam that keeps the session guard fail-open: an UNKNOWN
/// consent status must surface as [CheckConsentRequiredFailed], never as
/// [ConsentRequired].
void main() {
  group('CheckConsentRequiredUsecase', () {
    test('accepted consent maps to ConsentNotRequired', () async {
      final usecase = CheckConsentRequiredUsecase(_FakeConsentRepository(accepted: true));

      final result = await usecase.execute(idAgente: 'PER1');

      expect(result, isA<ConsentNotRequired>());
    });

    test('genuinely missing consent maps to ConsentRequired', () async {
      final usecase = CheckConsentRequiredUsecase(_FakeConsentRepository(accepted: false));

      final result = await usecase.execute(idAgente: 'PER1');

      expect(result, isA<ConsentRequired>());
    });

    test('unknown status (backend unavailable) maps to CheckConsentRequiredFailed', () async {
      final usecase = CheckConsentRequiredUsecase(
        _FakeConsentRepository(
          error: const ConsentStatusUnknownException(message: 'clausulas endpoint unavailable', statusCode: 503),
        ),
      );

      final result = await usecase.execute(idAgente: 'PER1');

      expect(result, isA<CheckConsentRequiredFailed>());
    });
  });
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({this.accepted, this.error});

  final bool? accepted;
  final Exception? error;

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) async {
    final pendingError = error;
    if (pendingError != null) {
      throw pendingError;
    }
    return accepted!;
  }

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) => throw UnimplementedError();

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();
}
