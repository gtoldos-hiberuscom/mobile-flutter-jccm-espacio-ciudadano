import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_health_repository_impl.dart';

void main() {
  group('MyDataHealthRepositoryImpl', () {
    test('loads CIP and pending appointments from SESCAM endpoints', () async {
      final adapter = _MyDataHealthAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHealthRepositoryImpl(dio: dio);

      final cip = await repository.loadCip(documentNumber: '12345678A');
      final appointments = await repository.loadAppointments(
        documentNumber: '12345678A',
        filter: HealthAppointmentFilter.pending,
      );

      expect(cip, 'BBBB12345678');
      expect(adapter.paths, [
        '/api/v1/sescam/cip/12345678A',
        '/api/v1/sescam/citas/12345678A',
      ]);
      expect(appointments, hasLength(2));
      expect(appointments[0].dateTime, DateTime(2026, 7, 1, 10, 30));
      expect(appointments[0].professional, 'Dra. Maria Sanchez');
      expect(appointments[0].description, 'Consulta Medicina de Familia');
      expect(appointments[0].modality, 'Presencial');
      expect(appointments[0].center, 'Centro de salud');
    });

    test('loads past appointments sorted newest first', () async {
      final adapter = _MyDataHealthAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHealthRepositoryImpl(dio: dio);

      final appointments = await repository.loadAppointments(
        documentNumber: '12345678A',
        filter: HealthAppointmentFilter.past,
      );

      expect(adapter.paths, ['/api/v1/sescam/citas-pasadas/12345678A']);
      expect(appointments.map((final appointment) => appointment.dateTime), [
        DateTime(2026, 5, 3, 12),
        DateTime(2026, 4, 2, 9),
      ]);
    });

    test('returns empty values for missing health data', () async {
      final adapter = _MyDataHealthAdapter(returnNotFound: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHealthRepositoryImpl(dio: dio);

      final cip = await repository.loadCip(documentNumber: '00000000T');
      final appointments = await repository.loadAppointments(
        documentNumber: '00000000T',
        filter: HealthAppointmentFilter.pending,
      );

      expect(cip, isNull);
      expect(appointments, isEmpty);
    });
  });
}

final class _MyDataHealthAdapter implements HttpClientAdapter {
  _MyDataHealthAdapter({this.returnNotFound = false});

  final bool returnNotFound;
  final List<String> paths = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    paths.add(options.path);
    if (returnNotFound) {
      return ResponseBody.fromString('', 404);
    }

    if (options.path.startsWith('/api/v1/sescam/cip/')) {
      return _jsonResponse({
        'body': {'cip': 'BBBB12345678'},
      });
    }

    if (options.path.startsWith('/api/v1/sescam/citas-pasadas/')) {
      return _jsonResponse({
        'body': {
          'listaCitas': [
            {
              'fecha': '02/04/2026',
              'hora': '09:00',
              'nomTvisita': 'Consulta enfermeria',
            },
            {
              'fecha': '03/05/2026',
              'hora': '12:00',
              'nomTvisita': 'Consulta Medicina de Familia',
            },
          ],
        },
      });
    }

    return _jsonResponse({
      'body': {
        'centro': 'Centro de salud',
        'listaCitas': [
          {
            'fecha': '01/07/2026',
            'hora': '10:30',
            'nomProfesionalRealizador': 'Dra. Maria Sanchez',
            'nomTvisita': 'Consulta Medicina de Familia',
            'nomModoVisita': 'Presencial',
          },
          {
            'fecha': '02/07/2026',
            'hora': '08:15',
            'nomTvisita': 'Analitica',
          },
        ],
      },
    });
  }

  ResponseBody _jsonResponse(final Map<String, Object?> payload) {
    return ResponseBody.fromString(
      jsonEncode(payload),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
