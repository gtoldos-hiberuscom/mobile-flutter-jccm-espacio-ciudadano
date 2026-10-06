import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/check_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/api/play_in_app_update_api.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/play_update_info_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/play_manifest_mapper.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/play_app_update_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/unsupported_platform_app_update_repository.dart';

import 'support/app_update_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeInstalledVersionRepository installed;

  setUp(() {
    installed = FakeInstalledVersionRepository(const AppVersion(0, 0, 10));
  });

  PlayAppUpdateRepositoryImpl repoWith(final PlayUpdateInfoDto dto) => PlayAppUpdateRepositoryImpl(installed: installed, checkForUpdate: () async => dto);

  group('PlayAppUpdateRepositoryImpl', () {
    test('con actualización disponible devuelve el versionCode publicado como 0.0.N, recomendada y sin versión legible', () async {
      final manifest = await repoWith(const PlayUpdateInfoDto(updateAvailable: true, availableVersionCode: 12, updatePriority: 0)).fetchManifest();

      expect(manifest.latestVersion, const AppVersion(0, 0, 12));
      expect(manifest.minVersion, const AppVersion(0, 0, 0));
      expect(manifest.policy, UpdatePolicy.recommended);
      expect(manifest.displayVersion, isNull);
      expect(manifest.storeUrl.host, 'play.google.com');
      expect(manifest.storeUrl.queryParameters['id'], 'es.jccm.espaciociudadano');
    });

    test('con prioridad alta la actualización es obligatoria (mínima = publicada)', () async {
      for (final priority in [PlayManifestMapper.forcedUpdatePriorityThreshold, 5]) {
        final manifest = await repoWith(PlayUpdateInfoDto(updateAvailable: true, availableVersionCode: 12, updatePriority: priority)).fetchManifest();
        expect(manifest.minVersion, const AppVersion(0, 0, 12), reason: 'priority $priority');
      }
    });

    test('con prioridad por debajo del umbral solo recomienda', () async {
      final manifest = await repoWith(const PlayUpdateInfoDto(updateAvailable: true, availableVersionCode: 12, updatePriority: 3)).fetchManifest();
      expect(manifest.minVersion, const AppVersion(0, 0, 0));
    });

    test('sin actualización disponible la publicada es la instalada', () async {
      final manifest = await repoWith(const PlayUpdateInfoDto(updateAvailable: false, availableVersionCode: null, updatePriority: 0)).fetchManifest();
      expect(manifest.latestVersion, const AppVersion(0, 0, 10));
      expect(manifest.minVersion, const AppVersion(0, 0, 0));
    });

    test('actualización disponible sin versionCode es un manifiesto inválido', () {
      expect(repoWith(const PlayUpdateInfoDto(updateAvailable: true, availableVersionCode: null, updatePriority: 0)).fetchManifest(), throwsFormatException);
    });

    test('un fallo del plugin se propaga tal cual', () {
      final repo = PlayAppUpdateRepositoryImpl(
        installed: installed,
        checkForUpdate: () async => throw PlatformException(code: 'ERROR_APP_NOT_OWNED'),
      );
      expect(repo.fetchManifest(), throwsA(isA<PlatformException>()));
    });

    test('integrado con el use case: prioridad alta → forzada sin versión legible; sin actualización → nada', () async {
      final forced = await CheckAppUpdateUsecase(
        manifests: repoWith(const PlayUpdateInfoDto(updateAvailable: true, availableVersionCode: 12, updatePriority: 5)),
        installedVersions: installed,
        preferences: FakeAppUpdatePreferencesRepository(),
      ).execute();
      expect(forced, isA<UpdateAvailable>());
      expect((forced as UpdateAvailable).info.isForced, isTrue);
      expect(forced.info.displayVersion, isNull);

      final none = await CheckAppUpdateUsecase(
        manifests: repoWith(const PlayUpdateInfoDto(updateAvailable: false, availableVersionCode: null, updatePriority: 0)),
        installedVersions: installed,
        preferences: FakeAppUpdatePreferencesRepository(),
      ).execute();
      expect(none, isA<UpdateNotRequired>());
    });
  });

  group('PlayInAppUpdateApi', () {
    // Canal del plugin, simulado: fuera de Android no hay implementación y el
    // `timeout` del envoltorio no corre bajo el reloj falso de testWidgets.
    const channel = MethodChannel('de.ffuf.in_app_update/methods');
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    Map<String, Object?> playResult({required final int updateAvailability, final int? availableVersionCode, final int updatePriority = 0}) => <String, Object?>{
      'updateAvailability': updateAvailability,
      'immediateAllowed': true,
      'immediateAllowedPreconditions': <int>[],
      'flexibleAllowed': true,
      'flexibleAllowedPreconditions': <int>[],
      'availableVersionCode': availableVersionCode,
      'installStatus': 0,
      'packageName': 'es.jccm.espaciociudadano',
      'clientVersionStalenessDays': null,
      'updatePriority': updatePriority,
    };

    tearDown(() => messenger.setMockMethodCallHandler(channel, null));

    test('traduce una actualización disponible al DTO propio', () async {
      messenger.setMockMethodCallHandler(channel, (final call) async {
        expect(call.method, 'checkForUpdate');
        return playResult(updateAvailability: 2, availableVersionCode: 12, updatePriority: 5);
      });

      final dto = await PlayInAppUpdateApi.checkForUpdate();

      expect(dto.updateAvailable, isTrue);
      expect(dto.availableVersionCode, 12);
      expect(dto.updatePriority, 5);
    });

    test('sin actualización el DTO lo refleja', () async {
      messenger.setMockMethodCallHandler(channel, (final call) async => playResult(updateAvailability: 1));

      final dto = await PlayInAppUpdateApi.checkForUpdate();

      expect(dto.updateAvailable, isFalse);
      expect(dto.availableVersionCode, isNull);
    });

    test('un error de Play (app no instalada desde Play) se propaga', () {
      messenger.setMockMethodCallHandler(channel, (final call) async => throw PlatformException(code: 'ERROR_APP_NOT_OWNED'));
      expect(PlayInAppUpdateApi.checkForUpdate(), throwsA(isA<PlatformException>()));
    });
  });

  group('UnsupportedPlatformAppUpdateRepository', () {
    test('lanza siempre', () {
      expect(const UnsupportedPlatformAppUpdateRepository().fetchManifest(), throwsUnsupportedError);
    });
  });
}
