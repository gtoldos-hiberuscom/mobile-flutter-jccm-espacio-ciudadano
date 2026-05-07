/// Parsed representation of a Cl@ve OIDC id\_token payload.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
final class JwtClaims {
  const JwtClaims({
    required this.sub,
    required this.iss,
    required this.aud,
    required this.exp,
    required this.iat,
    this.nif,
    this.givenName,
    this.familyName,
    this.email,
    this.authTime,
    this.jti,
    this.typ,
    this.azp,
    this.nonce,
    this.sessionState,
    this.realmAccess,
    this.scope,
    this.sid,
    this.personIdentifier,
    this.name,
    this.firstName,
    this.secondSurname,
    this.preferredUsername,
  });

  // ── Standard OIDC claims ──────────────────────────────────────────────────

  /// Subject — opaque user identifier assigned by Cl@ve.
  final String sub;

  /// Issuer URL of the Cl@ve identity provider.
  final String iss;

  /// Audience list — must contain the app's registered `client_id`.
  final List<String> aud;

  /// Expiry timestamp (seconds since Unix epoch).
  final int exp;

  /// Issued-at timestamp (seconds since Unix epoch).
  final int iat;

  // ── Cl@ve identity claims ─────────────────────────────────────────────────

  /// National identity number (DNI / NIE) supplied by Cl@ve.
  ///
  /// The claim may be named `nif` or `idAgente` depending on the federation
  /// profile.
  final String? nif;

  /// Given (first) name from the Cl@ve identity assertion.
  final String? givenName;

  /// Family (last) name from the Cl@ve identity assertion.
  final String? familyName;

  /// Email address — optional and not always present in Cl@ve tokens.
  final String? email;

  // ── Additional OIDC & Cerbero claims ──────────────────────────────────────

  /// Time when the user authenticated (seconds since Unix epoch).
  final int? authTime;

  /// JWT ID — unique identifier for this token.
  final String? jti;

  /// Token type (e.g., "Bearer").
  final String? typ;

  /// Authorized party — typically the client that the token was issued to.
  final String? azp;

  /// Nonce value used to prevent replay attacks.
  final String? nonce;

  /// Session state identifier.
  final String? sessionState;

  /// Realm access information containing roles and other realm-specific data.
  final Map<String, dynamic>? realmAccess;

  /// OAuth scope(s) granted to this token.
  final String? scope;

  /// Session ID.
  final String? sid;

  /// Person identifier (usually DNI/NIE without special characters).
  final String? personIdentifier;

  /// Full name of the user.
  final String? name;

  /// First name of the user.
  final String? firstName;

  /// Second surname of the user.
  final String? secondSurname;

  /// Preferred username for login.
  final String? preferredUsername;

  // ── Derived helpers ───────────────────────────────────────────────────────

  /// Returns [nif] when present; falls back to [sub] if absent.
  String get idAgente => nif ?? sub;

  /// Combines [givenName] and [familyName]; returns `null` when both are absent.
  String? get displayName {
    final given = givenName?.trim();
    final family = familyName?.trim();
    if (given != null && given.isNotEmpty && family != null && family.isNotEmpty) {
      return '$given $family';
    }
    if (given != null && given.isNotEmpty) {
      return given;
    }
    if (family != null && family.isNotEmpty) {
      return family;
    }
    return null;
  }

  /// Returns `true` if the token's [exp] timestamp has passed.
  bool get isExpired {
    final expiryMs = exp * 1000;
    return DateTime.now().millisecondsSinceEpoch > expiryMs;
  }

  /// Returns `true` when [aud] contains [clientId].
  bool validateAudience(final String clientId) => aud.contains(clientId);

  // ── Factory ───────────────────────────────────────────────────────────────

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
      sub: _str(payload['sub']) ?? '',
      iss: _str(payload['iss']) ?? '',
      aud: aud,
      exp: _int(payload['exp']) ?? 0,
      iat: _int(payload['iat']) ?? 0,
      nif: _str(payload['nif']) ?? _str(payload['idAgente']),
      givenName: _str(payload['given_name']),
      familyName: _str(payload['family_name']),
      email: _str(payload['email']),
      authTime: _int(payload['auth_time']),
      jti: _str(payload['jti']),
      typ: _str(payload['typ']),
      azp: _str(payload['azp']),
      nonce: _str(payload['nonce']),
      sessionState: _str(payload['session_state']),
      realmAccess: payload['realm_access'] is Map ? payload['realm_access'] as Map<String, dynamic> : null,
      scope: _str(payload['scope']),
      sid: _str(payload['sid']),
      personIdentifier: _str(payload['PersonIdentifier']),
      name: _str(payload['name']),
      firstName: _str(payload['first_surname']),
      secondSurname: _str(payload['second_surname']),
      preferredUsername: _str(payload['preferred_username']),
    );
  }

  static String? _str(final Object? v) {
    if (v is String && v.isNotEmpty) {
      return v;
    }
    return null;
  }

  static int? _int(final Object? v) {
    if (v is int) {
      return v;
    }
    if (v is double) {
      return v.toInt();
    }
    if (v is String) {
      return int.tryParse(v);
    }
    return null;
  }

  @override
  String toString() =>
      'JwtClaims(iss: $iss, exp: $exp, isExpired: $isExpired, '
      'aud: $aud, hasNif: ${nif != null})';
}
