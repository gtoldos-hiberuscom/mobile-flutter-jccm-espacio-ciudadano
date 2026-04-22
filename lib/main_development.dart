import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jccm_espacio_ciudadano/app/bootstrap/bootstrap.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/app/config/build_environment.dart';

Future<void> main() async {
  // Binding must be initialised before loading assets.
  WidgetsFlutterBinding.ensureInitialized();

  final raw = await rootBundle.loadString('config_development.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;

  await bootstrap(
    AppConfig(
      environment: BuildEnvironment.development,
      baseUrl: json['baseUrl'] as String? ?? '',
      appName: json['appName'] as String? ?? 'Espacio Ciudadano (Dev)',
      timeout: int.tryParse(json['TIMEOUT'] as String? ?? '30') ?? 30,
      debugMode: (json['DEBUG_MODE'] as String? ?? 'false') == 'true',
    ),
  );
}
