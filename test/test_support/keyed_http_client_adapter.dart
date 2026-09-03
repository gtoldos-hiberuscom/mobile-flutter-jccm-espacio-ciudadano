import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'sequence_http_client_adapter.dart';

/// Adaptador que resuelve la respuesta por el valor de un query param.
///
/// El [SequenceHttpClientAdapter] devuelve las respuestas en el orden en que se
/// registraron, sin mirar la petición: sirve mientras las llamadas sean
/// secuenciales. La pestaña "Todo" de notificaciones consulta los cuatro
/// estados **en paralelo**, así que el orden de llegada no está garantizado y
/// hay que emparejar cada respuesta con su petición.
///
/// Cada clave lleva su propia cola de respuestas, de modo que un estado con
/// varias páginas se declara con varias respuestas en orden.
final class KeyedHttpClientAdapter implements HttpClientAdapter {
  KeyedHttpClientAdapter({
    required final Map<String?, List<AdapterResponse>> responses,
    final String queryParameter = 'estado',
  }) : _queryParameter = queryParameter,
       _responses = {
         for (final entry in responses.entries) entry.key: List<AdapterResponse>.of(entry.value),
       };

  final String _queryParameter;
  final Map<String?, List<AdapterResponse>> _responses;
  final requests = <CapturedRequest>[];

  /// Valores del query param con los que se llamó, en orden de llegada.
  List<String?> get requestedKeys => requests.map((final request) => request.queryParameters[_queryParameter] as String?).toList(growable: false);

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    requests.add(
      CapturedRequest(
        method: options.method,
        path: options.path,
        queryParameters: Map<String, dynamic>.from(options.queryParameters),
        jsonBody: null,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
      ),
    );

    final key = options.queryParameters[_queryParameter] as String?;
    final pending = _responses[key];
    if (pending == null || pending.isEmpty) {
      throw StateError('Sin respuesta declarada para $_queryParameter=$key');
    }
    final response = pending.removeAt(0);
    final body = response.body;
    return ResponseBody.fromString(
      body is String ? body : jsonEncode(body),
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [response.contentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
