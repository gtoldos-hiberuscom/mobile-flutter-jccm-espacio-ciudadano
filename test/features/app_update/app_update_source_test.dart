import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_repository_providers.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_source.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

import 'support/app_update_fakes.dart';

void main() {
  group('AppUpdateSource.fromName', () {
    test('resuelve cada valor de configuración', () {
      expect(AppUpdateSource.fromName('store'), AppUpdateSource.store);
      expect(AppUpdateSource.fromName('mock-forced'), AppUpdateSource.mockForced);
      expect(AppUpdateSource.fromName('mock-recommended'), AppUpdateSource.mockRecommended);
      expect(AppUpdateSource.fromName('mock-none'), AppUpdateSource.mockNone);
    });

    test('un valor desconocido cae en la tienda, nunca en un mock', () {
      expect(AppUpdateSource.fromName('typo'), AppUpdateSource.store);
      expect(AppUpdateSource.fromName(''), AppUpdateSource.store);
    });

    test('la tienda y los mocks guardan la versión ignorada en espacios distintos', () {
      expect(AppUpdateSource.store.storageNamespace, 'store');
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
    final installed = FakeInstalledVersionRepository(const AppVersion(0, 1, 8));

    test('un mock gana a cualquier plataforma', () {
      expect(buildAppUpdateRepository(source: AppUpdateSource.mockForced, platform: StorePlatform.android, installed: installed), isA<StaticAppUpdateRepositoryImpl>());
      expect(buildAppUpdateRepository(source: AppUpdateSource.mockNone, platform: null, installed: installed), isA<StaticAppUpdateRepositoryImpl>());
    });

    test('la tienda elige el transporte por plataforma', () {
      expect(buildAppUpdateRepository(source: AppUpdateSource.store, platform: StorePlatform.ios, installed: installed), isA<ItunesAppUpdateRepositoryImpl>());
      expect(buildAppUpdateRepository(source: AppUpdateSource.store, platform: StorePlatform.android, installed: installed), isA<PlayAppUpdateRepositoryImpl>());
    });

    test('sin tienda, la comprobación falla y no bloquea', () {
      final repo = buildAppUpdateRepository(source: AppUpdateSource.store, platform: null, installed: installed);
      expect(repo, isA<UnsupportedPlatformAppUpdateRepository>());
      expect(repo.fetchManifest(), throwsUnsupportedError);
    });
  });
}
