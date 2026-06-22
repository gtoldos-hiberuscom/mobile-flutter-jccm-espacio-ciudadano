import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_impl.dart';

void main() {
  group('AgendaRepositoryImpl', () {
    test('loads health and general appointments', () async {
      final adapter = _AgendaAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final appointments = await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      );

      expect(
        adapter.paths,
        isNot(contains('/api/v1/sescam/citas-pasadas/12345678A')),
      );
      expect(adapter.paths, [
        '/api/v1/sescam/citas/12345678A',
        '/api/v1/agenda/agent-1/eventos/todos',
      ]);
      expect(appointments, hasLength(2));
      expect(appointments[0].description, 'Trámite administrativo');
      expect(appointments[1].description, 'Consulta Medicina de Familia');
    });
  });
}

final class _AgendaAdapter implements HttpClientAdapter {
  final List<String> paths = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    paths.add(options.path);
    if (options.path.startsWith('/api/v1/agenda/')) {
      return ResponseBody.fromString(
        jsonEncode(
          {
            'body': [
              {
                'fecha': '01/06/2026',
                'hora': '09:15',
                'titulo': 'Registro',
                'tipoEvento': 'Trámite administrativo',
                'ubicacion': 'Oficina de atención',
              },
            ],
          },
        ),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return ResponseBody.fromString(
      jsonEncode(
        {
          'body': {
            'listaCitas': [
              {
                'fecha': '01/07/2026',
                'hora': '10:30',
                'nomTvisita': 'Consulta Medicina de Familia',
                'centro': 'Centro de salud',
              },
            ],
          },
        },
      ),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
