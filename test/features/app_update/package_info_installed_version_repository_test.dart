import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/package_info_installed_version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

PackageInfo _info({final String version = '0.1.8', final String buildNumber = '10'}) => PackageInfo(
  appName: 'Espacio Ciudadano',
  packageName: 'es.jccm.espaciociudadano',
  version: version,
  buildNumber: buildNumber,
);

void main() {
  group('PackageInfoInstalledVersionRepository', () {
    test('en Android la versión instalada es el versionCode como 0.0.N', () async {
      final repo = PackageInfoInstalledVersionRepository(platform: StorePlatform.android, loadPackageInfo: () async => _info());
      expect(await repo.installedVersion(), const AppVersion(0, 0, 10));
    });

    test('en iOS la versión instalada es la de marketing', () async {
      final repo = PackageInfoInstalledVersionRepository(platform: StorePlatform.ios, loadPackageInfo: () async => _info());
      expect(await repo.installedVersion(), const AppVersion(0, 1, 8));
    });

    test('sin tienda conocida usa la versión de marketing', () async {
      final repo = PackageInfoInstalledVersionRepository(platform: null, loadPackageInfo: () async => _info());
      expect(await repo.installedVersion(), const AppVersion(0, 1, 8));
    });

    test('el id de aplicación es el packageName', () async {
      final repo = PackageInfoInstalledVersionRepository(platform: StorePlatform.ios, loadPackageInfo: () async => _info());
      expect(await repo.applicationId(), 'es.jccm.espaciociudadano');
    });

    test('PackageInfo se carga una sola vez para ambos métodos', () async {
      var loads = 0;
      final repo = PackageInfoInstalledVersionRepository(
        platform: StorePlatform.android,
        loadPackageInfo: () async {
          loads++;
          return _info();
        },
      );
      await repo.installedVersion();
      await repo.applicationId();
      await repo.installedVersion();
      expect(loads, 1);
    });

    test('un versionCode no numérico falla con FormatException', () {
      final repo = PackageInfoInstalledVersionRepository(
        platform: StorePlatform.android,
        loadPackageInfo: () async => _info(buildNumber: 'abc'),
      );
      expect(repo.installedVersion(), throwsFormatException);
    });

    test('un fallo al cargar PackageInfo no se memoriza', () async {
      var loads = 0;
      final repo = PackageInfoInstalledVersionRepository(
        platform: StorePlatform.ios,
        loadPackageInfo: () async {
          loads++;
          if (loads == 1) {
            throw StateError('plugin no disponible');
          }
          return _info();
        },
      );
      await expectLater(repo.installedVersion(), throwsStateError);
      expect(await repo.installedVersion(), const AppVersion(0, 1, 8));
      expect(loads, 2);
    });
  });
}
