import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';

/// Manages the currently logged-in user's profile.
///
/// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
///   [UserProfile]; otherwise returns `null`.
/// - [logout] clears stored auth data, invalidates the session, and resets state.
class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    return null;

    // final idAgente = ref.watch(sessionStateProvider);
    // if (idAgente == null) {
    //   return null;
    // }
    // return UserProfile(idAgente: idAgente);
  }

  /// Signs the user out by clearing session data and resetting state.
  Future<void> logout() async {
    final secureStorage = ref.read(secureStorageProvider);
    final appStorage = ref.read(appStorageProvider);

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

final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(() {
  return UserProfileNotifier();
});
