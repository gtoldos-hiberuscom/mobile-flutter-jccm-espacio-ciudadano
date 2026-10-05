import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
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

String _platformKey() => defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

/// Punto único de sustitución cuando se decida el transporte real: cambiar
/// `StaticAppUpdateRepositoryImpl` por la implementación definitiva.
final appUpdateRepositoryProvider = Provider<AppUpdateRepository>(
  (final ref) => StaticAppUpdateRepositoryImpl(
    manifestJson: AppUpdateMockScenario.fromName(_mockScenario).manifestJson,
    platformKey: _platformKey(),
  ),
);

final installedVersionRepositoryProvider = Provider<InstalledVersionRepository>(
  (final ref) => PackageInfoInstalledVersionRepository(),
);

final appUpdatePreferencesRepositoryProvider = Provider<AppUpdatePreferencesRepository>(
  (final ref) => AppUpdatePreferencesRepositoryImpl(ref.watch(appStorageProvider)),
);

final appStoreLauncherProvider = Provider<AppStoreLauncher>(
  (final ref) => const UrlLauncherAppStoreLauncher(),
);
