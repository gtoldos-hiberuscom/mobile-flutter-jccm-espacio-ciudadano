import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

void main() {
  group('citizenEndpointIdsProvider', () {
    test('uses the identifier each fachada route declares', () {
      final ids = _ids(strategy: 'numDocumento');

      // La fachada declara {numDocumento} en CIP y primaria, y {idAgente} en
      // hospitalaria, cláusulas, hechos y preferencias.
      expect(ids.numDocumento, '12345678Z');
      expect(ids.idAgente, 'PER9998003');
    });

    test('collapses both identifiers to sub_alt when pointing at the gateway', () {
      // Único cambio necesario para cortar al gateway, junto con BASE_URL: el
      // gateway acepta sub_alt en todas las rutas y lo traduce él.
      final ids = _ids(strategy: 'subAlt');

      expect(ids.numDocumento, 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6');
      expect(ids.idAgente, 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6');
    });

    test('normalizes the eIDAS prefixed PersonIdentifier', () {
      final ids = _ids(strategy: 'numDocumento', personIdentifier: 'ES/ES/12345678Z');

      expect(ids.numDocumento, '12345678Z');
    });

    test('reports missing identifiers instead of sending an empty path segment', () {
      final ids = _ids(strategy: 'numDocumento', personIdentifier: '', idAgente: '');

      expect(ids.numDocumento, isNull);
      expect(ids.idAgente, isNull);
      expect(ids.requireNumDocumento, throwsStateError);
      expect(ids.requireIdAgente, throwsStateError);
    });

    test('yields no identifiers without an authenticated session', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(_config('numDocumento')),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(citizenEndpointIdsProvider), (numDocumento: null, idAgente: null));
    });
  });
}

CitizenEndpointIds _ids({
  required final String strategy,
  final String personIdentifier = '12345678Z',
  final String idAgente = 'PER9998003',
  final String subAlt = 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
}) {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(_config(strategy)),
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

AppConfig _config(final String strategy) => AppConfig.fromMap({
  'APP_FLAVOR': 'development',
  'CIUDADANOS_ID_STRATEGY': strategy,
});

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}
