import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
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
        estado: 'aceptada',
      );

      expect(result, hasLength(1));
      expect(result.single.id, 45);
      expect(result.single.concepto, 'descripcion');
      expect(result.single.procedimientoDenominacion, 'procedimiento');
      expect(result.single.unidadOrganicaNombre, '00');
      expect(result.single.sistemaOrigen, 'notifica2');
      expect(result.single.estado, 'aceptada');
      expect(
        result.single.fechaCaducidad,
        DateTime.parse('2025-03-01T23:59:59.000+00:00'),
      );
      expect(adapter.requests.single.method, 'GET');
      expect(
        adapter.requests.single.path,
        '/api/v1/ciudadanos/99999999R/notificaciones',
      );
      expect(adapter.requests.single.queryParameters, <String, dynamic>{'estado': 'aceptada'});
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
        estado: 'pendiente',
      );

      expect(result, hasLength(1));
      expect(result.single.id, 17);
      expect(result.single.concepto, 'Aviso');
      expect(result.single.procedimientoDenominacion, 'Alta');
      expect(result.single.procedimientoIdFicha, 'FICHA-1');
      expect(result.single.unidadOrganicaNombre, 'Unidad A');
      expect(result.single.sistemaOrigen, 'INDEXA');
      expect(result.single.estado, 'pendiente');
      expect(result.single.fechaCaducidad, DateTime.parse('2026-06-25T10:15:00Z'));
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/PER9998003/notificaciones');
      expect(adapter.requests.single.queryParameters, <String, dynamic>{'estado': 'pendiente'});
    });

    test('"Todo" (sin estado) consulta cada estado y fusiona los resultados', () async {
      // Una respuesta por estado, cada una con un id único.
      final adapter = SequenceHttpClientAdapter([
        for (var i = 1; i <= 4; i++)
          AdapterResponse(
            statusCode: 200,
            body: [
              {
                'idNotificacion': i,
                'concepto': 'Notificación $i',
                'procedimientoAdministrativo': {'denominacion': 'Proc $i'},
              },
            ],
          ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      const estadosEsperados = {'pendiente', 'expirada', 'aceptada', 'rechazada'};

      // Se consultó cada estado del enum exactamente una vez.
      expect(adapter.requests, hasLength(4));
      expect(
        adapter.requests.map((final r) => r.queryParameters['estado']).toSet(),
        estadosEsperados,
      );

      // Se fusionan las 4 notificaciones, cada una etiquetada con su estado.
      expect(result, hasLength(4));
      expect(result.map((final n) => n.id).toSet(), {1, 2, 3, 4});
      expect(result.map((final n) => n.estado).toSet(), estadosEsperados);
    });

    test('"Todo" tolera fallos parciales y devuelve los estados que sí responden', () async {
      // El tercer estado consultado devuelve 500; los otros tres responden ok.
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 200, body: [{'idNotificacion': 1, 'concepto': 'A'}]),
        const AdapterResponse(statusCode: 200, body: [{'idNotificacion': 2, 'concepto': 'B'}]),
        const AdapterResponse(statusCode: 500, body: <String, dynamic>{'mensaje': 'error'}),
        const AdapterResponse(statusCode: 200, body: [{'idNotificacion': 4, 'concepto': 'D'}]),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final result = await repository.loadNotificaciones(citizenId: 'PER9998003');

      expect(adapter.requests, hasLength(4));
      expect(result.map((final n) => n.id).toSet(), {1, 2, 4});
    });
  });
}
