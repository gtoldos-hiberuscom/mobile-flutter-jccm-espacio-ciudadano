import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_health_repository_impl.dart';

const _citizenId = 'sub-alt-1';

void main() {
  group('MyDataHealthRepositoryImpl', () {
    test('loads CIP and pending primary care appointments from the gateway', () async {
      final adapter = _MyDataHealthAdapter();
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      final cip = await repository.loadCip(citizenId: _citizenId);
      final appointments = await repository.loadPrimaryCareAppointments(
        citizenId: _citizenId,
        filter: HealthAppointmentFilter.pending,
      );

      expect(cip, 'PNRV901264600010');
      expect(adapter.paths, [
        '/api/v1/ciudadanos/sub-alt-1/salud/cip',
        '/api/v1/ciudadanos/sub-alt-1/salud/primaria-citas-pendientes',
      ]);
      expect(appointments, hasLength(2));
      expect(appointments[0].dateTime, DateTime(2026, 6, 12, 9, 55));
      expect(appointments[0].professional, 'LAGUNA RUIDERA MONTESINOS');
      expect(appointments[0].description, 'DEMANDA');
      expect(appointments[0].modality, 'Presencial');
      expect(appointments[0].center, 'C.S. PALOMAREJOS_PREN');
    });

    test('requests past primary care appointments paginated and sorted newest first', () async {
      final adapter = _MyDataHealthAdapter();
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      final appointments = await repository.loadPrimaryCareAppointments(
        citizenId: _citizenId,
        filter: HealthAppointmentFilter.past,
        page: 2,
      );

      expect(adapter.paths, ['/api/v1/ciudadanos/sub-alt-1/salud/primaria-citas-pasadas']);
      expect(adapter.queries.single, {'pagina': '2'});
      expect(appointments.map((final appointment) => appointment.dateTime), [
        DateTime(2026, 5, 3, 12),
        DateTime(2026, 4, 2, 9),
      ]);
    });

    test('maps pending hospital appointments including nested centro and agenda', () async {
      final adapter = _MyDataHealthAdapter();
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      final appointments = await repository.loadHospitalAppointments(
        citizenId: _citizenId,
        filter: HealthAppointmentFilter.pending,
      );

      expect(adapter.paths, ['/api/v1/ciudadanos/sub-alt-1/salud/hospitalaria-citas-pendientes']);
      expect(appointments, hasLength(1));

      final appointment = appointments.single;
      expect(appointment.dateTime, DateTime(2026, 10, 18, 8, 30));
      expect(appointment.service, 'TRAUMATOLOGIA');
      expect(appointment.provision, 'CONSULTA SUCESIVA');
      expect(appointment.room, 'PLANTA 1 TRAUMATOLOGIA 2');
      expect(appointment.status, 'PENDIENTE');
      expect(appointment.center, 'HOSPITAL GENERAL DE TOMELLOSO');
      expect(appointment.agendaCode, 'TTRA-F');
      expect(appointment.agendaDescription, 'TRAUMATOLOGIA 6 - DRA. CASTELLANOS');
      expect(appointment.clinicalRecordNumber, '10091586');
      expect(appointment.id, '28830100');
    });

    test('sorts past hospital appointments newest first and drops undated ones', () async {
      final adapter = _MyDataHealthAdapter();
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      final appointments = await repository.loadHospitalAppointments(
        citizenId: _citizenId,
        filter: HealthAppointmentFilter.past,
      );

      expect(adapter.paths, ['/api/v1/ciudadanos/sub-alt-1/salud/hospitalaria-citas-pasadas']);
      expect(appointments.map((final appointment) => appointment.dateTime), [
        DateTime(2026, 6, 16, 8, 30),
        DateTime(2026, 4, 9, 10),
      ]);
    });

    test('reports an authorization requirement when the envelope says so', () async {
      final adapter = _MyDataHealthAdapter(errorStatus: 403, errorBody: '{"codigo-respuesta":"412.00"}');
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      // La cláusula 1 no autorizada no puede confundirse con "no hay citas":
      // la pantalla ofrece autorizar en lugar del estado vacío.
      await expectLater(
        repository.loadCip(citizenId: _citizenId),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
      await expectLater(
        repository.loadPrimaryCareAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.past,
        ),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
      await expectLater(
        repository.loadHospitalAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.pending,
        ),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('un 403 sin sobre es un fallo de servicio, no falta de autorización', () async {
      // "403 Forbidden: [no body]" es la fachada fallando contra su
      // microservicio: ofrecer "autorizar" ahí dejaba al ciudadano dando
      // vueltas entre Preferencias y esta pantalla.
      final adapter = _MyDataHealthAdapter(errorStatus: 403);
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      await expectLater(
        repository.loadCip(citizenId: _citizenId),
        throwsA(isA<DioException>()),
      );
    });

    test('un 200 con el sobre de autorización no se pinta como datos', () async {
      // El fallo cerrado del gateway: responde 200 y mete el 412.00 en el
      // sobre. Se colaba como datos y la pantalla pintaba "CIP: -" y "no
      // tienes citas" en vez del aviso de autorización (MD-1).
      final adapter = _MyDataHealthAdapter(errorStatus: 200, errorBody: '{"codigo-respuesta":"412.00","body":null}');
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      await expectLater(
        repository.loadCip(citizenId: _citizenId),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('lets 401 fail so the session refresh interceptor can act', () async {
      final adapter = _MyDataHealthAdapter(errorStatus: 401);
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      // Aceptar el 401 como respuesta válida desactivaría AuthRefreshInterceptor.
      await expectLater(
        repository.loadPrimaryCareAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.pending,
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('identifica el 500/3031 como ausencia de CIP en SESCAM', () async {
      final adapter = _MyDataHealthAdapter(
        errorStatus: 500,
        errorBody: '{"body":null,"codigo-respuesta":"500.00","info-error":{"errores":[{"codigo-error":3031,"mensaje-error":"Error al obtener las citas futuras"}]}}',
      );
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      await expectLater(
        repository.loadPrimaryCareAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.pending,
        ),
        throwsA(isA<MyDataHealthCipMissing>()),
      );
    });

    test('lets a 429 rate limit fail instead of reporting an empty list', () async {
      final adapter = _MyDataHealthAdapter(errorStatus: 429);
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      await expectLater(
        repository.loadPrimaryCareAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.past,
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('returns empty values for missing health data', () async {
      final adapter = _MyDataHealthAdapter(errorStatus: 404);
      final repository = MyDataHealthRepositoryImpl(dio: _dio(adapter));

      expect(await repository.loadCip(citizenId: _citizenId), isNull);
      expect(
        await repository.loadPrimaryCareAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.pending,
        ),
        isEmpty,
      );
      expect(
        await repository.loadHospitalAppointments(
          citizenId: _citizenId,
          filter: HealthAppointmentFilter.pending,
        ),
        isEmpty,
      );
    });
  });
}

Dio _dio(final _MyDataHealthAdapter adapter) {
  return Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
}

final class _MyDataHealthAdapter implements HttpClientAdapter {
  _MyDataHealthAdapter({this.errorStatus, this.errorBody = ''});

  /// Código HTTP con el que responder a todo, en vez del cuerpo de ejemplo.
  final int? errorStatus;

  /// Cuerpo de esa respuesta de error: vacío como el "[no body]" real de la
  /// fachada, o el sobre de autorización.
  final String errorBody;
  final List<String> paths = [];
  final List<Map<String, String>> queries = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    paths.add(options.path);
    queries.add(options.uri.queryParameters);

    final status = errorStatus;
    if (status != null) {
      return ResponseBody.fromString(
        errorBody,
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (options.path.endsWith('/salud/cip')) {
      return _jsonResponse({
        'body': {'cip': 'PNRV901264600010'},
      });
    }

    if (options.path.endsWith('/salud/primaria-citas-pasadas')) {
      return _jsonResponse({
        'body': {
          'nombreCentro': ' C.S. PALOMAREJOS_PREN',
          'listaCitas': [
            {'fecha': '02/04/2026', 'hora': '09:00', 'nomTvisita': 'DEMANDA'},
            {'fecha': '03/05/2026', 'hora': '12:00', 'nomTvisita': 'DEMANDA'},
          ],
        },
      });
    }

    if (options.path.endsWith('/salud/primaria-citas-pendientes')) {
      return _jsonResponse({
        'body': {
          'nombreCentro': ' C.S. PALOMAREJOS_PREN',
          'dirCentro': 'CL BARCELONA, 2 (Toledo)',
          'municipioCentro': 'TOLEDO',
          'listaCitas': [
            {
              'fecha': '12/06/2026',
              'hora': '09:55',
              'nomModoVisita': 'Presencial',
              'nomProfesionalRealizador': 'LAGUNA RUIDERA MONTESINOS',
              'nomTvisita': 'DEMANDA',
            },
            {
              'fecha': '02/07/2026',
              'hora': '08:15',
              'nomTvisita': 'ANALITICA',
            },
          ],
        },
      });
    }

    if (options.path.endsWith('/salud/hospitalaria-citas-pasadas')) {
      return _jsonResponse({
        'body': [
          _hospitalAppointment(date: '09/04/2026', time: '10:00', status: 'REALIZADA'),
          _hospitalAppointment(date: '16/06/2026', time: '08:30', status: 'REALIZADA'),
          {'servicio': 'TRAUMATOLOGIA', 'estadoCita': 'REALIZADA'},
        ],
      });
    }

    return _jsonResponse({
      'body': [
        _hospitalAppointment(date: '18/10/2026', time: '08:30', status: 'PENDIENTE'),
      ],
    });
  }

  Map<String, Object?> _hospitalAppointment({
    required final String date,
    required final String time,
    required final String status,
  }) {
    return {
      'servicio': 'TRAUMATOLOGIA',
      'prestacion': 'CONSULTA SUCESIVA',
      'sala': 'PLANTA 1 TRAUMATOLOGIA 2',
      'estadoCita': status,
      'centro': {'nombre': 'HOSPITAL GENERAL DE TOMELLOSO'},
      'agenda': {
        'codigo': 'TTRA-F',
        'descripcion': 'TRAUMATOLOGIA 6 - DRA. CASTELLANOS',
      },
      'fecha': date,
      'hora': time,
      'nhc': '10091586',
      'id': '28830100',
    };
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
