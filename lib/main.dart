import 'package:flutter/widgets.dart';
import 'package:jccm_espacio_ciudadano/core/app/bootstrap.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const config = AppConfig.fromEnvironment();

  await bootstrap(config);
}
