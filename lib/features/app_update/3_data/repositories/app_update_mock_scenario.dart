const String _noneJson = '{"body": {"accion": "NINGUNA", "versionPublicada": null, "mensaje": null}, "codigo-respuesta": "200"}';

const String _recommendedJson = '{"body": {"accion": "RECOMENDADA", "versionPublicada": "99.0.0", "mensaje": null}, "codigo-respuesta": "200"}';

const String _forcedJson = '{"body": {"accion": "FORZADA", "versionPublicada": "99.0.0", "mensaje": null}, "codigo-respuesta": "200"}';

/// Escenarios del transporte mock, cada uno con la respuesta del servidor de
/// versiones según el contrato (`documentation/api/app-version-api.yaml`).
///
/// Usan la `99.0.0` para que el escenario no dependa de la versión instalada.
enum AppUpdateMockScenario {
  /// Nada que notificar.
  none(_noneJson),

  /// Hay una versión más nueva y se recomienda, sin obligar.
  recommended(_recommendedJson),

  /// Actualización forzada.
  forced(_forcedJson);

  const AppUpdateMockScenario(this.responseJson);

  /// Respuesta JSON del escenario, con el contrato real.
  final String responseJson;
}
