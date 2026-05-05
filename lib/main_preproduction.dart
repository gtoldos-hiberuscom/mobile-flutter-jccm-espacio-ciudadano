import 'package:flutter/widgets.dart';
import 'package:jccm_espacio_ciudadano/core/bootstrap/bootstrap.dart';
import 'package:jccm_espacio_ciudadano/core/config/config_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await loadConfig(flavor: 'preproduction');
  await bootstrap(config);
}
