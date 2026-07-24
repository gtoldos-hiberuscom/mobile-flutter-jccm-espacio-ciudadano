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

    test('saveLifeEvents maps support unavailable response to domain exception', () async {
      final adapter = _CapturingAdapter(responseKind: _LifeEventsResponseKind.supportUnavailable);
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://example.test',
          headers: const {
            Headers.contentTypeHeader: Headers.jsonContentType,
          },
        ),
      )..httpClientAdapter = adapter;
      final repository = LifeEventsRepositoryImpl(dio: dio);

      expect(
        () => repository.saveLifeEvents(
          idAgente: 'agent-123',
          events: const [
            LifeEvent(id: 1, label: 'Familia', selected: true),
          ],
        ),
        throwsA(isA<LifeEventsSupportUnavailableException>()),
      );
    });

    test('resetPreferences deletes all life events for the agent', () async {
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

      await repository.resetPreferences(idAgente: 'agent-123');

      expect(adapter.method, 'DELETE');
      expect(
        adapter.path,
        '/api/v1/hechos-vitales/preferencias/agent-123',
      );
    });
  });
}

enum _LifeEventsResponseKind {
  success,
  supportUnavailable,
}

final class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter({this.responseKind = _LifeEventsResponseKind.success});

  final _LifeEventsResponseKind responseKind;
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
    if (bodyBytes.isNotEmpty) {
      jsonBody = jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
    }

    return ResponseBody.fromString(
      jsonEncode(_payload()),
      _statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}

  int get _statusCode {
    return switch (responseKind) {
      _LifeEventsResponseKind.success => 200,
      _LifeEventsResponseKind.supportUnavailable => 403,
    };
  }

  Map<String, dynamic> _payload() {
    return switch (responseKind) {
      _LifeEventsResponseKind.success => <String, dynamic>{
        'codigo-respuesta': '200',
        'mensaje-respuesta': 'ok',
        'body': <String, dynamic>{},
      },
      _LifeEventsResponseKind.supportUnavailable => <String, dynamic>{
        'body': null,
        'mensaje-respuesta': 'No se pudo dar de alta el soporte.',
        'codigo-respuesta': '412.00',
        'info-error': <String, dynamic>{
          'errores': [
            {
              'codigo-error': 3034,
              'mensaje-error': 'Cuando autorizas a que Espacio Ciudadano muestre los datos que las Administraciones Públicas tienen sobre ti te mostramos esta información para tu consulta.',
            },
          ],
        },
      },
    };
  }
}
