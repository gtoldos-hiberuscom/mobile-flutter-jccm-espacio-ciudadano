import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_repository_providers.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_source.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

void main() {
  group('AppUpdateSource.fromName', () {
    test('resuelve cada valor de configuración', () {
      expect(AppUpdateSource.fromName('api'), AppUpdateSource.api);
      expect(AppUpdateSource.fromName('mock-forced'), AppUpdateSource.mockForced);
      expect(AppUpdateSource.fromName('mock-recommended'), AppUpdateSource.mockRecommended);
      expect(AppUpdateSource.fromName('mock-none'), AppUpdateSource.mockNone);
    });

    test('un valor desconocido cae en la API, nunca en un mock', () {
      expect(AppUpdateSource.fromName('typo'), AppUpdateSource.api);
      expect(AppUpdateSource.fromName('store'), AppUpdateSource.api);
      expect(AppUpdateSource.fromName(''), AppUpdateSource.api);
    });

    test('la API y los mocks guardan la versión ignorada en espacios distintos', () {
      expect(AppUpdateSource.api.storageNamespace, 'api');
      expect(AppUpdateSource.mockForced.storageNamespace, 'mock');
      expect(AppUpdateSource.mockNone.storageNamespace, 'mock');
    });
  });

  group('storePlatformOf', () {
    test('solo Android e iOS tienen tienda', () {
      expect(storePlatformOf(TargetPlatform.android), StorePlatform.android);
      expect(storePlatformOf(TargetPlatform.iOS), StorePlatform.ios);
      expect(storePlatformOf(TargetPlatform.macOS), isNull);
      expect(storePlatformOf(TargetPlatform.linux), isNull);
    });
  });

  group('buildAppUpdateRepository', () {
    var apiBuilds = 0;
    AppVersionApi api() {
      apiBuilds++;
      return AppVersionApi.standalone(baseUrl: 'https://example.invalid');
    }

    setUp(() => apiBuilds = 0);

    test('un mock gana a cualquier plataforma y no crea el cliente', () {
      expect(buildAppUpdateRepository(source: AppUpdateSource.mockForced, platform: StorePlatform.android, api: api), isA<MockAppUpdateRepositoryImpl>());
      expect(buildAppUpdateRepository(source: AppUpdateSource.mockNone, platform: null, api: api), isA<MockAppUpdateRepositoryImpl>());
      expect(apiBuilds, 0);
    });

    test('la API se usa en Android e iOS', () {
      expect(buildAppUpdateRepository(source: AppUpdateSource.api, platform: StorePlatform.ios, api: api), isA<ApiAppUpdateRepositoryImpl>());
      expect(buildAppUpdateRepository(source: AppUpdateSource.api, platform: StorePlatform.android, api: api), isA<ApiAppUpdateRepositoryImpl>());
    });

    test('sin tienda, la comprobación falla y no bloquea', () {
      final repo = buildAppUpdateRepository(source: AppUpdateSource.api, platform: null, api: api);
      expect(repo, isA<UnsupportedPlatformAppUpdateRepository>());
      expect(repo.fetchDecision(applicationId: 'x', installedVersion: const AppVersion(1, 0, 0)), throwsUnsupportedError);
      expect(apiBuilds, 0);
    });
  });
}
