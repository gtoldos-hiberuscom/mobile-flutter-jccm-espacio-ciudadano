import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthUserNotifier extends _$AuthUserNotifier {
  @override
  AuthUser? build() => null;

  void update(final AuthUser? user) => state = user;
}
