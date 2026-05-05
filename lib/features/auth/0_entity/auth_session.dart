import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

@freezed
final class AuthSession with _$AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.scopes,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
  });

  @override
  final String accessToken;
  @override
  final String? refreshToken;
  @override
  final String? idToken;
  @override
  final String tokenType;
  @override
  final DateTime? accessTokenExpiresAt;
  @override
  final DateTime? refreshTokenExpiresAt;
  @override
  final List<String> scopes;
}
