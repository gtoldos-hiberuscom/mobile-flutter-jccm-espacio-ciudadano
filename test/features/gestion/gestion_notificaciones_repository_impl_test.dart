import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_notificaciones_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('GestionNotificacionesRepositoryImpl', () {
    test('loads notificaciones when backend wraps the list inside body', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': [
              {
                'idNotificacion': 45,
                'concepto': 'descripcion',
                'procedimientoAdministrativo': {
                  'denominacion': 'procedimiento',
                  'idFicha': null,
                },
                'unidadOrganica': {'nombre': '00'},
                'fechaCaducidad': '2025-03-01T23:59:59.000+00:00',
                'sistemaOrigen': 'notifica2',
              },
            ],
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(
        citizenId: '99999999R',
        estado: NotificacionEstado.aceptada,
      );

      expect(result, hasLength(1));
      expect(result.single.id, 45);
      expect(result.single.concepto, 'descripcion');
      expect(result.single.procedimientoDenominacion, 'procedimiento');
      expect(result.single.unidadOrganicaNombre, '00');
      expect(result.single.sistemaOrigen, 'notifica2');
      expect(result.single.estado, NotificacionEstado.aceptada);
      expect(
        result.single.fechaCaducidad,
        DateTime.parse('2025-03-01T23:59:59.000+00:00'),
      );
      expect(adapter.requests.single.method, 'GET');
      expect(
        adapter.requests.single.path,
        '/api/v1/ciudadanos/99999999R/notificaciones',
      );
      expect(adapter.requests.single.queryParameters, <String, dynamic>{
        'estado': 'aceptada',
        'page': 0,
        'size': 10,
      });
    });

    test('loads notificaciones from a stringified JSON response and tags estado', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '[{"idNotificacion":17,"concepto":"Aviso","procedimientoAdministrativo":{"denominacion":"Alta","idFicha":"FICHA-1"},"unidadOrganica":{"nombre":"Unidad A"},"fechaCaducidad":"2026-06-25T10:15:00Z","sistemaOrigen":"INDEXA"}]',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(
        citizenId: 'PER9998003',
        estado: NotificacionEstado.pendiente,
      );

      expect(result, hasLength(1));
      expect(result.single.id, 17);
      expect(result.single.concepto, 'Aviso');
      expect(result.single.procedimientoDenominacion, 'Alta');
      expect(result.single.procedimientoIdFicha, 'FICHA-1');
      expect(result.single.unidadOrganicaNombre, 'Unidad A');
      expect(result.single.sistemaOrigen, 'INDEXA');
      expect(result.single.estado, NotificacionEstado.pendiente);
      expect(result.single.fechaCaducidad, DateTime.parse('2026-06-25T10:15:00Z'));
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/PER9998003/notificaciones');
      expect(adapter.requests.single.queryParameters, <String, dynamic>{
        'estado': 'pendiente',
        'page': 0,
        'size': 10,
      });
    });

    test('loads every notification page for a status', () async {
      final adapter = SequenceHttpClientAdapter([
        AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              for (var id = 1; id <= 10; id++) {'idNotificacion': id, 'concepto': 'Notificación $id'},
            ],
          },
        ),
        const AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              {'idNotificacion': 11, 'concepto': 'Notificación 11'},
            ],
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(
        citizenId: 'PER9998003',
        estado: NotificacionEstado.aceptada,
      );

      expect(result, hasLength(11));
      expect(adapter.requests, hasLength(2));
      expect(adapter.requests[0].queryParameters['page'], 0);
      expect(adapter.requests[1].queryParameters['page'], 1);
      expect(adapter.requests.every((final request) => request.queryParameters['size'] == 10), isTrue);
    });

    test('loads accepted notifications when body uses the detailed Notifica shape', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': '[{"id":7924,"concepto":"Notificación aceptada","fecCaducidad":"2026-12-24T23:59:59Z","unidadOrganica":{"sistema":"notifica2","informacionAdicional":[{"clave":"nombre","valor":"Unidad aceptada"}]},"procedimientoAdministrativo":{"informacionAdicional":[{"clave":"denominacion","valor":"Procedimiento aceptado"}]}}]',
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(
        citizenId: 'PER9998003',
        estado: NotificacionEstado.aceptada,
      );

      expect(result, hasLength(1));
      expect(result.single.id, 7924);
      expect(result.single.concepto, 'Notificación aceptada');
      expect(result.single.procedimientoDenominacion, 'Procedimiento aceptado');
      expect(result.single.unidadOrganicaNombre, 'Unidad aceptada');
      expect(result.single.sistemaOrigen, 'notifica2');
      expect(result.single.estado, NotificacionEstado.aceptada);
    });

    test('loads the full notification detail through the generated client', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {
              'id': 7924,
              'concepto': 'Gestión electrónica de contratación',
              'estado': 'EXPIRADA',
              'fecAlta': '2026-12-14T10:00:00Z',
              'fecCaducidad': '2026-12-24T23:59:59Z',
              'unidadOrganica': {
                'sistema': 'notifica2',
                'informacionAdicional': [
                  {'clave': 'nombre', 'valor': 'Servicio de contratación electrónica y registros'},
                ],
              },
              'procedimientoAdministrativo': {
                'informacionAdicional': [
                  {'clave': 'denominacion', 'valor': 'MD7K'},
                ],
              },
              'expediente': {'identificador': '2026/09032976'},
              'documentos': [
                {'orden': 1, 'nombre': 'Notificacion.pdf', 'tamano': 125952},
              ],
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(
        citizenId: '99999999R',
        notificacionId: 7924,
        fallbackEstado: NotificacionEstado.expirada,
        sistemaOrigen: 'notifica2',
      );

      expect(detail.id, 7924);
      expect(detail.estado, NotificacionEstado.expirada);
      expect(detail.organismo, 'Servicio de contratación electrónica y registros');
      expect(detail.procedimiento, 'MD7K');
      expect(detail.expediente, '2026/09032976');
      expect(detail.fechaExpiracion, DateTime.parse('2026-12-24T23:59:59Z'));
      expect(detail.documentos.single.nombre, 'Notificacion.pdf');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/99999999R/notificaciones/7924');
    });

    test('ignores a document that only contains technical references', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {
              'id': 152,
              'concepto': 'Transmisiones patrimoniales',
              'estado': 'EXPIRADA',
              'documentos': [
                {
                  'orden': 1,
                  'identificadorReferencia': 'DOC-001',
                  'documento': {
                    'id': 12345,
                    'identificador': 'notifica-doc-12345',
                    'aplicacion': 'notifica2',
                    'tipoEntidad': 'DOCUMENTO',
                  },
                },
              ],
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(
        citizenId: '99999999R',
        notificacionId: 152,
        fallbackEstado: NotificacionEstado.expirada,
      );

      expect(detail.documentos, isEmpty);
    });

    test('ignores unnamed documents instead of inventing visible names', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {
              'id': 152,
              'documentos': [
                {'orden': 0},
                <String, Object?>{},
              ],
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(
        citizenId: '99999999R',
        notificacionId: 152,
        fallbackEstado: NotificacionEstado.expirada,
      );

      expect(detail.documentos, isEmpty);
    });

    test('accepts a pending notification through the comparecer endpoint', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {'body': <String, dynamic>{}},
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      await repository.transitionNotificacion(
        citizenId: '99999999R',
        notificacionId: 7924,
        accion: 'ACEPTAR',
        sistemaOrigen: 'notifica2',
      );

      expect(adapter.requests.single.method, 'POST');
      // API 1.86: el endpoint de transiciones con cuerpo fue sustituido por
      // POST .../comparecer sin cuerpo; la acción ya no viaja al backend.
      expect(
        adapter.requests.single.path,
        '/api/v1/ciudadanos/99999999R/notificaciones/7924/comparecer',
      );
    });

    test('"Todo" consulta una vez sin filtro de estado', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 1,
              'concepto': 'Notificación 1',
              'estado': 'pendiente',
              'procedimientoAdministrativo': {'denominacion': 'Proc 1'},
            },
          ],
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.queryParameters, {'page': 0, 'size': 10});
      expect(result.single.id, 1);
      expect(result.single.estado, NotificacionEstado.pendiente);
    });

    test('"Todo" propaga el error del listado único', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 500, body: <String, dynamic>{'mensaje': 'error'}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadNotificaciones(citizenId: '99999999R'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests, hasLength(1));
    });
    test('un elemento sin estado consultado sin filtro queda con estado desconocido', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 31,
              'concepto': 'Notificación sin estado',
              'procedimientoAdministrativo': {'denominacion': 'Proc'},
            },
          ],
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      // Antes se rellenaba con cadena vacía, que la UI leía como "expirada" y
      // ocultaba la acción de comparecer (H-03).
      expect(result.single.estado, isNull);
      expect(adapter.requests.single.queryParameters, {'page': 0, 'size': 10});
    });

    test('el detalle informa el estado real aunque el resumen no lo conociera', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {
              'id': 7924,
              'concepto': 'Requerimiento de subsanación',
              'estado': 'PENDIENTE',
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(citizenId: '99999999R', notificacionId: 7924);

      expect(detail.estado, NotificacionEstado.pendiente);
    });

    test('el detalle acepta el vocabulario del histórico de Notifica', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {
              'id': 7924,
              'concepto': 'Requerimiento de subsanación',
              'estado': 'PUESTO_A_DISPOSICION',
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(citizenId: '99999999R', notificacionId: 7924);

      expect(detail.estado, NotificacionEstado.pendiente);
    });

    test('sin estado en el detalle ni en el resumen, el estado queda desconocido', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {'id': 7924, 'concepto': 'Requerimiento de subsanación'},
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(citizenId: '99999999R', notificacionId: 7924);

      expect(detail.estado, isNull);
    });

    test('el estado del resumen solo se usa si el detalle no informa el suyo', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {'id': 7924, 'concepto': 'Requerimiento de subsanación'},
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(
        citizenId: '99999999R',
        notificacionId: 7924,
        fallbackEstado: NotificacionEstado.pendiente,
      );

      expect(detail.estado, NotificacionEstado.pendiente);
    });
  });
}
