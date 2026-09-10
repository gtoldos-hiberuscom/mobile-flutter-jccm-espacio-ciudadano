import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_employment_repository_impl.dart';

void main() {
  group('MyDataEmploymentRepositoryImpl', () {
    test('loads current employment demand from the ciudadano employment resource', () async {
      final adapter = _EmploymentAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(
        citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
        documentNumber: '12345678A',
        givenName: 'JUAN',
        firstSurname: 'PEREZ',
        secondSurname: 'SANCHEZ',
      );

      expect(adapter.request?.method, 'POST');
      expect(
        adapter.request?.path,
        '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/empleo/demandante-empleo-fecha-actual',
      );
      expect(adapter.request?.jsonBody, {
        'tipodoc': 'NIF',
        'docu': '12345678A',
        'nombretitular': 'JUAN',
        'apellido1TITULAR': 'PEREZ',
        'apellido2TITULAR': 'SANCHEZ',
      });
      expect(demand?.status, 'Activa');
      expect(demand?.uninterruptedRegistrationDate, DateTime(2000, 7));
      expect(demand?.message, 'Tramitada');
    });

    test('omits holder name fields when the token does not provide them', () async {
      final adapter = _EmploymentAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      await repository.loadDemand(
        citizenId: 'citizen-1',
        documentNumber: 'B12345674',
        firstSurname: '   ',
      );

      expect(adapter.request?.jsonBody, {
        'tipodoc': 'CIF',
        'docu': 'B12345674',
      });
    });

    test('returns null when employment demand is not found', () async {
      final adapter = _EmploymentAdapter(returnNotFound: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(citizenId: 'citizen-1', documentNumber: '00000000T');

      expect(demand, isNull);
    });

    test('maps inactive employment demand to not registered status', () async {
      final adapter = _EmploymentAdapter(inscrito: 'N');
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(citizenId: 'citizen-1', documentNumber: '12345678A');

      expect(demand?.status, 'No Inscrito');
    });

    test('never fabricates an "Activa" demand from a payload without real data', () async {
      // Sin ninguna clave de estado/mensaje/fecha: solo el default fabricado
      // podía convertir esto en una demanda visible.
      final adapter = _StaticAdapter(200, {
        'codigo-respuesta': '200.00',
        'body': {'idpeticion': '7a7479f7fa5fec7a5t0014795'},
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(citizenId: 'citizen-1', documentNumber: '12345678A');

      expect(demand, isNull, reason: 'the default status used to be a fabricated "Activa"');
    });

    test('un 403 con el sobre de autorización pide autorizar', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(403, {'codigo-respuesta': '412.00'});
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadDemand(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('un 403 sin sobre es un fallo de servicio, no falta de autorización', () async {
      // La fachada devuelve "403 Forbidden: [no body]" cuando falla contra su
      // microservicio. Ofrecer "autorizar" ahí metía al ciudadano en un bucle:
      // iba a Preferencias, veía la cláusula aceptada, volvía y seguía el 403.
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(403, {'codigo-respuesta': '403.00'});
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadDemand(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
    });

    test('a 500 with body propagates instead of becoming a fabricated demand', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(500, {'codigo-respuesta': '500.00', 'mensaje-respuesta': 'Error'});
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadDemand(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
    });

    test('un 200 con el sobre de autorización no se pinta como datos', () async {
      // El fallo cerrado del gateway: responde 200 y mete el 412.00 en el
      // sobre. Leerlo como datos pintaba "sin demanda" en vez del aviso de
      // autorización (MD-1, misma familia que salud).
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(200, {'codigo-respuesta': '412.00', 'body': null});
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadDemand(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('loads registered employment offers from the ciudadano employment resource', () async {
      final adapter = _EmploymentAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final offers = await repository.loadOfferRegistrations(
        citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
        documentNumber: 'X1234567L',
      );

      expect(adapter.request?.method, 'POST');
      expect(
        adapter.request?.path,
        '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/empleo/ofertas',
      );
      expect(adapter.request?.jsonBody, {
        'tipo': 'A',
        'idaut': 'ESP-CIUDADANO',
        'proc': 'JCCMEC',
        'tipodoc': 'NIE',
        'docu': 'X1234567L',
      });
      expect(offers, hasLength(2));
      expect(offers.first.title, 'ATS/DUE');
      expect(offers.first.publicationDate, DateTime(2026, 7, 3));
      expect(offers.first.registrationDate, DateTime(2026, 7, 20));
      expect(offers.first.selectionEndDate, isNull);
      expect(offers.first.applicationStatus, 'Inscrita');
      expect(offers.last.title, 'MOZO ALMACEN');
      expect(offers.last.selectionEndDate, DateTime(2026, 8, 31));
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
      body == null ? '' : jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}

final class _CapturedRequest {
  const _CapturedRequest({
    required this.method,
    required this.path,
    required this.jsonBody,
  });

  final String method;
  final String path;
  final Map<String, dynamic>? jsonBody;
}

final class _EmploymentAdapter implements HttpClientAdapter {
  _EmploymentAdapter({this.returnNotFound = false, this.inscrito = 'S'});

  final bool returnNotFound;
  final String inscrito;
  _CapturedRequest? request;

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
    request = _CapturedRequest(
      method: options.method,
      path: options.path,
      jsonBody: bodyBytes.isEmpty ? null : jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>,
    );

    if (returnNotFound) {
      return ResponseBody.fromString('', 404);
    }

    if (options.path.endsWith('/empleo/ofertas')) {
      return ResponseBody.fromString(
        jsonEncode({
          'body': {
            'respuesta': {
              'codestado': '0',
              'datosespecificos': [
                {
                  'NombreOfertaEmpleo': 'ATS/DUE',
                  'EstadoCandidatura': 'Inscrita',
                  'FechaPublicacion': '2026-07-03',
                  'FechaInscripcion': '2026-07-20',
                  'FechaFinalizacionProceso': '',
                },
                {
                  'NombreOfertaEmpleo': 'MOZO ALMACEN',
                  'EstadoCandidatura': 'Inscrita',
                  'FechaPublicacion': '2026-07-03',
                  'FechaInscripcion': '2026-07-20',
                  'FechaFinalizacionProceso': '2026-08-31',
                },
              ],
            },
          },
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return ResponseBody.fromString(
      jsonEncode({
        'body': {
          'resul': '0',
          'mensaje': 'Tramitada',
          'idpeticion': '7a7479f7fa5fec7a5t0014795',
          'inscrito': inscrito,
          'ultimainscrip': '20000701',
        },
        'timestamp': '2026-08-20T08:35:53.157147',
        'mensaje-respuesta': 'Respuesta correcta',
        'codigo-respuesta': '200.00',
        'info-error': null,
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
