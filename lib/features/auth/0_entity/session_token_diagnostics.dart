import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';

/// Read-only description of the lifetimes a Keycloak session was granted.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
///
/// It answers two questions that are otherwise invisible from inside the app:
///
/// * **Which kind of refresh token is this?** Keycloak stamps `typ` on the
///   refresh token: `Refresh` for a token bound to the online SSO session and
///   `Offline` for one issued through the `offline_access` scope. Both arrive
///   in the very same field of the token response, so the type is the only way
///   to tell them apart.
/// * **How long does it actually last?** The access-token expiry is already
///   exposed by the plugin, but the *refresh* token lifetime only travels in
///   `refresh_expires_in`, inside the raw additional parameters, and is
///   discarded everywhere else. A value of `0` means the token does not expire
///   on its own — the hallmark of an offline token.
///
/// Only derived metadata is produced: instants, durations, the token type and
/// the granted scope. No token material is ever included, so the result is
/// safe to log in any build.
final class SessionTokenDiagnostics {
  const SessionTokenDiagnostics._();

  /// Builds the diagnostic map for a token response.
  ///
  /// [now] is injected so the computed TTLs are deterministic in tests.
  static Map<String, Object?> describe({
    required final DateTime now,
    final String? accessToken,
    final String? refreshToken,
    final Map<String, dynamic>? tokenAdditionalParameters,
  }) {
    final accessPayload = _payloadOf(accessToken);
    final refreshPayload = _payloadOf(refreshToken);

    return <String, Object?>{
      'access_token': _tokenSummary(accessToken, now),
      'refresh_token': <String, Object?>{
        ..._tokenSummary(refreshToken, now),
        // `Refresh` (online session) vs `Offline` (offline_access session).
        'typ': refreshPayload['typ'],
      },
      // Cerbero does not echo `scope` in the token response's additional
      // parameters (it came back null on the first PRE run), but the access
      // token always carries the granted scope as a claim. Reading both keeps
      // the diagnostic self-sufficient: what was *granted*, not what we asked.
      'granted_scope': tokenAdditionalParameters?['scope'] ?? accessPayload['scope'],
      // Seconds the authorization server says the refresh token is good for.
      // `0` on an offline token: it outlives the session that created it.
      'refresh_expires_in': tokenAdditionalParameters?['refresh_expires_in'],
    };
  }

  static Map<String, dynamic> _payloadOf(final String? token) =>
      (token == null || token.isEmpty) ? const <String, dynamic>{} : JwtDecoder.decodePayload(token);

  static Map<String, Object?> _tokenSummary(final String? token, final DateTime now) {
    if (token == null || token.isEmpty) {
      return const <String, Object?>{'present': false};
    }

    final payload = JwtDecoder.decodePayload(token);
    final exp = payload['exp'];
    if (exp is! int) {
      return <String, Object?>{'present': true, 'exp': null};
    }
    if (exp == 0) {
      // Keycloak writes `exp: 0` when the token carries no expiry of its own.
      return <String, Object?>{'present': true, 'exp': 0, 'never_expires': true};
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    return <String, Object?>{
      'present': true,
      'expires_at': expiresAt.toIso8601String(),
      'ttl_minutes': expiresAt.difference(now.toUtc()).inMinutes,
    };
  }
}
