import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/bootstrap/app_initializer.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/app/shell/app.dart';

/// Entry-point for all environment-specific `main` functions.
///
/// Ensures Flutter bindings are initialised, runs async pre-launch
/// initialisation, then mounts a `ProviderScope`-wrapped `App`.
Future<void> bootstrap(final AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.initialize(config);

  runApp(
    ProviderScope(
      child: App(config: config),
    ),
  );
}
