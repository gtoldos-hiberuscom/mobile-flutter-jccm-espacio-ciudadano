import 'dart:convert';

import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';

/// Utility for extracting claims from a JWT without verifying its signature.
///
/// Pure Dart — no Flutter, Riverpod, or infrastructure imports.
///
/// Client-side JWT signature verification is intentionally omitted: tokens
/// arrive over HTTPS and the backend validates signatures before responding
/// to any protected request. This class exists to read claims for UI routing
/// and `JwtClaims` construction, not for security enforcement.
final class JwtDecoder {
  const JwtDecoder._();

  /// Decodes the payload section of [token] and returns a [JwtClaims].
  ///
  /// **Never throws.** Returns a [JwtClaims] with `sub: ''` and `exp: 0`
  /// on any failure (malformed token, invalid Base64, invalid JSON).
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

  static JwtClaims _empty() => JwtClaims.fromMap(const {});
}
