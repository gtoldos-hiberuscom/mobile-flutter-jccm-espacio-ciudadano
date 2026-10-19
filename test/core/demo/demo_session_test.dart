import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';

void main() {
  final now = DateTime(2026, 10, 16, 12);

  group('DemoSession.buildAccessToken', () {
    test('decodifica a los claims que leen los consumidores reales de la sesión', () {
      // Lo que importa no es el token, sino lo que cada consumidor saca de
      // él: `sub_alt` para las URLs, el documento para los cuerpos, el nivel
      // para el control de citas hospitalarias y el nombre para la cabecera.
      final claims = JwtDecoder.decode(DemoSession.buildAccessToken(now: now));

      expect(claims.iss, DemoSession.issuer);
      expect(claims.sub, isNotEmpty, reason: 'con `sub` vacío AuthSessionController descarta los claims');
      expect(claims.subAlt, DemoSession.idAgente);
      expect(claims.idAgente, DemoSession.idAgente);
      expect(claims.effectiveAgentId, DemoSession.idAgente);
      expect(claims.normalizedPersonIdentifier, DemoSession.personIdentifier);
      expect(claims.effectivePersonIdentifier, DemoSession.personIdentifier);
      expect(claims.identificationDocumentType, IdentificationDocumentType.dni);
      expect(claims.fullName, 'Lucía Ejemplo Demo');
      expect(claims.isRepresentative, isFalse);
    });

    test('declara nivel alto para que las citas hospitalarias no exijan elevación', () {
      final claims = JwtDecoder.decode(DemoSession.buildAccessToken(now: now));

      final reading = AuthenticationLevelReading.parse(claims.authNLevelRaw);
      expect(reading, isA<KnownAuthenticationLevel>());
      expect((reading as KnownAuthenticationLevel).level, AuthenticationLevel.high);
    });

    test('caduca muy lejos: la sesión demo no debe renovarse nunca', () {
      final claims = JwtDecoder.decode(DemoSession.buildAccessToken(now: now));

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(claims.exp * 1000);
      expect(expiresAt.isAfter(now.add(const Duration(days: 365))), isTrue);
    });
  });

  group('DemoSession.tokenResponse', () {
    test('sin idToken, con refresh token y caducidad lejana', () {
      final session = DemoSession.tokenResponse(now: now);

      expect(session.accessToken, DemoSession.buildAccessToken(now: now));
      expect(session.idToken, isNull, reason: 'sin id_token nada se guarda para end_session ni se abre navegador al salir');
      expect(session.refreshToken, DemoSession.refreshToken);
      expect(session.accessTokenExpirationDateTime, now.add(DemoSession.lifetime));
    });
  });

  group('DemoSession.isDemo', () {
    test('reconoce los claims demo y sólo ésos', () {
      expect(DemoSession.isDemo(DemoSession.claims(now: now)), isTrue);
      expect(DemoSession.isDemo(null), isFalse);
      expect(
        DemoSession.isDemo(
          const JwtClaims(exp: 9999999999, iat: 0, iss: 'https://cerbero.example/realms/x', aud: ['app'], sub: 'sub-1', subAlt: 'PER1'),
        ),
        isFalse,
      );
    });
  });

  group('DemoSession.forgetLocalTraces', () {
    test('borra las claves por ciudadano de la identidad demo y respeta las demás', () async {
      final storage = _FakeAppStorage()
        ..values['${StorageKeys.consentAcceptedPrefix}${DemoSession.idAgente}'] = true
        ..values['${StorageKeys.lifeEventsOnboardingSeenPrefix}${DemoSession.idAgente}'] = true
        ..values['${StorageKeys.biometricQuickAccessEnabledPrefix}${DemoSession.idAgente}'] = true
        ..values['${StorageKeys.consentAcceptedPrefix}PER1'] = true
        ..values[StorageKeys.selectedLocale] = 'es';

      await DemoSession.forgetLocalTraces(storage);

      expect(storage.values.keys.where((final key) => key.endsWith(DemoSession.idAgente)), isEmpty);
      expect(storage.values['${StorageKeys.consentAcceptedPrefix}PER1'], isTrue);
      expect(storage.values[StorageKeys.selectedLocale], 'es');
    });
  });
}

final class _FakeAppStorage implements AppStorage {
  final values = <String, Object>{};

  @override
  T? read<T>(final String key) => values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async => values.remove(key) != null;

  @override
  Future<bool> clear() async {
    values.clear();
    return true;
  }
}
