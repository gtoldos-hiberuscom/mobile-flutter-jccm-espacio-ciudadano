import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';

/// Transporte del modo demostración: sustituye al `HttpClientAdapter` de Dio
/// y resuelve cada petición contra [DemoBackend], sin salir del dispositivo.
///
/// Va **debajo** de los interceptores reales a propósito: el sobre de la
/// fachada, el desempaquetado del cliente generado y los mappers trabajan
/// exactamente igual que con el gateway, así que la demo ejercita la misma
/// cadena que un ciudadano.
final class DemoHttpClientAdapter implements HttpClientAdapter {
  DemoHttpClientAdapter(this._backend, {this.latency = const Duration(milliseconds: 200)});

  final DemoBackend _backend;

  /// Pequeño retardo para que los estados de carga se vean como en la vida
  /// real. Cero en tests.
  final Duration latency;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    final bodyBytes = <int>[];
    await for (final chunk in requestStream ?? const Stream<Uint8List>.empty()) {
      chunk.forEach(bodyBytes.add);
    }

    final request = DemoRequest(
      method: options.method.toUpperCase(),
      uri: options.uri,
      jsonBody: _decodeJsonBody(options, bodyBytes),
      headers: <String, Object?>{
        for (final entry in options.headers.entries) entry.key.toLowerCase(): entry.value,
      },
    );
    final response = _backend.handle(request);

    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }

    final headers = <String, List<String>>{
      Headers.contentTypeHeader: <String>[response.contentType],
      if (response.fileName != null) 'content-disposition': <String>['attachment; filename="${response.fileName}"'],
    };
    final bytes = response.bytes;
    if (bytes != null) {
      return ResponseBody.fromBytes(bytes, response.statusCode, headers: headers);
    }
    return ResponseBody.fromString(jsonEncode(response.json), response.statusCode, headers: headers);
  }

  /// Los cuerpos multipart (formulario de soporte, adjuntos) no se decodifican:
  /// las rutas que los reciben no necesitan leerlos.
  Object? _decodeJsonBody(final RequestOptions options, final List<int> bodyBytes) {
    if (bodyBytes.isEmpty || options.data is FormData) {
      return null;
    }
    final contentType = options.contentType ?? '';
    if (contentType.contains('multipart')) {
      return null;
    }
    try {
      return jsonDecode(utf8.decode(bodyBytes));
    } on FormatException {
      return null;
    }
  }

  @override
  void close({final bool force = false}) {}
}
