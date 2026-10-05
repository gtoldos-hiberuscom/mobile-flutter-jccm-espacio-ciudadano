import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/ignore_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/app_update_preferences_repository_impl.dart';

import 'support/app_update_fakes.dart';

void main() {
  group('AppUpdatePreferencesRepositoryImpl', () {
    test('sin nada guardado devuelve null', () async {
      final repo = AppUpdatePreferencesRepositoryImpl(MemoryAppStorage());
      expect(await repo.readIgnoredVersion(), isNull);
    });

    test('guarda y recupera la versión como x.y.z', () async {
      final storage = MemoryAppStorage();
      final repo = AppUpdatePreferencesRepositoryImpl(storage);

      await repo.saveIgnoredVersion(const AppVersion(1, 4, 2));

      expect(storage.values[StorageKeys.appUpdateIgnoredVersion], '1.4.2');
      expect(await repo.readIgnoredVersion(), const AppVersion(1, 4, 2));
    });

    test('un valor corrupto en storage se lee como null', () async {
      final storage = MemoryAppStorage()..values[StorageKeys.appUpdateIgnoredVersion] = 'garbage';
      final repo = AppUpdatePreferencesRepositoryImpl(storage);
      expect(await repo.readIgnoredVersion(), isNull);
    });

    test('si el storage rechaza la escritura, lanza', () {
      final repo = AppUpdatePreferencesRepositoryImpl(MemoryAppStorage(failWrites: true));
      expect(repo.saveIgnoredVersion(const AppVersion(1, 0, 0)), throwsStateError);
    });
  });

  group('IgnoreAppUpdateUsecase', () {
    test('devuelve Saved cuando se persiste', () async {
      final storage = MemoryAppStorage();
      final usecase = IgnoreAppUpdateUsecase(AppUpdatePreferencesRepositoryImpl(storage));

      final result = await usecase.execute(version: const AppVersion(2, 0, 0));

      expect(result, isA<IgnoreAppUpdateSaved>());
      expect(storage.values[StorageKeys.appUpdateIgnoredVersion], '2.0.0');
    });

    test('devuelve Failed cuando el storage falla', () async {
      final usecase = IgnoreAppUpdateUsecase(AppUpdatePreferencesRepositoryImpl(MemoryAppStorage(failWrites: true)));
      final result = await usecase.execute(version: const AppVersion(2, 0, 0));
      expect(result, isA<IgnoreAppUpdateFailed>());
    });
  });
}
