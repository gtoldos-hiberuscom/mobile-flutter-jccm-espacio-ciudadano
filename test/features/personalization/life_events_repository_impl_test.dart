import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_impl.dart';

void main() {
  group('LifeEventsRepositoryImpl', () {
    test('saveLifeEvents persists user preferences in backend', () async {
      final adapter = _CapturingAdapter();
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://example.test',
          headers: const {
            Headers.contentTypeHeader: Headers.jsonContentType,
          },
        ),
      )..httpClientAdapter = adapter;
      final repository = LifeEventsRepositoryImpl(dio: dio);

      await repository.saveLifeEvents(
        idAgente: 'agent-123',
        events: const [
          LifeEvent(id: 1, label: 'Familia', selected: true),
          LifeEvent(id: 2, label: 'Empleo', selected: false),
        ],
      );

      expect(adapter.method, 'PATCH');
      expect(adapter.path, '/api/v1/hechos-vitales/hechos');
      expect(
        adapter.jsonBody,
        <String, dynamic>{
          'idAgente': 'agent-123',
          'listaHechos': [
            {
              'idHecho': 1,
              'nombreHecho': 'Familia',
              'seleccionado': true,
            },
            {
              'idHecho': 2,
              'nombreHecho': 'Empleo',
              'seleccionado': false,
            },
          ],
        },
      );
    });
  });
}

final class _CapturingAdapter implements HttpClientAdapter {
  String? method;
  String? path;
  Map<String, dynamic>? jsonBody;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    method = options.method;
    path = options.path;

    final bodyBytes = <int>[];
    await for (final chunk in requestStream ?? const Stream<Uint8List>.empty()) {
      chunk.forEach(bodyBytes.add);
    }
    jsonBody = jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;

    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{
        'codigo-respuesta': '200',
        'mensaje-respuesta': 'ok',
        'body': <String, dynamic>{},
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
