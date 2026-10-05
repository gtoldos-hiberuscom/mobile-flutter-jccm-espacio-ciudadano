import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/app_update_mock_scenario.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/static_app_update_repository_impl.dart';

void main() {
  const platforms = ['android', 'ios'];

  StaticAppUpdateRepositoryImpl repoFor(final AppUpdateMockScenario scenario, final String platform) => StaticAppUpdateRepositoryImpl(manifestJson: scenario.manifestJson, platformKey: platform);

  group('StaticAppUpdateRepositoryImpl', () {
    for (final platform in platforms) {
      test('[$platform] "none": la instalada ya es la última', () async {
        final manifest = await repoFor(AppUpdateMockScenario.none, platform).fetchManifest();
        expect(manifest.latestVersion, const AppVersion(0, 0, 1));
        expect(manifest.minVersion, const AppVersion(0, 0, 1));
        expect(manifest.policy, UpdatePolicy.none);
      });

      test('[$platform] "recommended": última muy por encima, mínima muy por debajo', () async {
        final manifest = await repoFor(AppUpdateMockScenario.recommended, platform).fetchManifest();
        expect(manifest.latestVersion, const AppVersion(99, 0, 0));
        expect(manifest.minVersion, const AppVersion(0, 0, 1));
        expect(manifest.policy, UpdatePolicy.recommended);
      });

      test('[$platform] "forced": la mínima está por encima de cualquier instalada', () async {
        final manifest = await repoFor(AppUpdateMockScenario.forced, platform).fetchManifest();
        expect(manifest.minVersion, const AppVersion(99, 0, 0));
        expect(manifest.latestVersion, const AppVersion(99, 0, 0));
      });
    }

    test('las URLs de tienda de los manifiestos pasan la lista blanca', () async {
      final android = await repoFor(AppUpdateMockScenario.forced, 'android').fetchManifest();
      final ios = await repoFor(AppUpdateMockScenario.forced, 'ios').fetchManifest();
      expect(android.storeUrl.host, 'play.google.com');
      expect(ios.storeUrl.host, 'apps.apple.com');
    });

    test('un manifiesto roto hace fallar fetchManifest', () {
      const repo = StaticAppUpdateRepositoryImpl(manifestJson: '{"android": {}}', platformKey: 'android');
      expect(repo.fetchManifest(), throwsFormatException);
    });
  });

  group('AppUpdateMockScenario.fromName', () {
    test('resuelve cada escenario por su nombre', () {
      expect(AppUpdateMockScenario.fromName('forced'), AppUpdateMockScenario.forced);
      expect(AppUpdateMockScenario.fromName('recommended'), AppUpdateMockScenario.recommended);
      expect(AppUpdateMockScenario.fromName('none'), AppUpdateMockScenario.none);
    });

    test('un nombre desconocido cae en "none"', () {
      expect(AppUpdateMockScenario.fromName('typo'), AppUpdateMockScenario.none);
    });
  });
}
