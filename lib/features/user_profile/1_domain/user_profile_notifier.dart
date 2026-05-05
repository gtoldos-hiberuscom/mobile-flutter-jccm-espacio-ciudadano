import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart' show LogoutUseCase;
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/auth.dart' show LogoutUseCase;
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_notifier.g.dart';

/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   `authSessionProvider`. Returns `null` when there is no session.
/// - [logout] delegates to [LogoutUseCase], which terminates the Cl@ve
///   session and clears the persisted local data.
@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    final user = ref.watch(currentAuthUserProvider);
    return user == null ? null : _mapProfile(user);
  }

  /// Signs the user out by invoking the logout use case.
  ///
  /// Reads the active `id_token` from the current session — if there is
  /// none, the call short-circuits to clearing local state.
  Future<void> logout() async {
    final session = ref.read(currentAuthSessionProvider);
    final idToken = session?.idToken;
    if (idToken == null || idToken.isEmpty) {
      return;
    }
    await ref.read(logoutUseCaseProvider)(idToken: idToken);
  }

  static UserProfile _mapProfile(final AuthUser user) {
    return UserProfile(
      idAgente: user.idAgente,
      displayName: user.displayName,
      email: user.email,
    );
  }
}
