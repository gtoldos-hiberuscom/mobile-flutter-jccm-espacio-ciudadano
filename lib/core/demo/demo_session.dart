import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';

/// Identidad ficticia del **modo demostración** para los revisores de las
/// tiendas (App Store / Google Play), que no pueden identificarse con Cl@ve.
///
/// La sesión demo es una sesión normal de la app con un access token que la
/// propia app se fabrica: un JWT sin firma (`JwtDecoder` no la comprueba) con
/// los claims que leen los consumidores reales —`sub_alt` para las URLs,
/// `PersonIdentifier` para los cuerpos, `authNLevel` para el control de nivel—
/// y una caducidad lejana para que `AuthSessionController.refreshIfNeeded` lo
/// dé por válido y no intente renovar nunca.
///
/// El modo demo **se deriva del token** ([isDemo] mira el `iss`), no de un flag
/// aparte: así entrar, cerrar sesión y reanudar tras un reinicio con acceso
/// rápido quedan coherentes solos, y no puede quedar un flag huérfano que
/// mandase un login real de Cl@ve al repositorio ficticio.
abstract final class DemoSession {
  const DemoSession._();

  /// Emisor que marca un token como demo. Ningún token de Cerbero lo lleva.
  static const String issuer = 'espacio-ciudadano-demo';

  /// `sub_alt`/`idAgente`: segmento `{id}` de `/api/v1/ciudadanos/{id}/…`.
  static const String idAgente = 'PERDEMO001';

  /// NIF de pruebas con letra válida (`00000000` mod 23 → `T`): pasa como DNI
  /// por `JwtClaims.identificationDocumentType` y es inconfundible.
  static const String personIdentifier = '00000000T';

  static const String givenName = 'Lucía';
  static const String firstSurname = 'Ejemplo';
  static const String secondSurname = 'Demo';

  /// Token de larga vida ficticio. No nulo a propósito: con acceso rápido
  /// activado, `unlockPersistedSession` necesita *algo* que cargar.
  static const String refreshToken = 'demo-refresh';

  /// Vida del access token demo. Muy por encima de cualquier umbral de
  /// renovación: la sesión demo no se refresca jamás.
  static const Duration lifetime = Duration(days: 3650);

  /// Código que pide la hoja de confirmación antes de entrar. Va en las notas
  /// de revisión de las tiendas. **No es un secreto** (viaja en el binario y
  /// sólo abre datos ficticios): evita que un ciudadano entre por error.
  static const String accessCode = '1234';

  /// `true` si [claims] pertenecen a una sesión demo.
  static bool isDemo(final JwtClaims? claims) => claims?.iss == issuer;

  /// Payload del access token demo, con la forma que escribe Cerbero.
  static Map<String, Object?> payload({final DateTime? now}) {
    final issuedAt = now ?? DateTime.now();
    final expiresAt = issuedAt.add(lifetime);
    return <String, Object?>{
      'iss': issuer,
      'sub': 'demo-sub',
      'sub_alt': idAgente,
      'idAgente': idAgente,
      'PersonIdentifier': personIdentifier,
      'given_name': givenName,
      'first_surname': firstSurname,
      'second_surname': secondSurname,
      'name': '$givenName $firstSurname $secondSurname',
      // Nivel alto: las consultas que exigen elevación (citas hospitalarias)
      // se ven sin pasar por Cl@ve, que en demo no existe.
      'authNLevel': 'http://eidas.europa.eu/loa/high',
      'idpSelected': 'DEMO',
      'typ': 'Bearer',
      'aud': <String>['espacio-ciudadano'],
      'scope': 'openid',
      'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// Access token demo: JWT `alg: none` con [payload] y una firma de relleno.
  static String buildAccessToken({final DateTime? now}) {
    String segment(final Map<String, Object?> value) => base64Url.encode(utf8.encode(json.encode(value))).replaceAll('=', '');
    return '${segment(const <String, Object?>{'alg': 'none', 'typ': 'JWT'})}.${segment(payload(now: now))}.demo';
  }

  static JwtClaims claims({final DateTime? now}) => JwtClaims.fromMap(payload(now: now));

  /// Sesión completa tal y como la entregaría `AuthRepository.login`.
  ///
  /// Sin `idToken` a propósito: así `rememberBrowserSession` no guarda nada,
  /// los cierres de sesión no llaman a `end_session` y `endStaleBrowserSession`
  /// nunca tiene un id_token ficticio que mandar a Cerbero.
  static TokenResponse tokenResponse({final DateTime? now}) {
    final issuedAt = now ?? DateTime.now();
    return TokenResponse(
      buildAccessToken(now: issuedAt),
      refreshToken,
      issuedAt.add(lifetime),
      null,
      'Bearer',
      const <String>['openid'],
      null,
    );
  }

  /// Claves de `AppStorage` que la app guarda **por ciudadano** y que, de
  /// quedar de una demo anterior, cambiarían lo que ve el revisor (gate legal,
  /// onboarding de hechos vitales, oferta de acceso rápido…). Se borran al
  /// entrar para que cada demostración empiece como un ciudadano nuevo.
  static List<String> get localTraceKeys => <String>[
    '${StorageKeys.consentAcceptedPrefix}$idAgente',
    '${StorageKeys.consentAcceptedClausesPrefix}$idAgente',
    '${StorageKeys.lifeEventsOnboardingSeenPrefix}$idAgente',
    '${StorageKeys.lifeEventsLastUpdatedAtPrefix}$idAgente',
    '${StorageKeys.biometricQuickAccessEnabledPrefix}$idAgente',
    '${StorageKeys.biometricQuickAccessDeclinedPrefix}$idAgente',
    '${StorageKeys.identityVerificationNoticeSuppressedPrefix}$idAgente',
  ];

  static Future<void> forgetLocalTraces(final AppStorage storage) async {
    for (final key in localTraceKeys) {
      await storage.remove(key);
    }
  }
}
