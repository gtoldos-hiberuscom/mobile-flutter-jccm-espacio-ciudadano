import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';

/// DTO for the token response returned by the Cl@ve AppAuth exchange.
///
/// Stays in `3_data/` — never exposed outside the data layer.
final class ClaveTokenResponseDto {
  const ClaveTokenResponseDto({
    required this.accessToken,
    required this.tokenType,
    required this.scopes,
    required this.additionalParameters,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
  });

  factory ClaveTokenResponseDto.fromAppAuth(
    final TokenResponse response, {
    required final DateTime receivedAt,
  }) {
    final accessToken = _notBlank(response.accessToken, 'access_token');
    final additionalParameters = Map<String, dynamic>.unmodifiable(
      response.tokenAdditionalParameters ?? const {},
    );
    final expiresIn = _int(additionalParameters['expires_in']);
    final refreshExpiresIn = _int(additionalParameters['refresh_expires_in']);

    return ClaveTokenResponseDto(
      accessToken: accessToken,
      refreshToken: _blankToNull(response.refreshToken),
      idToken: _blankToNull(response.idToken),
      tokenType: _blankToNull(response.tokenType) ?? 'Bearer',
      scopes: List<String>.unmodifiable(response.scopes ?? const []),
      accessTokenExpiresAt:
          response.accessTokenExpirationDateTime ??
          _expiresAt(receivedAt, expiresIn),
      refreshTokenExpiresAt: _expiresAt(receivedAt, refreshExpiresIn),
      additionalParameters: additionalParameters,
    );
  }

  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final String tokenType;
  final DateTime? accessTokenExpiresAt;
  final DateTime? refreshTokenExpiresAt;
  final List<String> scopes;
  final Map<String, dynamic> additionalParameters;

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
    return 'ClaveTokenResponseDto('
        'tokenType: $tokenType, '
        'accessTokenExpiresAt: $accessTokenExpiresAt, '
        'refreshTokenExpiresAt: $refreshTokenExpiresAt, '
        'scopes: $scopes, '
        'hasRefreshToken: $hasRefreshToken, '
        'hasIdToken: $hasIdToken'
        ')';
  }

  static String _notBlank(final String? value, final String fieldName) {
    final normalized = _blankToNull(value);
    if (normalized == null) {
      throw AuthException.invalidResponse(
        message: 'Cl@ve token response did not include $fieldName.',
      );
    }
    return normalized;
  }

  static String? _blankToNull(final String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static int? _int(final Object? value) {
    return switch (value) {
      final int intValue => intValue,
      final double doubleValue => doubleValue.toInt(),
      final String stringValue => int.tryParse(stringValue),
      _ => null,
    };
  }

  static DateTime? _expiresAt(final DateTime receivedAt, final int? seconds) {
    if (seconds == null || seconds <= 0) {
      return null;
    }
    return receivedAt.add(Duration(seconds: seconds));
  }
}
