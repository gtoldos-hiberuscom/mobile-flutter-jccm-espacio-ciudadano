import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthSessionNotifier extends _$AuthSessionNotifier {
  @override
  AuthSession? build() => null;

  void update(final AuthSession? session) => state = session;
}
