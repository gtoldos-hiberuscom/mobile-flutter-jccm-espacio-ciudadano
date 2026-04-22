/// Represents an authenticated Cl@ve session.
///
/// Pure Dart — no Flutter, Riverpod, or infrastructure imports allowed.
/// All fields come from the Cl@ve OIDC token exchange response.
///
/// PII policy: never log [accessToken], [refreshToken], or [idAgente] in
/// plaintext. Treat all fields as sensitive.
final class Session {
  const Session({
    required this.accessToken,
    required this.idAgente,
    required this.expiresAt,
    required this.claims,
    this.refreshToken,
    this.displayName,
  });

  /// JWT access token used to authorise API requests.
  final String accessToken;

  /// JWT refresh token for silent session renewal. May be absent if the IdP
  /// does not issue refresh tokens (e.g. short-lived Cl@ve PIN sessions).
  final String? refreshToken;

  /// Federated user identifier supplied by Cl@ve (typically the DNI / NIE).
  final String idAgente;

  /// Human-readable display name from the Cl@ve identity assertion.
  final String? displayName;

  /// UTC instant after which the access token is no longer valid.
  final DateTime expiresAt;

  /// OIDC scopes / roles granted by Cl@ve for this session.
  final List<String> claims;

  // ── Derived state ──────────────────────────────────────────────────────────

  /// Returns `true` if the [expiresAt] instant has passed.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  // ── Value copy ─────────────────────────────────────────────────────────────

  Session copyWith({
    final String? accessToken,
    final String? refreshToken,
    final String? idAgente,
    final String? displayName,
    final DateTime? expiresAt,
    final List<String>? claims,
  }) {
    return Session(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      idAgente: idAgente ?? this.idAgente,
      displayName: displayName ?? this.displayName,
      expiresAt: expiresAt ?? this.expiresAt,
      claims: claims ?? this.claims,
    );
  }

  @override
  String toString() =>
      // PII: intentionally omit token values and idAgente.
      'Session(idAgente: [redacted], expiresAt: $expiresAt, '
      'claims: $claims, isExpired: $isExpired)';
}
