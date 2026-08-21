import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

void main() {
  group('citizenEndpointIdsProvider', () {
    test('uses sub_alt for every citizen resource route', () {
      final ids = _ids();

      expect(ids.numDocumento, 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6');
      expect(ids.idAgente, 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6');
    });

    test('reports missing identifiers instead of sending an empty path segment', () {
      final ids = _ids(subAlt: '');

      expect(ids.numDocumento, isNull);
      expect(ids.idAgente, isNull);
      expect(ids.requireNumDocumento, throwsStateError);
      expect(ids.requireIdAgente, throwsStateError);
    });

    test('yields no identifiers without an authenticated session', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(citizenEndpointIdsProvider), (numDocumento: null, idAgente: null));
    });
  });
}

CitizenEndpointIds _ids({
  final String personIdentifier = '12345678Z',
  final String idAgente = 'PER9998003',
  final String subAlt = 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
}) {
  final container = ProviderContainer(
    overrides: [
      jwtClaimsProvider.overrideWith(
        () => _StubJwtClaimsNotifier(
          JwtClaims(
            exp: 0,
            iat: 0,
            iss: 'https://sso-cerbero-uat.cm-pre.jccm.es/auth',
            aud: const [],
            sub: 'sub',
            personIdentifier: personIdentifier,
            idAgente: idAgente,
            subAlt: subAlt,
          ),
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(citizenEndpointIdsProvider);
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}
