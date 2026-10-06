import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_source.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

/// `store` por defecto: una build sin la clave consulta la tienda, nunca un
/// mock. Precedente de clave leída fuera de `AppConfig`: `LOG_REDACTION_OFF`.
const String _sourceName = String.fromEnvironment('APP_UPDATE_SOURCE', defaultValue: 'store');

final appUpdateSourceProvider = Provider<AppUpdateSource>((final ref) => AppUpdateSource.fromName(_sourceName));

/// Tienda de la plataforma en la que corre la app; `null` donde no hay
/// tienda (tests en escritorio).
StorePlatform? storePlatformOf(final TargetPlatform platform) => switch (platform) {
  TargetPlatform.android => StorePlatform.android,
  TargetPlatform.iOS => StorePlatform.ios,
  _ => null,
};

final appUpdateStorePlatformProvider = Provider<StorePlatform?>((final ref) => storePlatformOf(defaultTargetPlatform));

/// Elige el transporte. Función pura para poder probar la selección: la clave
/// de entorno no se puede cambiar desde un test.
@visibleForTesting
AppUpdateRepository buildAppUpdateRepository({
  required final AppUpdateSource source,
  required final StorePlatform? platform,
  required final InstalledVersionRepository installed,
}) => switch ((source.mockScenario, platform)) {
  (final AppUpdateMockScenario mock, _) => StaticAppUpdateRepositoryImpl(manifestJson: mock.manifestJson, platformKey: (platform ?? StorePlatform.ios).name),
  (null, StorePlatform.ios) => ItunesAppUpdateRepositoryImpl(api: ItunesLookupApi.standalone(), installed: installed),
  (null, StorePlatform.android) => PlayAppUpdateRepositoryImpl(installed: installed),
  (null, null) => const UnsupportedPlatformAppUpdateRepository(),
};

final appUpdateRepositoryProvider = Provider<AppUpdateRepository>(
  (final ref) => buildAppUpdateRepository(
    source: ref.watch(appUpdateSourceProvider),
    platform: ref.watch(appUpdateStorePlatformProvider),
    installed: ref.watch(installedVersionRepositoryProvider),
  ),
);

final installedVersionRepositoryProvider = Provider<InstalledVersionRepository>(
  (final ref) => PackageInfoInstalledVersionRepository(platform: ref.watch(appUpdateStorePlatformProvider)),
);

final appUpdatePreferencesRepositoryProvider = Provider<AppUpdatePreferencesRepository>(
  (final ref) => AppUpdatePreferencesRepositoryImpl(
    ref.watch(appStorageProvider),
    namespace: ref.watch(appUpdateSourceProvider).storageNamespace,
  ),
);

final appStoreLauncherProvider = Provider<AppStoreLauncher>(
  (final ref) => const UrlLauncherAppStoreLauncher(),
);
