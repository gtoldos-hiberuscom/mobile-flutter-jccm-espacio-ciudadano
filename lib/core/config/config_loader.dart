import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/build_environment.dart';

T getConfigValue<T>(
  final Map<String, dynamic> json,
  final String key,
  final T Function(Object) parser,
) {
  final value = json[key];
  if (value == null) {
    throw Exception('Missing required config: $key');
  }
  try {
    return parser(value as Object);
  } catch (e) {
    throw Exception('Invalid config for $key: $value');
  }
}

Future<AppConfig> loadConfig({final String? flavor}) async {
  final targetFlavor = flavor ?? 'development';
  final configFile = 'config_$targetFlavor.json';

  final raw = await rootBundle.loadString(configFile);
  final json = jsonDecode(raw) as Map<String, dynamic>;

  final appFlavor = getConfigValue(json, 'APP_FLAVOR', (final v) => v as String);
  final environment = _flavorToEnvironment(appFlavor);

  return AppConfig(
    environment: environment,
    baseUrl: getConfigValue(json, 'BASE_URL', (final v) => v as String),
    appName: _getAppName(appFlavor),
    timeout: getConfigValue(json, 'TIMEOUT', (final v) => int.parse(v as String)),
    debugMode: getConfigValue(json, 'DEBUG_MODE', (final v) => (v as String) == 'true'),
    ssoClientId: getConfigValue(json, 'SSO_CLIENT_ID', (final v) => v as String),
    ssoRedirectUri: getConfigValue(json, 'SSO_REDIRECT_URI', (final v) => v as String),
    ssoRealm: getConfigValue(json, 'SSO_REALM', (final v) => v as String),
    ssoBaseUrl: getConfigValue(json, 'SSO_BASE_URL', (final v) => v as String),
  );
}

BuildEnvironment _flavorToEnvironment(final String flavor) {
  return switch (flavor) {
    'development' => BuildEnvironment.development,
    'preproduction' => BuildEnvironment.preproduction,
    'production' => BuildEnvironment.production,
    _ => throw Exception('Unknown flavor: $flavor'),
  };
}

String _getAppName(final String flavor) {
  return switch (flavor) {
    'development' => 'Espacio Ciudadano (Dev)',
    'preproduction' => 'Espacio Ciudadano (Pre)',
    'production' => 'Espacio Ciudadano',
    _ => 'Espacio Ciudadano',
  };
}
