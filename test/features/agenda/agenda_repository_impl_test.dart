import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_impl.dart';

void main() {
  group('AgendaRepositoryImpl', () {
    test('loads health and general appointments', () async {
      final adapter = _AgendaAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final appointments = (await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      )).appointments;

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

      final appointments = (await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      )).appointments;

      final duplicated = appointments.where((final appointment) => appointment.dateTime == DateTime(2026, 6, 15, 9));
      expect(duplicated, hasLength(1));
      // Gana la de SESCAM: trae profesional y modo en campos propios en vez de
      // dentro del mensaje del evento.
      expect(duplicated.single.title, 'LAGUNA RUIDERA MONTESINOS');
      expect(duplicated.single.description, 'DEMANDA');
      expect(appointments, hasLength(4));
    });

    test('deduplica también cuando la agenda publica la cita en UTC', () async {
      // El evento llega como instante UTC y SESCAM como fecha y hora locales:
      // la igualdad exacta de DateTime (que compara también isUtc y segundos)
      // nunca casaba y la misma cita se pintaba dos veces. El caso se
      // construye desde el mismo instante para no depender del huso del runner.
      final utcInstant = DateTime.parse('2026-06-15T07:00:00Z');
      final local = utcInstant.toLocal();
      String two(final int v) => v.toString().padLeft(2, '0');

      final adapter = _AgendaAdapter(
        primaryCareAppointments: [
          {
            'fecha': '${two(local.day)}/${two(local.month)}/${local.year}',
            'hora': '${two(local.hour)}:${two(local.minute)}',
            'nomTvisita': 'DEMANDA',
            'nomProfesionalRealizador': 'LAGUNA RUIDERA MONTESINOS',
            'nomModoVisita': 'Presencial',
          },
        ],
        eventos: [
          {
            'fechaVencimiento': '2026-06-15T07:00:00Z',
            'titulo': 'Cita de Atención Primaria',
            'tipoEvento': 'CITA',
            'mensaje': '<p>Tiene una cita de atención primaria</p>',
          },
        ],
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final appointments = (await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      )).appointments;

      expect(appointments, hasLength(1), reason: 'la misma cita publicada por las dos fuentes debe listarse una vez');
      expect(appointments.single.title, 'LAGUNA RUIDERA MONTESINOS');
    });

    test('un evento con instante UTC se guarda en hora local', () async {
      final adapter = _AgendaAdapter(
        primaryCareAppointments: const [],
        eventos: [
          {
            'fechaVencimiento': '2026-06-15T07:00:00Z',
            'titulo': 'Registro',
            'tipoEvento': 'Trámite administrativo',
          },
        ],
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final appointments = (await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      )).appointments;

      // La página pinta `.hour` crudo: un DateTime en UTC mostraba la cita a
      // la hora del meridiano, no a la del ciudadano.
      expect(appointments.single.dateTime, DateTime.parse('2026-06-15T07:00:00Z').toLocal());
      expect(appointments.single.dateTime.isUtc, isFalse);
    });

    test('una notificación conserva título, asunto y unidad emisora', () async {
      final adapter = _AgendaAdapter(
        primaryCareAppointments: const [],
        eventos: const [
          {
            'fechaVencimiento': '2026-08-11T23:30:00',
            'titulo': 'Caducidad de notificación',
            'mensaje': '<p>Tiene una notificación próxima a caducar:</p> <p>Organismo emisor: UnidadOrganica 2</p> <p> Asunto: Prueba 2</p>',
            'tipo': 'EVENTO',
            'area': 'NOTIFICA',
          },
        ],
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final appointments = (await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      )).appointments;

      expect(appointments, hasLength(1));
      expect(appointments.single.title, 'Caducidad de notificación');
      expect(appointments.single.description, 'Asunto: Prueba 2');
      expect(appointments.single.detail, 'UnidadOrganica 2');
      expect(appointments.single.kind, AgendaAppointmentKind.notification);
    });

    test('refreshes events through the gateway refrescar endpoint', () async {
      final adapter = _AgendaAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      await repository.refreshEvents(agentId: 'agent-1');

      expect(adapter.paths, ['/api/v1/ciudadanos/agent-1/eventos/refrescar']);
    });

    test('a 500 whose body carries no parseable appointments propagates instead of becoming "no appointments"', () async {
      // `_StaticAdapter` responde igual a las dos rutas, así que caen todas
      // las fuentes: solo entonces el fallo se propaga en vez de degradar.
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(500, {'codigo-respuesta': '500.00', 'mensaje-respuesta': 'Error'});
      final repository = AgendaRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadAppointments(documentNumber: '12345678A', agentId: 'agent-1'),
        throwsA(isA<DioException>()),
      );
    });

    test('si SESCAM cae, la agenda se queda con los eventos y marca la fuente de salud', () async {
      // El caso real del 10/09 en PRE: primaria-citas-pendientes devuelve
      // 500.00/3031 y eventos responde bien. Antes esto tumbaba la pantalla
      // entera.
      final adapter = _AgendaAdapter(healthStatusCode: 500);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final snapshot = await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      );

      expect(snapshot.failedSources, unorderedEquals(<AgendaAppointmentSource>{AgendaAppointmentSource.health}));
      expect(snapshot.isPartial, isTrue);
      // Los 4 eventos siguen ahí: sin citas de SESCAM no hay franjas contra
      // las que deduplicar, así que las de primaria publicadas como evento
      // sobreviven.
      expect(snapshot.appointments, hasLength(4));
    });

    test('un 500/3031 de SESCAM se identifica como usuario sin CIP y no como fuente caída', () async {
      final adapter = _AgendaAdapter(
        healthStatusCode: 500,
        healthErrorCode: 3031,
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final snapshot = await repository.loadAppointments(
        documentNumber: '99999999R',
        agentId: 'agent-1',
      );

      expect(snapshot.failedSources, isEmpty);
      expect(snapshot.isPartial, isFalse);
      expect(snapshot.healthCipMissing, isTrue);
      expect(snapshot.appointments, hasLength(4));
    });

    for (final statusCode in [401, 403]) {
      test('un $statusCode de SESCAM se trata como lista vacía y no muestra aviso', () async {
        final adapter = _AgendaAdapter(healthStatusCode: statusCode);
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
        final repository = AgendaRepositoryImpl(dio: dio);

        final snapshot = await repository.loadAppointments(
          documentNumber: '12345678A',
          agentId: 'agent-1',
        );

        expect(snapshot.failedSources, isEmpty);
        expect(snapshot.isPartial, isFalse);
        expect(snapshot.appointments, hasLength(4));
      });
    }

    test('si los eventos caen, quedan las citas de SESCAM y se marca la fuente general', () async {
      final adapter = _AgendaAdapter(eventosStatusCode: 500);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final snapshot = await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      );

      expect(snapshot.failedSources, unorderedEquals(<AgendaAppointmentSource>{AgendaAppointmentSource.general}));
      expect(snapshot.appointments, hasLength(1));
      expect(snapshot.appointments.single.kind, AgendaAppointmentKind.health);
    });

    test('un 400 de eventos es "sin eventos", no una fuente caída', () async {
      // `ignoreBadRequest` ya traducía el 400 a lista vacía; lo que se fija
      // aquí es que eso NO se cuente como degradación y no salga el aviso.
      final adapter = _AgendaAdapter(eventosStatusCode: 400);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final snapshot = await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: 'agent-1',
      );

      expect(snapshot.failedSources, isEmpty);
      expect(snapshot.isPartial, isFalse);
      expect(snapshot.appointments, hasLength(1));
    });

    test('sin idAgente la agenda general ni se pide, y eso no es una fuente caída', () async {
      final adapter = _AgendaAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = AgendaRepositoryImpl(dio: dio);

      final snapshot = await repository.loadAppointments(
        documentNumber: '12345678A',
        agentId: '  ',
      );

      expect(adapter.paths, ['/api/v1/ciudadanos/12345678A/salud/primaria-citas-pendientes']);
      expect(snapshot.failedSources, isEmpty);
      expect(snapshot.appointments, hasLength(1));
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
  _AgendaAdapter({
    final List<Map<String, dynamic>>? primaryCareAppointments,
    this.eventos,
    this.healthStatusCode = 200,
    this.eventosStatusCode = 200,
    this.healthErrorCode,
  }) : _primaryCareAppointments = primaryCareAppointments ?? _defaultPrimaryCareAppointments;

  /// Eventos de la agenda general; `null` usa la lista de ejemplo del test base.
  final List<Map<String, dynamic>>? eventos;

  /// Código con el que responde cada ruta. Permite tumbar **una sola** fuente,
  /// que es justo lo que `_StaticAdapter` no puede hacer.
  final int healthStatusCode;
  final int eventosStatusCode;
  final int? healthErrorCode;

  static ResponseBody _errorBody(final int statusCode, {final int? errorCode}) => ResponseBody.fromString(
    jsonEncode({
      'codigo-respuesta': '500.00',
      'mensaje-respuesta': 'Error interno de la API',
      'body': null,
      if (errorCode != null)
        'info-error': {
          'errores': [
            {'codigo-error': errorCode, 'mensaje-error': 'Error al obtener las citas futuras'},
          ],
        },
    }),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

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
      if (eventosStatusCode != 200) {
        return _errorBody(eventosStatusCode);
      }
      return ResponseBody.fromString(
        jsonEncode(
          {
            'body': {
              'eventos':
                  eventos ??
                  [
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

    if (healthStatusCode != 200) {
      return _errorBody(healthStatusCode, errorCode: healthErrorCode);
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
