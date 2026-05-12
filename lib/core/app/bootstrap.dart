import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/app/app.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entry-point for all environment-specific `main` functions.
///
/// Ensures Flutter bindings are initialised, runs async pre-launch
/// initialisation, then mounts a `ProviderScope`-wrapped `App`.
///
/// [appConfigProvider] is overridden here so that all descendant Riverpod
/// providers (network, storage, etc.) can access typed configuration without
/// requiring a `BuildContext`.
Future<void> bootstrap(final AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final appStorage = SharedPreferencesAppStorage(sharedPreferences);

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        appStorageProvider.overrideWithValue(appStorage),
      ],
      child: const App(),
    ),
  );
}
