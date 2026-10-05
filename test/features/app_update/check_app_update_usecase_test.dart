import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/domain.dart';

import 'support/app_update_fakes.dart';

void main() {
  CheckAppUpdateUsecase build({
    required final String installed,
    final AppUpdateManifest? manifest,
    final Exception? manifestError,
    final Exception? installedError,
    final String? ignored,
  }) => CheckAppUpdateUsecase(
    manifests: FakeAppUpdateRepository(manifest: manifest, error: manifestError),
    installedVersions: FakeInstalledVersionRepository(AppVersion.parse(installed), error: installedError),
    preferences: FakeAppUpdatePreferencesRepository(ignored: AppVersion.tryParse(ignored)),
  );

  group('CheckAppUpdateUsecase', () {
    test('instalada por debajo de la mínima → forzada, aunque la política diga otra cosa', () async {
      final result = await build(
        installed: '0.9.0',
        manifest: buildManifest(policy: UpdatePolicy.none),
      ).execute();
      expect(result, isA<UpdateAvailable>());
      final info = (result as UpdateAvailable).info;
      expect(info.policy, UpdatePolicy.forced);
      expect(info.isForced, isTrue);
      expect(info.latestVersion, const AppVersion(2, 0, 0));
      expect(info.storeUrl, playStoreUrl);
    });

    test('entre mínima y última con política recommended → recomendada', () async {
      final result = await build(installed: '1.0.0', manifest: buildManifest()).execute();
      expect(result, isA<UpdateAvailable>());
      expect((result as UpdateAvailable).info.policy, UpdatePolicy.recommended);
    });

    test('entre mínima y última con política none → nada', () async {
      final result = await build(
        installed: '1.5.0',
        manifest: buildManifest(policy: UpdatePolicy.none),
      ).execute();
      expect(result, isA<UpdateNotRequired>());
    });

    test('entre mínima y última con política forced → forzada', () async {
      final result = await build(
        installed: '1.5.0',
        manifest: buildManifest(policy: UpdatePolicy.forced),
      ).execute();
      expect((result as UpdateAvailable).info.isForced, isTrue);
    });

    test('al día (igual o superior a la última) → nada', () async {
      expect(await build(installed: '2.0.0', manifest: buildManifest()).execute(), isA<UpdateNotRequired>());
      expect(await build(installed: '2.1.0', manifest: buildManifest()).execute(), isA<UpdateNotRequired>());
    });

    test('la recomendada ya descartada (misma versión) no se repite', () async {
      final result = await build(installed: '1.0.0', manifest: buildManifest(), ignored: '2.0.0').execute();
      expect(result, isA<UpdateNotRequired>());
    });

    test('haber descartado una versión posterior también la suprime (rollback remoto)', () async {
      final result = await build(installed: '1.0.0', manifest: buildManifest(), ignored: '2.5.0').execute();
      expect(result, isA<UpdateNotRequired>());
    });

    test('una versión descartada anterior no suprime la nueva recomendada', () async {
      final result = await build(
        installed: '1.0.0',
        manifest: buildManifest(latest: '2.1.0'),
        ignored: '2.0.0',
      ).execute();
      expect(result, isA<UpdateAvailable>());
    });

    test('la versión descartada nunca suprime una forzada', () async {
      final result = await build(installed: '0.5.0', manifest: buildManifest(), ignored: '2.0.0').execute();
      expect((result as UpdateAvailable).info.isForced, isTrue);
    });

    test('fallo del repositorio de manifiestos → Failed con la causa', () async {
      final result = await build(installed: '1.0.0', manifestError: const FormatException('roto')).execute();
      expect(result, isA<CheckAppUpdateFailed>());
      expect((result as CheckAppUpdateFailed).cause, isA<FormatException>());
    });

    test('fallo al leer la versión instalada → Failed', () async {
      final result = await build(installed: '1.0.0', manifest: buildManifest(), installedError: Exception('sin package info')).execute();
      expect(result, isA<CheckAppUpdateFailed>());
    });
  });
}
