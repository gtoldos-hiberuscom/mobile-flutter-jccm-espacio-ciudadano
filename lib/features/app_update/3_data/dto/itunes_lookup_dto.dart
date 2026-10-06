import 'dart:convert';

/// Respuesta de la búsqueda de iTunes tal cual llega: `resultCount` y la lista
/// `results`, de la que solo se leen los campos que necesita el aviso.
///
/// Valida la forma (tipos y presencia); el significado lo valida el mapper.
/// No sale de `3_data/`.
final class ItunesLookupDto {
  const ItunesLookupDto({required this.resultCount, required this.results});

  factory ItunesLookupDto.fromJson(final Map<String, Object?> json) {
    final count = json['resultCount'];
    if (count is! int) {
      throw const FormatException('Missing or invalid field "resultCount"');
    }
    final rawResults = json['results'];
    if (rawResults is! List<Object?>) {
      throw const FormatException('Missing or invalid field "results"');
    }
    final results = <ItunesResultDto>[];
    for (final item in rawResults) {
      if (item is! Map<Object?, Object?>) {
        throw const FormatException('Each lookup result must be an object');
      }
      results.add(ItunesResultDto.fromJson(item.cast<String, Object?>()));
    }
    return ItunesLookupDto(resultCount: count, results: results);
  }

  /// Decodifica el cuerpo completo. Lanza [FormatException] si no es JSON
  /// válido o la raíz no es un objeto.
  factory ItunesLookupDto.fromJsonString(final String source) {
    final Object? decoded = jsonDecode(source);
    if (decoded is! Map<Object?, Object?>) {
      throw const FormatException('App Store lookup response must be a JSON object');
    }
    return ItunesLookupDto.fromJson(decoded.cast<String, Object?>());
  }

  final int resultCount;
  final List<ItunesResultDto> results;
}

/// Una app dentro de `results`. A propósito no se leen `description` ni
/// `releaseNotes`: el aviso no los necesita.
final class ItunesResultDto {
  const ItunesResultDto({required this.version, required this.trackViewUrl, this.bundleId});

  factory ItunesResultDto.fromJson(final Map<String, Object?> json) {
    final bundleId = json['bundleId'];
    return ItunesResultDto(
      version: _requireString(json, 'version'),
      trackViewUrl: _requireString(json, 'trackViewUrl'),
      bundleId: bundleId is String ? bundleId : null,
    );
  }

  /// Versión de marketing publicada (`x.y.z`).
  final String version;

  /// URL de la ficha en App Store.
  final String trackViewUrl;

  /// Bundle id de la app devuelta, si viene; sirve para comprobar que iTunes
  /// ha contestado por la app pedida.
  final String? bundleId;

  static String _requireString(final Map<String, Object?> json, final String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    throw FormatException('Missing or invalid field "$key"');
  }
}
