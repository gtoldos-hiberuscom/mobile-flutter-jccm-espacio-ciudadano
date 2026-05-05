import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
final class AuthUser with _$AuthUser {
  const AuthUser({
    required this.sub,
    this.nif,
    this.givenName,
    this.familyName,
    this.email,
  });

  @override
  final String sub;
  @override
  final String? nif;
  @override
  final String? givenName;
  @override
  final String? familyName;
  @override
  final String? email;
}
