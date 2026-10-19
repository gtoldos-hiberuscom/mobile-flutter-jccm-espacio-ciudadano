import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';

/// Petición que llega al backend demo, ya normalizada por el adapter.
final class DemoRequest {
  const DemoRequest({
    required this.method,
    required this.uri,
    this.jsonBody,
    this.pathMatch,
  });

  /// Método HTTP en mayúsculas.
  final String method;

  /// URI completa de la petición. Las rutas se casan contra [Uri.path].
  final Uri uri;

  /// Cuerpo JSON ya decodificado, o `null` si no lo había o era multipart.
  final Object? jsonBody;

  /// Coincidencia de la ruta que atendió la petición; la rellena el enrutador.
  final RegExpMatch? pathMatch;

  String get path => uri.path;

  Map<String, String> get query => uri.queryParameters;

  /// Grupo [index] del patrón de la ruta (`1` es el primero).
  String? group(final int index) => pathMatch?.group(index);

  /// El cuerpo como objeto JSON, o un mapa vacío si no lo es.
  Map<String, Object?> get jsonObject {
    final body = jsonBody;
    if (body is Map<String, Object?>) {
      return body;
    }
    if (body is Map<Object?, Object?>) {
      return <String, Object?>{
        for (final entry in body.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return const <String, Object?>{};
  }

  DemoRequest withMatch(final RegExpMatch match) => DemoRequest(method: method, uri: uri, jsonBody: jsonBody, pathMatch: match);
}

/// Respuesta del backend demo: un sobre JSON o un fichero binario.
final class DemoResponse {
  const DemoResponse._({
    required this.statusCode,
    required this.contentType,
    this.json,
    this.bytes,
    this.fileName,
  });

  /// Sobre `{body, timestamp, mensaje-respuesta, codigo-respuesta, info-error}`
  /// con [body] dentro y estado 200.
  factory DemoResponse.ok(final Object? body, {final DateTime? now}) => DemoResponse.envelope(demoEnvelope(body, now: now));

  /// Un sobre ya construido, para fixtures que lo traen entero.
  factory DemoResponse.envelope(final Map<String, Object?> envelope, {final int statusCode = 200}) => DemoResponse._(statusCode: statusCode, contentType: Headers.jsonContentType, json: envelope);

  /// Sobre de error sin `body`, con el código HTTP también en `codigo-respuesta`.
  factory DemoResponse.status(final int statusCode, {final String? message, final DateTime? now}) => DemoResponse.envelope(demoEnvelope(null, statusCode: statusCode, message: message, now: now), statusCode: statusCode);

  factory DemoResponse.notFound({final DateTime? now}) => DemoResponse.status(404, message: 'No encontrado', now: now);

  /// Fichero binario (PDF, imagen, pkpass…). [fileName] viaja en
  /// `content-disposition`, que es de donde los repositorios sacan el nombre.
  factory DemoResponse.bytes(final Uint8List bytes, {required final String contentType, final String? fileName}) => DemoResponse._(statusCode: 200, contentType: contentType, bytes: bytes, fileName: fileName);

  final int statusCode;
  final String contentType;
  final Map<String, Object?>? json;
  final Uint8List? bytes;
  final String? fileName;
}

/// Sobre de respuesta de la fachada, con los mismos campos y literales que
/// devuelve el gateway real.
Map<String, Object?> demoEnvelope(
  final Object? body, {
  final int statusCode = 200,
  final String? message,
  final DateTime? now,
}) => <String, Object?>{
  'body': body,
  'timestamp': (now ?? DateTime.now()).toIso8601String(),
  'mensaje-respuesta': message ?? (statusCode == 200 ? 'Respuesta correcta' : 'Error'),
  'codigo-respuesta': '$statusCode.00',
  'info-error': null,
};

typedef DemoHandler = DemoResponse Function(DemoRequest request);

/// Una ruta del backend demo: método + patrón de ruta (anclado a la ruta
/// entera) + manejador. El segmento `{id}` de las URLs se escribe `([^/]+)`.
final class DemoRoute {
  DemoRoute(this.method, final String pathPattern, this.handler) : path = RegExp('^$pathPattern\$');

  final String method;
  final RegExp path;
  final DemoHandler handler;

  RegExpMatch? match(final DemoRequest request) => request.method == method ? path.firstMatch(request.path) : null;
}

/// Despacha cada petición a la primera ruta que case; sin ruta responde 404 y
/// deja traza, para que un endpoint olvidado se vea en el log en vez de
/// colgar la pantalla.
final class DemoRouter {
  const DemoRouter(this._routes);

  final List<DemoRoute> _routes;

  List<DemoRoute> get routes => List<DemoRoute>.unmodifiable(_routes);

  DemoResponse handle(final DemoRequest request) {
    for (final route in _routes) {
      final match = route.match(request);
      if (match != null) {
        return route.handler(request.withMatch(match));
      }
    }
    logger.w('[demo] sin ruta para ${request.method} ${request.path}');
    return DemoResponse.notFound();
  }
}
