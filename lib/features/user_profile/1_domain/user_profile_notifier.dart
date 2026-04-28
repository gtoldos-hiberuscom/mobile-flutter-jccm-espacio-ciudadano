import 'package:jccm_espacio_ciudadano/core/auth/session_state_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_notifier.g.dart';

/// Manages the currently logged-in user's profile.
///
/// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
///   [UserProfile]; otherwise returns `null`.
/// - [logout] clears stored auth data, invalidates the session, and resets state.
@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    final idAgente = ref.watch(sessionStateProvider);
    if (idAgente == null) {
      return null;
    }
    return UserProfile(idAgente: idAgente);
  }

  /// Signs the user out by clearing session data and resetting state.
  Future<void> logout() async {
    final secureStorage = ref.read(secureStorageProvider);
    final appStorage = ref.read(appStorageProvider);

    ref.read(sessionStateProvider.notifier).invalidate();

    await Future.wait<void>(<Future<void>>[
      secureStorage.delete(StorageKeys.accessToken),
      secureStorage.delete(StorageKeys.refreshToken),
      secureStorage.delete(StorageKeys.idAgente),
      secureStorage.delete(StorageKeys.sessionExpiresAt),
      appStorage.remove(StorageKeys.accessToken).then((_) {}),
      appStorage.remove(StorageKeys.refreshToken).then((_) {}),
      appStorage.remove(StorageKeys.idAgente).then((_) {}),
      appStorage.remove(StorageKeys.sessionExpiresAt).then((_) {}),
    ]);

    state = const AsyncValue.data(null);
  }
}
