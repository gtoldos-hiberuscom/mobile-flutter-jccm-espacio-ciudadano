/// Nivel de seguridad de la autenticación, en la escala de Cl@ve/eIDAS.
///
/// Pure Dart — no Flutter, Riverpod, Dio, ni infraestructura.
///
/// El requisito funcional de citas hospitalarias (JCCM, septiembre de 2026,
/// apartados 4 y 5) exige como mínimo **substantial** y obliga a validarlo
/// leyendo el claim `authNLevel` del token de Cerbero, no deduciéndolo del
/// método de identificación.
library;

import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
import 'package:meta/meta.dart';

/// Los tres niveles de la escala.
///
/// **`high` es una inferencia, no un contrato.** El documento del cliente solo
/// recoge los literales `low` y `substantial`, que son dos de los tres valores
/// del vocabulario eIDAS; el tercero se asume por coherencia con esa escala y
/// porque el propio documento dice que con certificado o DNI-e no debe pedirse
/// elevar. Queda pendiente de confirmar con una traza real (ver la tabla de
/// pruebas manuales del plan). Si Cerbero usara otro literal,
/// [AuthenticationLevelReading.parse] lo
/// devolvería como [UnknownAuthenticationLevel] y el acceso se denegaría
/// dejando el valor en la traza, en lugar de concederlo por descuido.
enum AuthenticationLevel {
  low,
  substantial,
  high;

  /// Orden de la escala. Explícito y no derivado de `index` a propósito:
  /// reordenar el enum no debe poder cambiar en silencio quién entra.
  int get rank => switch (this) {
    AuthenticationLevel.low => 1,
    AuthenticationLevel.substantial => 2,
    AuthenticationLevel.high => 3,
  };

  /// Scope con el que se pide este nivel a Cerbero en la petición de
  /// autorización.
  ///
  /// Cerbero lo traduce al `AuthnContextClassRef` de la petición SAML a Cl@ve,
  /// y Cl@ve solo ofrece los métodos que alcanzan el nivel: con Cl@ve
  /// Permanente, eso es lo que hace que pida el OTP. Confirmado por Cerbero el
  /// 22/10, y es lo que hace Espacio Ciudadano Web en UAT
  /// (`scope=openid substantial`). Explícito y no derivado de `name`, como
  /// [rank]: renombrar el enum no debe cambiar la petición.
  String get cerberoScope => switch (this) {
    AuthenticationLevel.low => 'low',
    AuthenticationLevel.substantial => 'substantial',
    AuthenticationLevel.high => 'high',
  };
}

/// Lo que se ha podido leer del claim `authNLevel`.
///
/// Son tres estados y no un `AuthenticationLevel?` porque «no vino el claim» y
/// «vino algo que no sé interpretar» piden mensajes distintos al ciudadano y
/// trazas distintas a operaciones, aunque las dos denieguen el acceso.
@immutable
sealed class AuthenticationLevelReading {
  const AuthenticationLevelReading();

  /// Si este nivel **alcanza** el mínimo exigido.
  ///
  /// Solo [KnownAuthenticationLevel] puede devolver `true`. Aquí vive, en un
  /// único sitio auditable, el «claim ausente o desconocido no concede acceso»
  /// del requisito.
  bool meets(final AuthenticationLevel minimum);

  /// Lee el claim. Nunca lanza.
  ///
  /// Acepta, además de los literales canónicos, las formas en que la misma
  /// escala aparece escrita en la documentación de Cl@ve: las URNs de eIDAS,
  /// los nombres en castellano y la numeración 2/3/4 de la tabla de niveles del
  /// documento del cliente. Cada alias está cubierto por un test.
  static AuthenticationLevelReading parse(final Object? raw) {
    if (raw is! String) {
      return const MissingAuthenticationLevel();
    }
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const MissingAuthenticationLevel();
    }

