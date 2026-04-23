import 'dart:convert';

import 'package:jccm_espacio_ciudadano/core/auth/jwt_claims.dart';

/// Utility for extracting claims from a JWT without verifying its signature.
///
/// Pure Dart — no Flutter, Riverpod, or infrastructure imports.
///
/// ## Design decision
/// Client-side JWT **signature verification is intentionally omitted**.
/// Rationale:
/// - Tokens are delivered over HTTPS; transport integrity is assured.
/// - The backend API already validates signatures server-side before
///   responding to any protected request.
/// - JWKS key-rotation lookup adds latency and complexity to the client.
/// - This class exists to *read* claims for UI routing and `Session`
///   construction, not for security enforcement.
///
/// See `docs/architecture/TASK-21-jwt-claims-validation.md` §7.1 for the
/// full architecture decision record.
///
/// ## Usage
/// ```dart
/// final claims = JwtDecoder.decode(idToken);
/// if (!claims.validateAudience(appClientId)) { /* reject */ }
/// if (claims.isExpired) { /* reject */ }
/// ```
final class JwtDecoder {
  // Private constructor — all members are static.
  const JwtDecoder._();

  /// Decodes the payload section of [token] and returns a [JwtClaims].
  ///
  /// - Splits the token on `.` to extract the Base64Url-encoded payload.
  /// - Adds padding if necessary and decodes via [base64Url].
  /// - JSON-parses the decoded bytes.
  /// - Delegates field extraction to [JwtClaims.fromMap].
  ///
  /// **Never throws.** If any step fails (malformed token, invalid Base64,
  /// invalid JSON) the method returns a [JwtClaims] with `sub: ''`,
  /// `iss: ''`, `exp: 0`, `iat: 0`, and all optional fields `null`.
  /// The caller's audience and expiry gates will then reject such a token.
  static JwtClaims decode(final String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) {
        return _empty();
      }

      // Base64Url decode — restore padding stripped by the JWT spec.
      var payload = parts[1];
      final remainder = payload.length % 4;
      if (remainder != 0) {
        payload = payload.padRight(payload.length + (4 - remainder), '=');
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final map = json.decode(decoded) as Map<String, dynamic>;
      return JwtClaims.fromMap(map);
    } catch (_) {
      return _empty();
    }
  }

  /// Returns a [JwtClaims] instance with all fields at their safe defaults.
  ///
  /// `isExpired` will be `true` (exp == 0) and `validateAudience()` will
  /// return `false` (aud is empty), ensuring any token-gated path rejects it.
  static JwtClaims _empty() => JwtClaims.fromMap(const {});
}
