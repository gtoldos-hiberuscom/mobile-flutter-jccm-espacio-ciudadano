import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_token_diagnostics.dart';

/// Builds an unsigned JWT whose payload is [claims]. Only the payload matters:
/// the diagnostics never verify signatures (the backend does that).
String fakeJwt(final Map<String, Object?> claims) {
  String segment(final Object value) => base64Url.encode(utf8.encode(json.encode(value))).replaceAll('=', '');
  return '${segment(const {'alg': 'none'})}.${segment(claims)}.signature';
}

void main() {
  final now = DateTime.utc(2026, 9, 11, 12);

  test('tells an online refresh token apart from an offline one', () {
    final online = SessionTokenDiagnostics.describe(
      now: now,
      refreshToken: fakeJwt({'typ': 'Refresh', 'exp': now.add(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000}),
      tokenAdditionalParameters: const {'refresh_expires_in': 1800},
    );
    final offline = SessionTokenDiagnostics.describe(
      now: now,
      refreshToken: fakeJwt({'typ': 'Offline', 'exp': 0}),
      tokenAdditionalParameters: const {'refresh_expires_in': 0},
    );

    final onlineRefresh = online['refresh_token']! as Map<String, Object?>;
    expect(onlineRefresh['typ'], 'Refresh');
    expect(onlineRefresh['ttl_minutes'], 30);
    expect(online['refresh_expires_in'], 1800);

    final offlineRefresh = offline['refresh_token']! as Map<String, Object?>;
    expect(offlineRefresh['typ'], 'Offline');
    // `exp: 0` is how Keycloak says "this token has no expiry of its own".
    expect(offlineRefresh['never_expires'], true);
    expect(offline['refresh_expires_in'], 0);
  });

  test('reports the access-token lifetime and the granted scope', () {
    final diagnostics = SessionTokenDiagnostics.describe(
      now: now,
      accessToken: fakeJwt({'exp': now.add(const Duration(minutes: 5)).millisecondsSinceEpoch ~/ 1000}),
      tokenAdditionalParameters: const {'scope': 'openid offline_access'},
    );

    expect((diagnostics['access_token']! as Map<String, Object?>)['ttl_minutes'], 5);
    expect(diagnostics['granted_scope'], 'openid offline_access');
  });

  test('falls back to the access-token claim when the response omits the scope', () {
    // What Cerbero actually returned on the first PRE run: no `scope` among
    // the additional parameters, but `offline_access` present in the claim.
    final diagnostics = SessionTokenDiagnostics.describe(
      now: now,
      accessToken: fakeJwt({'exp': 0, 'scope': 'openid ext_profile offline_access profile'}),
      tokenAdditionalParameters: const {'refresh_expires_in': 0},
    );

    expect(diagnostics['granted_scope'], contains('offline_access'));
  });

  test('never includes token material, so it is safe to log unredacted', () {
    const secret = 'super-secret-token-material';
    final diagnostics = SessionTokenDiagnostics.describe(
      now: now,
      accessToken: fakeJwt({'exp': 0, 'sub': secret}),
      refreshToken: fakeJwt({'typ': 'Offline', 'sub': secret}),
    );

    expect(json.encode(diagnostics), isNot(contains(secret)));
  });

  test('survives absent and malformed tokens', () {
    final diagnostics = SessionTokenDiagnostics.describe(now: now, refreshToken: 'not-a-jwt');

    expect((diagnostics['access_token']! as Map<String, Object?>)['present'], false);
    final refresh = diagnostics['refresh_token']! as Map<String, Object?>;
    expect(refresh['present'], true);
    expect(refresh['typ'], isNull);
  });
}
