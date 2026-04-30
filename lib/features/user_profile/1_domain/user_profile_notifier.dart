import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_notifier.g.dart';

/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   `authSessionProvider`. Returns `null` when there is no session.
/// - [logout] delegates to `AuthSessionNotifier.signOut`, which clears all
///   secure storage and resets session state.
@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    final user = ref.watch(currentAuthUserProvider);
    return user == null ? null : _mapProfile(user);
  }

  /// Signs the user out by delegating to the auth session notifier.
  Future<void> logout() async {
    await ref.read(authSessionProvider.notifier).signOut();
  }

  static UserProfile _mapProfile(final AuthUser user) {
    return UserProfile(
      idAgente: user.idAgente,
      displayName: user.displayName,
      email: user.email,
    );
  }
}
