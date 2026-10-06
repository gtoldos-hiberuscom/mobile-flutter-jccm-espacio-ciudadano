import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

/// Escenario del transporte mock: `forced` | `recommended` | `none` (por
/// defecto, para que una build sin la clave no bloquee a nadie).
///
/// Se fija en los `config_*.json` (`APP_UPDATE_MOCK`) o con
/// `--dart-define=APP_UPDATE_MOCK=forced`. Desaparece con el transporte real.
const String _mockScenario = String.fromEnvironment('APP_UPDATE_MOCK', defaultValue: 'none');

/// Tienda de la plataforma en la que corre la app; `null` donde no hay
/// tienda (tests en escritorio).
StorePlatform? storePlatformOf(final TargetPlatform platform) => switch (platform) {
  TargetPlatform.android => StorePlatform.android,
  TargetPlatform.iOS => StorePlatform.ios,
  _ => null,
};

final appUpdateStorePlatformProvider = Provider<StorePlatform?>((final ref) => storePlatformOf(defaultTargetPlatform));

/// Punto único de sustitución cuando se decida el transporte real: cambiar
/// `StaticAppUpdateRepositoryImpl` por la implementación definitiva.
final appUpdateRepositoryProvider = Provider<AppUpdateRepository>(
  (final ref) => StaticAppUpdateRepositoryImpl(
    manifestJson: AppUpdateMockScenario.fromName(_mockScenario).manifestJson,
    platformKey: (ref.watch(appUpdateStorePlatformProvider) ?? StorePlatform.ios).name,
  ),
);

final installedVersionRepositoryProvider = Provider<InstalledVersionRepository>(
  (final ref) => PackageInfoInstalledVersionRepository(platform: ref.watch(appUpdateStorePlatformProvider)),
);

final appUpdatePreferencesRepositoryProvider = Provider<AppUpdatePreferencesRepository>(
  (final ref) => AppUpdatePreferencesRepositoryImpl(ref.watch(appStorageProvider)),
);

final appStoreLauncherProvider = Provider<AppStoreLauncher>(
  (final ref) => const UrlLauncherAppStoreLauncher(),
);