    final level = _byLiteral[trimmed.toLowerCase()];
    return level == null ? UnknownAuthenticationLevel(trimmed) : KnownAuthenticationLevel(level, trimmed);
  }

  /// Lee el nivel de una sesión: del **access token** ([accessTokenClaims]) y,
  /// si ahí no viene, del **id token**. Nunca lanza.
  ///
  /// Es la única regla de lectura: la usan el gate y la elevación. Con dos
  /// reglas, un `authNLevel` que viajara solo en el id token daba la elevación
  /// por insuficiente mientras el gate ya dejaba pasar (JCCMEC-278).
  static AuthenticationLevelReading fromSession({
    required final JwtClaims? accessTokenClaims,
    required final String? idToken,
  }) {
    if (accessTokenClaims != null) {
      final fromAccessToken = parse(accessTokenClaims.authNLevelRaw);
      if (fromAccessToken is! MissingAuthenticationLevel) {
        return fromAccessToken;
      }
    }
    if (idToken == null || idToken.isEmpty) {
      return const MissingAuthenticationLevel();
    }
    return parse(JwtDecoder.decodePayload(idToken)['authNLevel']);
  }

  static const Map<String, AuthenticationLevel> _byLiteral = {
    // Canónicos eIDAS, que son los que documenta el cliente.
    'low': AuthenticationLevel.low,
    'substantial': AuthenticationLevel.substantial,
    'high': AuthenticationLevel.high,
    // URNs de eIDAS.
    'http://eidas.europa.eu/loa/low': AuthenticationLevel.low,
    'http://eidas.europa.eu/loa/substantial': AuthenticationLevel.substantial,
    'http://eidas.europa.eu/loa/high': AuthenticationLevel.high,
    // Castellano, como aparece en la columna «Nivel ENS» de la tabla.
    'bajo': AuthenticationLevel.low,
    'medio': AuthenticationLevel.substantial,
    'alto': AuthenticationLevel.high,
    // Numeración de la columna «Nivel en Cl@ve» de esa misma tabla.
    '2': AuthenticationLevel.low,
    '3': AuthenticationLevel.substantial,
    '4': AuthenticationLevel.high,
  };
}

/// El claim vino y se sabe interpretar.
@immutable
final class KnownAuthenticationLevel extends AuthenticationLevelReading {
  const KnownAuthenticationLevel(this.level, this.raw);

  final AuthenticationLevel level;

  /// El literal exacto que mandó Cerbero, para trazas.
  final String raw;

  @override
  bool meets(final AuthenticationLevel minimum) => level.rank >= minimum.rank;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is KnownAuthenticationLevel && other.level == level && other.raw == raw;

  @override
  int get hashCode => Object.hash(level, raw);

  @override
  String toString() => 'KnownAuthenticationLevel($raw)';
}

/// El claim vino con un literal que la app no sabe interpretar.
///
/// Deniega el acceso, igual que [MissingAuthenticationLevel], pero se distingue
/// de él para poder avisar con otro texto y dejar [raw] en la traza: es la
/// diferencia entre «tu nivel es bajo» y «no hemos sabido leer tu nivel».
@immutable
final class UnknownAuthenticationLevel extends AuthenticationLevelReading {
  const UnknownAuthenticationLevel(this.raw);

  final String raw;

  @override
  bool meets(final AuthenticationLevel minimum) => false;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is UnknownAuthenticationLevel && other.raw == raw;

  @override
  int get hashCode => raw.hashCode;

  @override
  String toString() => 'UnknownAuthenticationLevel($raw)';
}

/// El token no trae el claim.
@immutable
final class MissingAuthenticationLevel extends AuthenticationLevelReading {
  const MissingAuthenticationLevel();

  @override
  bool meets(final AuthenticationLevel minimum) => false;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is MissingAuthenticationLevel;

  @override
  int get hashCode => (MissingAuthenticationLevel).hashCode;

  @override
  String toString() => 'MissingAuthenticationLevel()';
}
