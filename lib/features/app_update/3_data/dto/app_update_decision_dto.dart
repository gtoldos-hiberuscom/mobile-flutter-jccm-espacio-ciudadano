import 'dart:convert';

/// Respuesta del servidor de versiones tal cual llega: el sobre `Respuesta`
/// con la decisión en `body`.
///
/// Solo valida la forma (objetos y tipos); el significado (acción conocida,
/// versión parseable) lo valida el mapper. No sale de `3_data/`.
final class AppUpdateDecisionDto {
  const AppUpdateDecisionDto({required this.accion, this.versionPublicada, this.mensaje});

  /// Desde el cuerpo decodificado por Dio. Lanza [FormatException] si la
  /// forma no es la del contrato.
  factory AppUpdateDecisionDto.fromResponse(final Object? data) {
    final envelope = _asObject(data, 'response');
    final body = _asObject(envelope['body'], 'body');
    return AppUpdateDecisionDto(
      accion: _requireString(body, 'accion'),
      versionPublicada: _optionalString(body, 'versionPublicada'),
      mensaje: _optionalString(body, 'mensaje'),
    );
  }

  /// Desde el documento JSON completo (escenarios mock).
  factory AppUpdateDecisionDto.fromJsonString(final String source) => AppUpdateDecisionDto.fromResponse(jsonDecode(source));

  final String accion;
  final String? versionPublicada;
  final String? mensaje;

  static Map<String, Object?> _asObject(final Object? value, final String name) {
    if (value is! Map<Object?, Object?>) {
      throw FormatException('Field "$name" must be an object');
    }
    return value.cast<String, Object?>();
  }

  static String _requireString(final Map<String, Object?> json, final String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    throw FormatException('Missing or invalid field "$key"');
  }

  static String? _optionalString(final Map<String, Object?> json, final String key) {
    final value = json[key];
    if (value == null || value is String) {
      return value as String?;
    }
    throw FormatException('Field "$key" must be a string or null');
  }
}
