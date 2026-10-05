import 'dart:convert';

/// Manifiesto remoto tal cual llega: un objeto con una entrada por plataforma.
///
/// Solo valida la forma (objetos y strings presentes); el significado (versión
/// parseable, política conocida, URL de tienda aceptable) lo valida el mapper.
/// No sale de `3_data/`.
final class AppUpdateManifestDto {
  const AppUpdateManifestDto({required this.android, required this.ios});

  factory AppUpdateManifestDto.fromJson(final Map<String, Object?> json) => AppUpdateManifestDto(
    android: _platform(json, 'android'),
    ios: _platform(json, 'ios'),
  );

  /// Decodifica el documento JSON completo. Lanza [FormatException] si no es
  /// JSON válido o la raíz no es un objeto.
  factory AppUpdateManifestDto.fromJsonString(final String source) {
    final Object? decoded = jsonDecode(source);
    if (decoded is! Map<Object?, Object?>) {
      throw const FormatException('Update manifest must be a JSON object');
    }
    return AppUpdateManifestDto.fromJson(decoded.cast<String, Object?>());
  }

  final AppUpdatePlatformDto? android;
  final AppUpdatePlatformDto? ios;

  /// Entrada de la plataforma [platformKey] (`android` | `ios`), si viene.
  AppUpdatePlatformDto? forPlatform(final String platformKey) => switch (platformKey) {
    'android' => android,
    'ios' => ios,
    _ => null,
  };

  static AppUpdatePlatformDto? _platform(final Map<String, Object?> json, final String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is! Map<Object?, Object?>) {
      throw FormatException('Field "$key" must be an object');
    }
    return AppUpdatePlatformDto.fromJson(value.cast<String, Object?>());
  }
}

/// Entrada de una plataforma dentro del manifiesto.
final class AppUpdatePlatformDto {
  const AppUpdatePlatformDto({
    required this.latestVersion,
    required this.minVersion,
    required this.policy,
    required this.storeUrl,
  });

  factory AppUpdatePlatformDto.fromJson(final Map<String, Object?> json) => AppUpdatePlatformDto(
    latestVersion: _requireString(json, 'latestVersion'),
    minVersion: _requireString(json, 'minVersion'),
    policy: _requireString(json, 'policy'),
    storeUrl: _requireString(json, 'storeUrl'),
  );

  final String latestVersion;
  final String minVersion;
  final String policy;
  final String storeUrl;

  static String _requireString(final Map<String, Object?> json, final String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    throw FormatException('Missing or invalid field "$key"');
  }
}
