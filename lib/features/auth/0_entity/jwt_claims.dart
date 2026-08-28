enum IdentificationDocumentType {
  dni,
  nie,
  legalEntityNif,
  other,
}

/// Parsed representation of the JWT claims returned by Cerbero.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
final class JwtClaims {
  const JwtClaims({
    required this.exp,
    required this.iat,
    required this.iss,
    required this.aud,
    required this.sub,
    this.authTime,
    this.jti,
    this.typ,
    this.azp,
    this.nonce,
    this.sessionState,
    this.realmAccess,
    this.scope,
    this.sid,
    this.subAlt,
    this.personIdentifier,
    this.secondSurname,
    this.name,
    this.firstSurname,
    this.preferredUsername,
    this.idAgente,
    this.givenName,
    this.familyName,
  });

  final int exp;
  final int iat;
  final String iss;
  final List<String> aud;
  final String sub;
  final int? authTime;
  final String? jti;
  final String? typ;
  final String? azp;
  final String? nonce;
  final String? sessionState;
  final JwtRealmAccess? realmAccess;
  final String? scope;
  final String? sid;

  /// Identificador del ciudadano/agente que el gateway de Espacio Ciudadano
  /// espera como segmento `{sid}` de `/api/v1/ciudadanos/{sid}/...`.
  ///
  /// No confundir con [sid], que es el `session_state` de Keycloak.
  final String? subAlt;
  final String? personIdentifier;
  final String? secondSurname;
  final String? name;
  final String? firstSurname;
  final String? preferredUsername;
  final String? idAgente;
  final String? givenName;
  final String? familyName;

  /// Document identifier expected by `/api/v1/ciudadanos/{id}` endpoints.
  String? get normalizedPersonIdentifier {
    final value = personIdentifier?.trim().toUpperCase();
    if (value == null || value.isEmpty) {
      return null;
    }

    // Cl@ve/eIDAS may expose PersonIdentifier as `ES/ES/12345678Z` or as a
    // namespaced URN. Ciudadanos endpoints expect only the NIF/NIE value and
    // reject prefixed identifiers with 403 because they no longer match the
    // document embedded in the access token.
    final segments = value.split(RegExp(r'[/\\:]')).where((final segment) => segment.isNotEmpty).toList(growable: false);
    return segments.isEmpty ? null : segments.last;
  }

  /// Document type inferred from the normalized Spanish identifier format.
  ///
  /// Cerbero currently provides the identifier but no explicit claim that
  /// distinguishes natural persons from legal entities.
  IdentificationDocumentType get identificationDocumentType {
    final identifier = normalizedPersonIdentifier;
    if (identifier == null) {
      return IdentificationDocumentType.other;
    }
    if (RegExp(r'^\d{8}[A-Z]$').hasMatch(identifier)) {
      return IdentificationDocumentType.dni;
    }
    if (RegExp(r'^[XYZ]\d{7}[A-Z]$').hasMatch(identifier)) {
      return IdentificationDocumentType.nie;
    }
    if (RegExp(r'^[ABCDEFGHJNPQRSUVW]\d{7}[0-9A-J]$').hasMatch(identifier)) {
      return IdentificationDocumentType.legalEntityNif;
    }
    return IdentificationDocumentType.other;
  }

  /// Parses a raw JWT payload map into a [JwtClaims] instance.
  ///
  /// Null-safe and non-throwing: absent or malformed fields become their
  /// default values.
  factory JwtClaims.fromMap(final Map<String, dynamic> payload) {
    final rawAud = payload['aud'];
    final List<String> aud;
    if (rawAud is List) {
      aud = rawAud.whereType<String>().toList(growable: false);
    } else if (rawAud is String && rawAud.isNotEmpty) {
      aud = [rawAud];
    } else {
      aud = const [];
    }

    return JwtClaims(
      exp: _int(payload['exp']) ?? 0,
      iat: _int(payload['iat']) ?? 0,
      iss: _str(payload['iss']) ?? '',
      aud: aud,
      sub: _str(payload['sub']) ?? '',
      authTime: _int(payload['auth_time']),
      jti: _str(payload['jti']),
      typ: _str(payload['typ']),
      azp: _str(payload['azp']),
      nonce: _str(payload['nonce']),
      sessionState: _str(payload['session_state']),
      realmAccess: JwtRealmAccess.tryParse(payload['realm_access']),
      scope: _str(payload['scope']),
      sid: _str(payload['sid']),
      subAlt: _str(payload['sub_alt']),
      personIdentifier: _str(payload['PersonIdentifier']),
      secondSurname: _str(payload['second_surname']),
      name: _str(payload['name']),
      firstSurname: _str(payload['first_surname']),
      preferredUsername: _str(payload['preferred_username']),
      idAgente: _str(payload['idAgente']),
      givenName: _str(payload['given_name']),
      familyName: _str(payload['family_name']),
    );
  }

  static String? _str(final Object? value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  static int? _int(final Object? value) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  String toString() =>
      'JwtClaims(sub: $sub, iss: $iss, exp: $exp, aud: $aud, '
      'preferredUsername: $preferredUsername, idAgente: $idAgente)';
}

final class JwtRealmAccess {
  const JwtRealmAccess({
    required this.roles,
  });

  final List<String> roles;

  static JwtRealmAccess? tryParse(final Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    final rawRoles = value['roles'];
    if (rawRoles is! List) {
      return null;
    }

    return JwtRealmAccess(
      roles: rawRoles.whereType<String>().toList(growable: false),
    );
  }

  @override
  String toString() => 'JwtRealmAccess(roles: $roles)';
}
