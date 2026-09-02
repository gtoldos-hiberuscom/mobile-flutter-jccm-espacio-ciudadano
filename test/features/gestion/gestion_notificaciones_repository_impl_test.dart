import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/mappers/notificacion_estado_mapper.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_notificaciones_repository_impl.dart';

import '../../test_support/keyed_http_client_adapter.dart';
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

    test('"Todo" consulta los cuatro estados y etiqueta cada elemento', () async {
      final adapter = _estadoAdapter({
        NotificacionEstado.pendiente: const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 1,
              'concepto': 'Pendiente',
              'procedimientoAdministrativo': {'denominacion': 'Proc 1'},
            },
          ],
        ),
        NotificacionEstado.aceptada: const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 2,
              'concepto': 'Aceptada',
              'procedimientoAdministrativo': {'denominacion': 'Proc 2'},
            },
          ],
        ),
        NotificacionEstado.rechazada: const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 3,
              'concepto': 'Rechazada',
              'procedimientoAdministrativo': {'denominacion': 'Proc 3'},
            },
          ],
        ),
        NotificacionEstado.expirada: const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 4,
              'concepto': 'Expirada',
              'procedimientoAdministrativo': {'denominacion': 'Proc 4'},
            },
          ],
        ),
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      // Sin este barrido por estados, el listado indexado deja el estado en
      // `null` y la tarjeta de "Todo" pierde etiqueta y fecha de expiración.
      expect(adapter.requests, hasLength(4));
      expect(
        adapter.requestedKeys.toSet(),
        {'pendiente', 'aceptada', 'rechazada', 'expirada'},
      );
      expect(
        adapter.requests.every((final request) => request.path == '/api/v1/ciudadanos/PER9998003/notificaciones' && request.queryParameters['page'] == 0 && request.queryParameters['size'] == 10),
        isTrue,
      );
      expect(
        {for (final notification in result) notification.id: notification.estado},
        {
          1: NotificacionEstado.pendiente,
          2: NotificacionEstado.aceptada,
          3: NotificacionEstado.rechazada,
          4: NotificacionEstado.expirada,
        },
      );
    });

    test('"Todo" llega ordenado como una bandeja: pendientes por vencimiento, resto por recencia', () async {
      final adapter = _estadoAdapter({
        NotificacionEstado.pendiente: const AdapterResponse(
          statusCode: 200,
          body: [
            {'idNotificacion': 2, 'concepto': 'Pendiente tardía', 'fechaCaducidad': '2026-09-21T23:59:59Z'},
            {'idNotificacion': 4, 'concepto': 'Pendiente urgente', 'fechaCaducidad': '2026-09-04T23:59:59Z'},
          ],
        ),
        NotificacionEstado.aceptada: const AdapterResponse(
          statusCode: 200,
          body: [
            {'idNotificacion': 5, 'concepto': 'Aceptada antigua', 'fechaCaducidad': '2026-08-28T23:59:59Z'},
            {'idNotificacion': 1, 'concepto': 'Aceptada reciente', 'fechaCaducidad': '2026-09-30T23:59:59Z'},
          ],
        ),
        NotificacionEstado.rechazada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.expirada: const AdapterResponse(
          statusCode: 200,
          body: [
            {'idNotificacion': 3, 'concepto': 'Expirada', 'fechaCaducidad': '2026-07-03T23:59:59Z'},
          ],
        ),
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      // Fusionar cuatro listas filtradas no deja ningún orden del backend que
      // preservar, así que "Todo" define el suyo en vez de heredar el del mapa.
      expect(result.map((final notification) => notification.id), [4, 2, 1, 5, 3]);
    });

    test('"Todo" propaga el error de cualquiera de los barridos', () async {
      final adapter = _estadoAdapter({
        NotificacionEstado.pendiente: const AdapterResponse(
          statusCode: 200,
          body: [
            {'idNotificacion': 1, 'concepto': 'Pendiente'},
          ],
        ),
        NotificacionEstado.aceptada: const AdapterResponse(statusCode: 500, body: <String, dynamic>{'mensaje': 'error'}),
        NotificacionEstado.rechazada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.expirada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      // Preferimos fallar la pestaña a mostrar una lista incompleta como si
      // estuviera completa.
      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests, hasLength(4));
    });

    test('"Todo" fusiona el mismo id que aparece en dos barridos con el estado terminal', () async {
      final adapter = _estadoAdapter({
        NotificacionEstado.pendiente: const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 31,
              'concepto': 'Notificación en tránsito',
              'procedimientoAdministrativo': {'denominacion': 'Proc'},
            },
          ],
        ),
        NotificacionEstado.aceptada: const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 31,
              'concepto': 'Notificación en tránsito',
              'procedimientoAdministrativo': {'denominacion': 'Proc'},
            },
          ],
        ),
        NotificacionEstado.rechazada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.expirada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      // Solo pasa si la notificación transitó mientras se consultaba: gana el
      // estado terminal, que es el dato más nuevo, y no se duplica la tarjeta.
      expect(result, hasLength(1));
      expect(result.single.id, 31);
      expect(result.single.estado, NotificacionEstado.aceptada);
    });

    test('un elemento con estado en el payload conserva el suyo, no el consultado', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: [
            {
              'idNotificacion': 44,
              'concepto': 'Notificación con estado propio',
              'estado': 'rechazada',
              'procedimientoAdministrativo': {'denominacion': 'Proc'},
            },
          ],
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(
        citizenId: 'PER9998003',
        estado: NotificacionEstado.pendiente,
      );

      expect(result.single.estado, NotificacionEstado.rechazada);
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

/// Adaptador con una respuesta por estado del contrato: la pestaña "Todo" pide
/// los cuatro en paralelo, así que hay que emparejar por `estado` y no por
/// orden de llegada.
KeyedHttpClientAdapter _estadoAdapter(final Map<NotificacionEstado, AdapterResponse> responses) {
  return KeyedHttpClientAdapter(
    responses: {
      for (final entry in responses.entries) notificacionEstadoQueryValue(entry.key): [entry.value],
    },
  );
}
