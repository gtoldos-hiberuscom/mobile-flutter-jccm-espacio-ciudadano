import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/notificaciones_paginacion_exception.dart';
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
        'size': 50,
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
        'size': 50,
      });
    });

    test('loads every notification page for a status', () async {
      final adapter = SequenceHttpClientAdapter([
        AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              for (var id = 1; id <= 50; id++) {'idNotificacion': id, 'concepto': 'Notificación $id'},
            ],
          },
        ),
        const AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              {'idNotificacion': 51, 'concepto': 'Notificación 51'},
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

      expect(result, hasLength(51));
      expect(adapter.requests, hasLength(2));
      expect(adapter.requests[0].queryParameters['page'], 0);
      expect(adapter.requests[1].queryParameters['page'], 1);
      expect(adapter.requests.every((final request) => request.queryParameters['size'] == 50), isTrue);
    });

    test('una página llena con un elemento sin id sigue pidiendo la siguiente', () async {
      final adapter = SequenceHttpClientAdapter([
        AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              for (var id = 1; id <= 49; id++) {'idNotificacion': id, 'concepto': 'Notificación $id'},
              // Elemento que el mapeo descarta: sin id no se puede abrir ni
              // deduplicar. La página sigue viniendo llena.
              const {'concepto': 'Sin id'},
            ],
          },
        ),
        const AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              {'idNotificacion': 50, 'concepto': 'Notificación 50'},
            ],
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada);

      // El corte iba por los elementos mapeados (49 < 50), así que la página 1
      // no se pedía nunca y esa notificación desaparecía en silencio.
      expect(adapter.requests, hasLength(2));
      expect(result, hasLength(50));
    });

    test('el barrido falla si la última página cabía llena en el tope', () async {
      final adapter = SequenceHttpClientAdapter([
        for (var page = 0; page < 3; page++)
          AdapterResponse(
            statusCode: 200,
            body: {
              'content': [
                for (var id = 1; id <= 50; id++) {'idNotificacion': page * 50 + id, 'concepto': 'Notificación $id'},
              ],
            },
          ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio, maxPages: 3);

      // Devolver las 150 acumuladas como si fueran todas es la vía silenciosa
      // que este contrato no permite: la pantalla ofrece reintentar.
      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada),
        throwsA(isA<NotificacionesPaginacionIncompletaException>()),
      );
      expect(adapter.requests, hasLength(3));
    });

    test('una página que repite los ids de la anterior corta el barrido', () async {
      AdapterResponse paginaLlena() => AdapterResponse(
        statusCode: 200,
        body: {
          'content': [
            for (var id = 1; id <= 50; id++) {'idNotificacion': id, 'concepto': 'Notificación $id'},
          ],
        },
      );
      final adapter = SequenceHttpClientAdapter([paginaLlena(), paginaLlena()]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      // El backend está ignorando `page`: se corta a las dos peticiones en vez
      // de gastar el tope entero.
      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada),
        throwsA(isA<NotificacionesPaginacionIncompletaException>()),
      );
      expect(adapter.requests, hasLength(2));
    });

    test('un token ya cancelado no llega a pedir ninguna página', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 200, body: {'content': <Object?>[]}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadNotificaciones(
          citizenId: 'PER9998003',
          estado: NotificacionEstado.aceptada,
          cancelToken: CancelToken()..cancel(),
        ),
        throwsA(isA<DioException>().having((final error) => error.type, 'type', DioExceptionType.cancel)),
      );
      expect(adapter.requests, isEmpty);
    });

    test('cancelar a mitad del barrido no pide más páginas', () async {
      final cancelToken = CancelToken();
      final adapter = SequenceHttpClientAdapter(
        [
          for (var page = 0; page < 2; page++)
            AdapterResponse(
              statusCode: 200,
              body: {
                'content': [
                  for (var id = 1; id <= 50; id++) {'idNotificacion': page * 50 + id, 'concepto': 'Notificación $id'},
                ],
              },
            ),
        ],
        // Lo que hace `ref.onDispose` al abandonar la pantalla con el barrido
        // en marcha.
        onRequest: (final _) => cancelToken.cancel(),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada, cancelToken: cancelToken),
        throwsA(isA<DioException>().having((final error) => error.type, 'type', DioExceptionType.cancel)),
      );
      expect(adapter.requests, hasLength(1));
    });

    test('un cuerpo de error que parsea como notificación no se acepta como página', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 500,
          body: {
            'content': [
              {'idNotificacion': 1, 'concepto': 'Cuerpo de error'},
            ],
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      // Devolvía la lista del cuerpo del error como si fuera una página válida:
      // tercera vía de lista parcial sin avisar.
      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada),
        throwsA(isA<DioException>()),
      );
    });

    test('un 404 es "no hay notificaciones", no un fallo', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 404, body: {'mensaje-respuesta': 'sin resultados'}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada);

      expect(result, isEmpty);
    });

    test('un 404 en la página siguiente cierra el barrido con lo que ya había', () async {
      final adapter = SequenceHttpClientAdapter([
        AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              for (var id = 1; id <= 50; id++) {'idNotificacion': id, 'concepto': 'Notificación $id'},
            ],
          },
        ),
        const AdapterResponse(statusCode: 404, body: {'mensaje-respuesta': 'sin resultados'}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.aceptada);

      expect(result, hasLength(50));
      expect(adapter.requests, hasLength(2));
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
        adapter.requests.every((final request) => request.path == '/api/v1/ciudadanos/PER9998003/notificaciones' && request.queryParameters['page'] == 0 && request.queryParameters['size'] == 50),
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

    test('el sobre de autorización sale como señal tipada, no como DioException', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 403,
          body: <String, dynamic>{
            'body': null,
            'mensaje-respuesta': 'No se pudo dar de alta el soporte.',
            'codigo-respuesta': '412.00',
            'info-error': {
              'errores': [
                {'codigo-error': '3034', 'mensaje-error': 'Cuando autorizas a que Espacio Ciudadano…'},
              ],
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      // Quién decide qué significa es la capa de presentación: aquí no se sabe
      // si el ciudadano revocó o si el gateway no pudo leer preferencias.
      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.expirada),
        throwsA(isA<AuthorizationRequiredException>()),
      );
    });

    test('en "Todo" basta con que un estado responda el sobre de autorización', () async {
      final adapter = _estadoAdapter({
        NotificacionEstado.pendiente: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.aceptada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.rechazada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.expirada: const AdapterResponse(
          statusCode: 403,
          body: <String, dynamic>{'codigo-respuesta': '412.00'},
        ),
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadNotificaciones(citizenId: 'PER9998003'),
        throwsA(isA<AuthorizationRequiredException>()),
      );
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

    test('"Todo" no fusiona dos elementos distintos que llegan sin id', () async {
      // El caso que abre el barrido de los cuatro estados: con el id fabricado
      // (`?? 0`) estas dos notificaciones distintas colapsaban en una sola
      // tarjeta, con los datos de una y el estado de la otra al resolver la
      // precedencia entre barridos.
      final adapter = _estadoAdapter({
        NotificacionEstado.pendiente: const AdapterResponse(
          statusCode: 200,
          body: [
            {'concepto': 'Sin id, pendiente'},
            {'idNotificacion': 7, 'concepto': 'Con id'},
          ],
        ),
        NotificacionEstado.aceptada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.rechazada: const AdapterResponse(statusCode: 200, body: <dynamic>[]),
        NotificacionEstado.expirada: const AdapterResponse(
          statusCode: 200,
          body: [
            {'concepto': 'Sin id, expirada'},
          ],
        ),
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      // Los dos elementos sin id se descartan: es preferible perder una
      // notificación que no se puede identificar a inventar una mezclando dos.
      expect(result.map((final notification) => notification.id), [7]);
      expect(result.single.estado, NotificacionEstado.pendiente);
    });

    test('un elemento sin id utilizable se descarta dentro de un estado concreto', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: [
            {'idNotificacion': 11, 'concepto': 'Con id'},
            {'concepto': 'Sin id'},
            {'idNotificacion': 'no-numérico', 'concepto': 'Id que no parsea'},
          ],
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.pendiente);

      expect(result.map((final notification) => notification.id), [11]);
    });

    test('el detalle sin id en el sobre usa el id consultado, no un 0', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {'concepto': 'Detalle sin id', 'estado': 'PENDIENTE'},
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(citizenId: '99999999R', notificacionId: 7924);

      expect(detail.id, 7924);
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

    test('un estado del detalle presente pero no reconocido no hereda el del resumen', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'body': {'id': 7924, 'concepto': 'Requerimiento', 'estado': 'LEIDA_POR_TERCERO'},
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final detail = await repository.loadNotificacion(
        citizenId: 'PER9998003',
        notificacionId: 7924,
        fallbackEstado: NotificacionEstado.pendiente,
      );

      // El backend declara un estado y no sabemos leerlo: respaldarlo con el
      // del resumen resucitaba la acción de comparecer sobre algo que ya no
      // estaba pendiente.
      expect(detail.estado, isNull);
    });

    test('un estado no reconocido en el listado conserva el estado consultado', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: {
            'content': [
              {'idNotificacion': 7924, 'concepto': 'Requerimiento', 'estado': 'LEIDA_POR_TERCERO'},
            ],
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003', estado: NotificacionEstado.pendiente);

      // Asimetría deliberada con el detalle: el elemento llegó filtrando por
      // `pendiente`, así que el backend lo clasifica ahí; dejarlo en `null`
      // devolvería la tarjeta sin etiqueta ni fecha.
      expect(result.single.estado, NotificacionEstado.pendiente);
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
