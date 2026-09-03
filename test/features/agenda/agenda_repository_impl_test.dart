import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
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
      // Ambas fuentes van por paths del gateway: los legacy /api/v1/sescam/...
      // y /api/v1/agenda/... no existen ahí y responden 404. El periodo de los
      // eventos va en mayúsculas.
      expect(adapter.paths, [
        '/api/v1/ciudadanos/12345678A/salud/primaria-citas-pendientes',
        '/api/v1/ciudadanos/agent-1/eventos/TODOS',
      ]);
      expect(appointments, hasLength(5));
      expect(appointments[0].description, 'Trámite administrativo');
      expect(appointments[0].kind, AgendaAppointmentKind.notification);
      expect(appointments[1].title, 'LAGUNA RUIDERA MONTESINOS');
      expect(appointments[1].description, 'Cita de Atención Primaria');
      expect(appointments[1].kind, AgendaAppointmentKind.health);
      expect(appointments[1].channel, 'Presencial');
      expect(appointments[1].detail, 'Consulta a demanda');
      expect(appointments[2].title, 'CAMPO CRIPTANA MOLINO');
      expect(appointments[2].kind, AgendaAppointmentKind.health);
      expect(appointments[2].channel, 'Telefónica');
      expect(appointments[2].detail, 'Teleconsulta a demanda');
      expect(appointments[3].description, 'Consulta Medicina de Familia');
      expect(appointments[3].kind, AgendaAppointmentKind.health);
      expect(appointments[4].title, 'Caducidad de carnet joven');
      expect(
        appointments[4].description,
        'El carnet joven caduca el próximo 30/01/2030',
      );
      expect(appointments[4].kind, AgendaAppointmentKind.credential);
    });

    test('a primary care appointment published by both sources is listed once', () async {
      final adapter = _AgendaAdapter(
        primaryCareAppointments: [
          {
            'fecha': '15/06/2026',
            'hora': '09:00',
            'nomTvisita': 'DEMANDA',
            'nomProfesionalRealizador': 'LAGUNA RUIDERA MONTESINOS',
            'nomModoVisita': 'Presencial',
          },
        ],
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final appointments = await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      );

      final duplicated = appointments.where((final appointment) => appointment.dateTime == DateTime(2026, 6, 15, 9));
      expect(duplicated, hasLength(1));
      // Gana la de SESCAM: trae profesional y modo en campos propios en vez de
      // dentro del mensaje del evento.
      expect(duplicated.single.title, 'LAGUNA RUIDERA MONTESINOS');
      expect(duplicated.single.description, 'DEMANDA');
      expect(appointments, hasLength(4));
    });

    test('refreshes events through the gateway refrescar endpoint', () async {
      final adapter = _AgendaAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      await repository.refreshEvents(agentId: 'agent-1');

      expect(adapter.paths, ['/api/v1/ciudadanos/agent-1/eventos/refrescar']);
    });

    test('a 500 whose body carries no parseable appointments propagates instead of becoming "no appointments"', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(500, {'codigo-respuesta': '500.00', 'mensaje-respuesta': 'Error'});
      final repository = AgendaRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadAppointments(documentNumber: '12345678A', agentId: 'agent-1'),
        throwsA(isA<DioException>()),
      );
    });
  });
}

final class _StaticAdapter implements HttpClientAdapter {
  _StaticAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object? body;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    await (requestStream ?? const Stream<Uint8List>.empty()).drain<void>();
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}

final class _AgendaAdapter implements HttpClientAdapter {
  _AgendaAdapter({final List<Map<String, dynamic>>? primaryCareAppointments}) : _primaryCareAppointments = primaryCareAppointments ?? _defaultPrimaryCareAppointments;

  static const List<Map<String, dynamic>> _defaultPrimaryCareAppointments = [
    {
      'fecha': '01/07/2026',
      'hora': '10:30',
      'nomTvisita': 'Consulta Medicina de Familia',
      'centro': 'Centro de salud',
    },
  ];

  final List<Map<String, dynamic>> _primaryCareAppointments;
  final List<String> paths = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    paths.add(options.path);
    if (options.path.contains('/eventos/refrescar')) {
      return ResponseBody.fromString(
        jsonEncode({
          'body': {'notificacionesOk': 1, 'notificacionesError': 0},
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    if (options.path.contains('/eventos/')) {
      return ResponseBody.fromString(
        jsonEncode(
          {
            'body': {
              'eventos': [
                {
                  'fechaVencimiento': '2026-06-01T09:15:00',
                  'titulo': 'Registro',
                  'tipoEvento': 'Trámite administrativo',
                  'ubicacion': 'Oficina de atención',
                },
                {
                  'fechaVencimiento': '2026-06-15T09:00:00',
                  'titulo': 'Cita de Atención Primaria',
                  'tipoEvento': 'CITA',
                  'mensaje': '<p>Tiene una cita de atención primaria el próximo 15/06/2026</p> <p>Hora:09:00</p> <p>Profesional:LAGUNA RUIDERA MONTESINOS</p> <p>Tipo de cita:DEMANDA</p> <p>Modo de cita:Presencial</p>',
                },
                {
                  'fechaVencimiento': '2026-06-16T08:25:00',
                  'titulo': 'Cita de atención primaria',
                  'tipoEvento': 'CITA',
                  'mensaje': '<p>Tiene una cita de atención primaria el próximo 16/06/2026</p> <p>Hora:08:25</p> <p>Profesional:CAMPO CRIPTANA MOLINO</p> <p>Tipo de cita:TELECONSULTA DEMANDA</p> <p>Modo de cita:Telefónica</p>',
                },
                {
                  'fechaVencimiento': '2030-01-30T00:00:00',
                  'titulo': 'Caducidad de carnet joven',
                  'tipoEvento': 'EVENTO',
                  'mensaje': '<p>El carnet joven caduca el próximo 30/01/2030</p>',
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

    return ResponseBody.fromString(
      jsonEncode(
        {
          'body': {'listaCitas': _primaryCareAppointments},
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
