import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';

/// Locks the digital_cards pattern on the my-data authorization providers: an
/// unanswerable clause check becomes [AsyncError], never a fabricated
/// "not authorized" that lies about granted RGPD consent.
void main() {
  ProviderContainer buildContainer(final ConsentRepository repository) {
    final container = ProviderContainer(
      overrides: [
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            const JwtClaims(
              exp: 0,
              iat: 0,
              iss: 'issuer',
              aud: [],
              sub: 'subject',
              subAlt: 'PER1',
            ),
          ),
        ),
        checkAcceptedConsentClauseUsecaseProvider.overrideWithValue(
          CheckAcceptedConsentClauseUsecase(repository),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('an accepted clause resolves to true', () async {
    final container = buildContainer(_FakeConsentRepository(accepted: true));

    expect(await container.read(jccmDataAuthorizationProvider.future), isTrue);
  });

  test('a genuinely unaccepted clause resolves to false', () async {
    final container = buildContainer(_FakeConsentRepository(accepted: false));

    expect(await container.read(jccmDataAuthorizationProvider.future), isFalse);
  });

  test('an unanswerable check surfaces as AsyncError, never as "not authorized"', () async {
    final container = buildContainer(
      _FakeConsentRepository(error: const ConsentStatusUnknownException(message: 'gateway down', statusCode: 503)),
    );

    await expectLater(
      container.read(ageDataAuthorizationProvider.future),
      throwsA(isA<StateError>()),
    );
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({this.accepted, this.error});

  final bool? accepted;
  final Exception? error;

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) async {
    final pendingError = error;
    if (pendingError != null) {
      throw pendingError;
    }
    return accepted!;
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();
  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) => throw UnimplementedError();
}
