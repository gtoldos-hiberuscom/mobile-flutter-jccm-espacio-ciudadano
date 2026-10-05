import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';

const String _androidStore = 'https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano';

// TODO(JCCMEC-63): id numérico de App Store Connect pendiente del cliente.
const String _iosStore = 'https://apps.apple.com/es/app/id0000000000';

const String _noneJson =
    '''
{
  "android": { "latestVersion": "0.0.1", "minVersion": "0.0.1", "policy": "none", "storeUrl": "$_androidStore" },
  "ios":     { "latestVersion": "0.0.1", "minVersion": "0.0.1", "policy": "none", "storeUrl": "$_iosStore" }
}
''';

const String _recommendedJson =
    '''
{
  "android": { "latestVersion": "99.0.0", "minVersion": "0.0.1", "policy": "recommended", "storeUrl": "$_androidStore" },
  "ios":     { "latestVersion": "99.0.0", "minVersion": "0.0.1", "policy": "recommended", "storeUrl": "$_iosStore" }
}
''';

const String _forcedJson =
    '''
{
  "android": { "latestVersion": "99.0.0", "minVersion": "99.0.0", "policy": "none", "storeUrl": "$_androidStore" },
  "ios":     { "latestVersion": "99.0.0", "minVersion": "99.0.0", "policy": "none", "storeUrl": "$_iosStore" }
}
''';

/// Escenarios del transporte mock, cada uno con su manifiesto.
///
/// Siguen el contrato acordado con el cliente (`latestVersion`, `minVersion`,
/// `policy`, `storeUrl` por plataforma) y usan versiones extremas para que el
/// escenario no dependa de la versión instalada (`0.0.1` siempre es anterior,
/// `99.0.0` siempre posterior).
///
/// Desaparecen cuando llegue el transporte real.
enum AppUpdateMockScenario {
  /// Nada que notificar: la app instalada ya es la última.
  none(_noneJson),

  /// Hay una versión más nueva y se recomienda, sin obligar.
  recommended(_recommendedJson),

  /// La instalada está por debajo de la mínima soportada: actualización forzada.
  forced(_forcedJson);

  const AppUpdateMockScenario(this.manifestJson);

  /// Manifiesto JSON del escenario, con el contrato real.
  final String manifestJson;

  /// Escenario por nombre (`forced` | `recommended` | `none`). Un nombre
  /// desconocido cae en [none] para no bloquear a nadie por una errata.
  static AppUpdateMockScenario fromName(final String name) {
    for (final scenario in values) {
      if (scenario.name == name) {
        return scenario;
      }
    }
    logger.w('[app_update] escenario mock desconocido "$name"; se usa "none"');
    return none;
  }
}
