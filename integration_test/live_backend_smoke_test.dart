import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/auth.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/jwt_claims_notifier.dart';

const _loginHint = String.fromEnvironment('LIVE_BACKEND_LOGIN_HINT');
const _numDocumentoOverride = String.fromEnvironment('LIVE_BACKEND_NUM_DOCUMENTO');
const _smokePathTemplate = String.fromEnvironment(
  'LIVE_BACKEND_SMOKE_PATH',
  defaultValue: '/api/v1/sescam/citas/{numDocumento}',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'login real y llamada autenticada a backend',
    (final tester) async {
      const config = AppConfig.fromEnvironment();
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(config),
        ],
      );
      addTearDown(container.dispose);

      await container.read(loginUseCaseProvider).call(loginHint: _blankToNull(_loginHint)).timeout(const Duration(minutes: 5));

      final session = container.read(tokenResponseProvider);
      final claims = container.read(jwtClaimsProvider);

      expect(session, isNotNull, reason: 'El login real no ha dejado sesion en tokenResponseProvider.');
      expect(session!.accessToken, isNotNull, reason: 'El login real no ha devuelto access_token.');
      expect(session.accessToken, isNotEmpty, reason: 'El access_token devuelto esta vacio.');

      expect(claims, isNotNull, reason: 'El login real no ha dejado userinfo en jwtClaimsProvider.');
      expect(claims!.isExpired, isFalse, reason: 'El token de Cl@ve ya esta caducado.');
      expect(claims.idAgente.trim(), isNotEmpty, reason: 'No hay NIF/idAgente usable en userinfo.');

      final numDocumento = _resolveNumDocumento(claims);
      final path = _resolveSmokePath(numDocumento);
      final dio = container.read(dioProvider);

      final response = await dio
          .get<Object>(
            path,
            options: Options(
              validateStatus: (final status) => status != null && status < 500,
            ),
          )
          .timeout(const Duration(seconds: 30));

      final authorizationHeader = _authorizationHeader(response.requestOptions.headers);

      expect(
        authorizationHeader,
        isA<String>().having((final value) => value, 'scheme', startsWith('Bearer ')),
        reason: 'El Dio de la app no ha inyectado Authorization: Bearer.',
      );
      expect(response.statusCode, isNot(401), reason: 'Backend ha rechazado el token real como no autenticado.');
      expect(response.statusCode, isNot(403), reason: 'Backend ha rechazado el token real como no autorizado.');
      expect(response.statusCode, lessThan(500), reason: 'Backend ha devuelto un error servidor en $path.');
    },
    tags: const ['backend'],
    timeout: const Timeout(Duration(minutes: 6)),
  );
}

String? _blankToNull(final String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String _resolveNumDocumento(final JwtClaims claims) {
  final override = _blankToNull(_numDocumentoOverride);
  if (override != null) {
    return override;
  }

  final candidates = [
    claims.nif,
    claims.personIdentifier,
    claims.preferredUsername,
    claims.idAgente,
  ];

  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }

  fail(
    'No se ha podido derivar numDocumento. Ejecuta el test con '
    '--dart-define=LIVE_BACKEND_NUM_DOCUMENTO=<NIF_NIE>',
  );
}

String _resolveSmokePath(final String numDocumento) {
  final path = _smokePathTemplate.trim();
  if (path.isEmpty) {
    fail('LIVE_BACKEND_SMOKE_PATH no puede estar vacio.');
  }
  if (path.contains('{numDocumento}')) {
    return path.replaceAll('{numDocumento}', Uri.encodeComponent(numDocumento));
  }
  return path;
}

Object? _authorizationHeader(final Map<String, dynamic> headers) {
  for (final entry in headers.entries) {
    if (entry.key.toLowerCase() == 'authorization') {
      return entry.value;
    }
  }
  return null;
}
