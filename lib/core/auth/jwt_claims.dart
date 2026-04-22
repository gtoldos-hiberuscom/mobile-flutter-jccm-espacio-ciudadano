/// Parsed representation of a Cl@ve OIDC id\_token payload.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
///
/// ## Usage
/// ```dart
/// final claims = JwtDecoder.decode(idToken);
/// if (!claims.validateAudience(appClientId)) { /* reject */ }
/// if (claims.isExpired) { /* reject */ }
/// final session = Session(
///   idAgente:    claims.idAgente,
///   displayName: claims.displayName,
///   expiresAt:   DateTime.fromMillisecondsSinceEpoch(claims.exp * 1000, isUtc: true),
///   ...
/// );
/// ```
///
/// See `docs/architecture/TASK-21-jwt-claims-validation.md` for the full
/// claims contract and fallback strategy.
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
  /// profile — see TASK-21 validation checklist.
  final String? nif;

  /// Given (first) name from the Cl@ve identity assertion.
  final String? givenName;

  /// Family (last) name from the Cl@ve identity assertion.
  final String? familyName;

  /// Email address — optional and not always present in Cl@ve tokens.
  final String? email;

  // ── Derived helpers ───────────────────────────────────────────────────────

  /// Federated user identifier for the `Session.idAgente` field.
  ///
  /// Returns [nif] when present; falls back to [sub] if absent.
  /// The fallback is safe for routing but may fail downstream services
  /// that expect a NIF — see TASK-21 documentation.
  String get idAgente => nif ?? sub;

  /// Human-readable display name for the `Session.displayName` field.
  ///
  /// Combines [givenName] and [familyName] when both are present.
  /// Returns [givenName] alone when [familyName] is absent, or vice-versa.
  /// Returns `null` when both are absent (caller should fall back to [sub]).
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
  ///
  /// Uses wall-clock time; does not account for clock skew.
  bool get isExpired {
    final expiryMs = exp * 1000;
    return DateTime.now().millisecondsSinceEpoch > expiryMs;
  }

  /// Returns `true` when [aud] contains [clientId].
  ///
  /// This is the audience gate — reject the token if this returns `false`.
  bool validateAudience(final String clientId) => aud.contains(clientId);

  // ── Factory ───────────────────────────────────────────────────────────────

  /// Parses a raw JWT payload map into a [JwtClaims] instance.
  ///
  /// Null-safe and non-throwing: absent or malformed fields become their
  /// default values (`sub` and `iss` default to empty strings, `exp` and
  /// `iat` default to `0`, `aud` defaults to an empty list).
  factory JwtClaims.fromMap(final Map<String, dynamic> payload) {
    // `aud` may be a single string or a JSON array.
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
      // Cl@ve may use either 'nif' or 'idAgente' — check both.
      nif: _str(payload['nif']) ?? _str(payload['idAgente']),
      givenName: _str(payload['given_name']),
      familyName: _str(payload['family_name']),
      email: _str(payload['email']),
    );
  }

  // ── Private parsing helpers ───────────────────────────────────────────────

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
      // PII: intentionally omit nif / sub values.
      'JwtClaims(iss: $iss, exp: $exp, isExpired: $isExpired, '
      'aud: $aud, hasNif: ${nif != null})';
}
