import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/ignore_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/app_update_preferences_repository_impl.dart';

import 'support/app_update_fakes.dart';

const _storeKey = '${StorageKeys.appUpdateIgnoredVersionPrefix}store';

AppUpdatePreferencesRepositoryImpl _repo(final MemoryAppStorage storage, {final String namespace = 'store'}) => AppUpdatePreferencesRepositoryImpl(storage, namespace: namespace);

void main() {
  group('AppUpdatePreferencesRepositoryImpl', () {
    test('sin nada guardado devuelve null', () async {
      final repo = _repo(MemoryAppStorage());
      expect(await repo.readIgnoredVersion(), isNull);
    });

    test('guarda y recupera la versión como x.y.z', () async {
      final storage = MemoryAppStorage();
      final repo = _repo(storage);

      await repo.saveIgnoredVersion(const AppVersion(1, 4, 2));

      expect(storage.values[_storeKey], '1.4.2');
      expect(await repo.readIgnoredVersion(), const AppVersion(1, 4, 2));
    });

    test('un valor corrupto en storage se lee como null', () async {
      final storage = MemoryAppStorage()..values[_storeKey] = 'garbage';
      final repo = _repo(storage);
      expect(await repo.readIgnoredVersion(), isNull);
    });

    test('si el storage rechaza la escritura, lanza', () {
      final repo = _repo(MemoryAppStorage(failWrites: true));
      expect(repo.saveIgnoredVersion(const AppVersion(1, 0, 0)), throwsStateError);
    });

    test('cada fuente guarda su propia versión ignorada', () async {
      final storage = MemoryAppStorage();
      await _repo(storage, namespace: 'mock').saveIgnoredVersion(const AppVersion(99, 0, 0));

      expect(await _repo(storage).readIgnoredVersion(), isNull);
      expect(await _repo(storage, namespace: 'mock').readIgnoredVersion(), const AppVersion(99, 0, 0));
    });
  });

  group('IgnoreAppUpdateUsecase', () {
    test('devuelve Saved cuando se persiste', () async {
      final storage = MemoryAppStorage();
      final usecase = IgnoreAppUpdateUsecase(_repo(storage));

      final result = await usecase.execute(version: const AppVersion(2, 0, 0));

      expect(result, isA<IgnoreAppUpdateSaved>());
      expect(storage.values[_storeKey], '2.0.0');
    });

    test('devuelve Failed cuando el storage falla', () async {
      final usecase = IgnoreAppUpdateUsecase(_repo(MemoryAppStorage(failWrites: true)));
      final result = await usecase.execute(version: const AppVersion(2, 0, 0));
      expect(result, isA<IgnoreAppUpdateFailed>());
    });
  });
}
