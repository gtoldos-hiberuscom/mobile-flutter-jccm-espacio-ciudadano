import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_tokens.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_session_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_notifier.g.dart';

/// Reactive view of the persisted [AuthSessionState].
///
/// Pure exposition: no business logic, no I/O. The notifier subscribes to
/// `AuthSessionRepository.watch()` and rebuilds whenever a use case
/// (`LoginUseCase`, `LogoutUseCase`) mutates the persisted session.
@Riverpod(keepAlive: true)
class AuthSessionNotifier extends _$AuthSessionNotifier {
  @override
  Future<AuthSessionState> build() async {
    final repo = ref.watch(authSessionRepositoryProvider);
    final subscription = repo.watch().listen((final next) {
      state = AsyncValue<AuthSessionState>.data(next);
    });
    ref.onDispose(subscription.cancel);
    return repo.read();
  }
}

/// Convenience: returns the active [AuthTokens] or \`null\`.
@Riverpod(keepAlive: true)
AuthTokens? currentAuthSession(final Ref ref) {
  return ref.watch(authSessionProvider).value?.sessionOrNull;
}

/// Convenience: returns the active [AuthUser] or \`null\`.
@Riverpod(keepAlive: true)
AuthUser? currentAuthUser(final Ref ref) {
  return ref.watch(authSessionProvider).value?.userOrNull;
}

/// Convenience: returns the citizen's \`idAgente\` (NIF / sub) or \`null\`.
///
/// Canonical entry point for feature code that needs the document
/// identifier — recommendations, hechos vitales, firma, etc.
@Riverpod(keepAlive: true)
String? currentIdAgente(final Ref ref) {
  return ref.watch(authSessionProvider).value?.idAgente;
}
