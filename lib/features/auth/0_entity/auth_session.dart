/// Represents a successfully authenticated session token set.
final class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.scopes,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
  });

  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final String tokenType;
  final DateTime? accessTokenExpiresAt;
  final DateTime? refreshTokenExpiresAt;
  final List<String> scopes;

  bool get hasRefreshToken => refreshToken != null;

  bool get hasIdToken => idToken != null;

  bool isAccessTokenExpired({
    final DateTime? now,
    final Duration clockSkew = const Duration(seconds: 30),
  }) {
    final expiry = accessTokenExpiresAt;
    if (expiry == null) {
      return true;
    }

    final effectiveNow = now ?? DateTime.now();
    return !expiry.isAfter(effectiveNow.add(clockSkew));
  }

  @override
  String toString() {
    return 'AuthSession('
        'tokenType: $tokenType, '
        'accessTokenExpiresAt: $accessTokenExpiresAt, '
        'refreshTokenExpiresAt: $refreshTokenExpiresAt, '
        'scopes: $scopes, '
        'hasRefreshToken: $hasRefreshToken, '
        'hasIdToken: $hasIdToken'
        ')';
  }
}
