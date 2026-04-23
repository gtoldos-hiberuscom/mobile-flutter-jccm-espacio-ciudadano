import 'package:jccm_espacio_ciudadano/core/auth/session_state_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_notifier.g.dart';

/// Manages the currently logged-in user's profile.
///
/// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
///   [UserProfile]; otherwise returns `null`.
/// - [logout] delegates to [SessionNotifier.logout] then resets state.
@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    final idAgente = ref.watch(sessionStateProvider);
    if (idAgente == null) return null;
    return UserProfile(idAgente: idAgente);
  }

  /// Signs the user out by delegating to [SessionNotifier] and clearing state.
  Future<void> logout() async {
    await ref.read(sessionProvider.notifier).logout();
    state = const AsyncValue.data(null);
  }
}
