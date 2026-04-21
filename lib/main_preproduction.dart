import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jccm_espacio_ciudadano/app/bootstrap/bootstrap.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/app/config/build_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final raw = await rootBundle.loadString('config_preproduction.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;

  await bootstrap(
    AppConfig(
      environment: BuildEnvironment.preproduction,
      baseUrl: json['baseUrl'] as String? ?? '',
      appName: json['appName'] as String? ?? 'Espacio Ciudadano (Pre)',
      timeout: int.tryParse(json['TIMEOUT'] as String? ?? '20') ?? 20,
      debugMode: (json['DEBUG_MODE'] as String? ?? 'false') == 'true',
    ),
  );
}
