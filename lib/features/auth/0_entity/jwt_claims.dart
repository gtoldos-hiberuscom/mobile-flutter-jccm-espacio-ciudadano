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
    this.representedAgentId,
    this.representedName,
    this.representedNif,
    this.certificateClassification,
    this.givenName,
    this.familyName,
    this.authNLevelRaw,
    this.idpSelected,
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
  final String? representedAgentId;
  final String? representedName;
  final String? representedNif;
  final String? certificateClassification;
  final String? givenName;
  final String? familyName;

  /// Nivel de autenticación alcanzado, **tal y como lo escribe Cerbero**
  /// (`authNLevel`): `low`, `substantial`…
  ///
  /// Se guarda el literal crudo a propósito. La entidad no decide la política
  /// de acceso: interpretarlo y ordenarlo es cosa de `AuthenticationLevel`, y
  /// conservar el original es lo único que permite diagnosticar un valor que
  /// todavía no sabemos leer en vez de tratarlo como ausente.
  final String? authNLevelRaw;

  /// Proveedor de identidad con el que se identificó el ciudadano
  /// (`idpSelected`): `SEGSOC`, `AFIRMA`… Solo para diagnóstico.
  ///
  /// **No deducir el nivel de aquí.** El requisito exige el claim, no el
  /// método: la correspondencia método → nivel la fija Cl@ve, no la app.
  final String? idpSelected;

  /// Whether the authenticated natural person is acting on behalf of another
  /// person or legal entity.
  ///
  /// `clave_representado` is an OAuth scope granted to ordinary citizen
  /// sessions too; it is not evidence that this particular session is acting
  /// on behalf of someone. The represented agent claim is the session-level
  /// marker and prevents regular users from seeing representative-only states.
  bool get isRepresentative => representedAgentId?.trim().isNotEmpty ?? false;

  /// Agent identifier expected in request bodies for the active identity.
  /// The URL continues to use [subAlt], which the gateway resolves itself.
  String? get effectiveAgentId {
    final represented = representedAgentId?.trim();
    if (represented != null && represented.isNotEmpty) {
      return represented;
    }
    final own = idAgente?.trim();
    return own == null || own.isEmpty ? null : own;
  }

  /// Document number of the subject whose data is being queried. A
  /// representative certificate authenticates the natural person, but
  /// expediente/registro request bodies must identify the represented entity.
  String? get effectivePersonIdentifier {
    final represented = representedNif?.trim().toUpperCase();
    if (represented != null && represented.isNotEmpty) {
      return represented;
    }
    return normalizedPersonIdentifier;
  }

  /// Name shown by authenticated UI for the identity whose data is active.
  /// Representative certificates must display the represented party instead
  /// of the natural person who owns the certificate.
  String? get effectiveDisplayName {
    final represented = representedName?.trim();
    if (isRepresentative && represented != null && represented.isNotEmpty) {
      return represented;
    }
    return fullName;
  }

  /// Si [other] identifica **a la misma persona** que estos claims.
  ///
  /// Se compara por documento, nunca por [sub]: Cerbero emite sujetos distintos
  /// según el proveedor de identidad (`SEGSOC` frente a `AFIRMA`), y ese salto
  /// es exactamente el que provoca una elevación de nivel — comparar [sub]
  /// daría «otra persona» en el caso normal.
  ///
  /// Se compara también la representación: entrar o salir de una representación
  /// cambia de quién son los datos que se van a mostrar, que es materialmente
  /// el mismo riesgo.
  ///
  /// Sin documento en cualquiera de los dos lados devuelve `false`: no se puede
  /// probar la igualdad, así que no se afirma.
  bool identifiesSamePersonAs(final JwtClaims other) {
    final own = (effectivePersonIdentifier ?? subAlt)?.trim().toUpperCase();
    final theirs = (other.effectivePersonIdentifier ?? other.subAlt)?.trim().toUpperCase();
    if (own == null || own.isEmpty || theirs == null || theirs.isEmpty) {
      return false;
    }
    return own == theirs && isRepresentative == other.isRepresentative;
  }

  /// Nombre y apellidos del ciudadano tal y como los informa Cerbero
  /// (`given_name` + `first_surname` + `second_surname`), con `name` como
  /// alternativa. Null cuando el token no trae ninguno.
  String? get fullName {
    final parts = [givenName, firstSurname, secondSurname].map((final part) => part?.trim() ?? '').where((final part) => part.isNotEmpty).toList(growable: false);
    if (parts.isNotEmpty) {
      return parts.join(' ');
    }
    final fallback = name?.trim();
    return fallback == null || fallback.isEmpty ? null : fallback;
  }

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
      representedAgentId: _str(payload['idagente_representado']),
      representedName: _str(payload['nombreRepresentado']),
      representedNif: _str(payload['nifRepresentado']),
      certificateClassification: _str(payload['clasificacionCertificado']),
      givenName: _str(payload['given_name']),
      familyName: _str(payload['family_name']),
      authNLevelRaw: _str(payload['authNLevel']),
      idpSelected: _str(payload['idpSelected']),
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
