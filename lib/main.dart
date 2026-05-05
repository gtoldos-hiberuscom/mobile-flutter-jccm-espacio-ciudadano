import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:jccm_espacio_ciudadano/core/bootstrap/bootstrap.dart';
import 'package:jccm_espacio_ciudadano/core/config/config_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = Platform.environment['FLUTTER_FLAVOR'] ?? 'development';
  final config = await loadConfig(flavor: flavor);

  await bootstrap(config);
}
