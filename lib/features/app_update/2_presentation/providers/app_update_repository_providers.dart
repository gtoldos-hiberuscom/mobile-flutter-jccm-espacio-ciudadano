import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_source.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

/// `api` por defecto: una build sin la clave pregunta al servidor, nunca a un
/// mock. Precedente de clave leída fuera de `AppConfig`: `LOG_REDACTION_OFF`.
const String _sourceName = String.fromEnvironment('APP_UPDATE_SOURCE', defaultValue: 'api');

final appUpdateSourceProvider = Provider<AppUpdateSource>((final ref) => AppUpdateSource.fromName(_sourceName));

/// Plataforma con tienda en la que corre la app; `null` donde no hay tienda
/// (tests en escritorio).
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
  required final AppVersionApi Function() api,
}) => switch ((source.mockScenario, platform)) {
  (final AppUpdateMockScenario mock, _) => MockAppUpdateRepositoryImpl(mock),
  (null, final StorePlatform platform) => ApiAppUpdateRepositoryImpl(api: api(), platform: platform),
  (null, null) => const UnsupportedPlatformAppUpdateRepository(),
};

final appUpdateRepositoryProvider = Provider<AppUpdateRepository>(
  (final ref) => buildAppUpdateRepository(
    source: ref.watch(appUpdateSourceProvider),
    platform: ref.watch(appUpdateStorePlatformProvider),
    // El servidor de versiones cuelga del mismo host que el resto de APIs.
    api: () => AppVersionApi.standalone(config: ref.read(appConfigProvider)),
  ),
);

final installedVersionRepositoryProvider = Provider<InstalledVersionRepository>(
  (final ref) => PackageInfoInstalledVersionRepository(),
);

final appUpdatePreferencesRepositoryProvider = Provider<AppUpdatePreferencesRepository>(
  (final ref) => AppUpdatePreferencesRepositoryImpl(
    ref.watch(appStorageProvider),
    namespace: ref.watch(appUpdateSourceProvider).storageNamespace,
  ),
);

final appStoreLauncherProvider = Provider<AppStoreLauncher>(
  (final ref) => UrlLauncherAppStoreLauncher(
    platform: ref.watch(appUpdateStorePlatformProvider),
    installed: ref.watch(installedVersionRepositoryProvider),
    appStoreId: ref.watch(appConfigProvider).appStoreId,
  ),
);
