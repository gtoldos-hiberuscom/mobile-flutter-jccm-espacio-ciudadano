import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_registros_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('GestionRegistrosRepositoryImpl', () {
    test('loads entradas when backend sends a singleton item as object', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '{"publicacionportal":{"item":{"registro":"ENT-1","asunto":"S020","desasunto":"Entrada general","fechareg":"2026-06-21","desconsej":"Consejería B"}}}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionRegistrosRepositoryImpl(dio: dio);

      final result = await repository.loadEntradas(citizenId: 'sid-1', documentNumber: '99999999R');

      expect(result, hasLength(1));
      expect(result.single.numregistro, 'ENT-1');
      expect(result.single.titulo, 'Entrada general');
      expect(result.single.fecha, '2026-06-21');
      expect(result.single.consejeria, 'Consejería B');
      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/sid-1/expedientes/listado-registro-entrada');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{
          'numerodocumento': '99999999R',
          'tipodocumento': 'NIF',
        },
      );
    });

    test('loads salidas through the generated endpoint when response is wrapped inside body', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '{"body":{"publicacionportal":{"item":{"registro":"SAL-1","asunto":"SIM2","desasunto":"Salida registrada","fechareg":"2026-06-22","desconsej":"Consejería C"}}}}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionRegistrosRepositoryImpl(dio: dio);

      final result = await repository.loadSalidas(citizenId: 'sid-1', documentNumber: '99999999R');

      expect(result, hasLength(1));
      expect(result.single.numregistro, 'SAL-1');
      expect(result.single.titulo, 'Salida registrada');
      expect(result.single.fecha, '2026-06-22');
      expect(result.single.consejeria, 'Consejería C');
      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/sid-1/expedientes/listado-registro-salida');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{
          'numerodocumento': '99999999R',
          'tipodocumento': 'NIF',
        },
      );
    });

    test('el sobre de autorización sale como señal tipada, no como lista vacía', () async {
      // Llega con 403, pero también dentro de un 2xx cuando el gateway falla
      // cerrado: sin traducirlo, el `catch` indulgente lo daba por "no hay
      // registros" y la pantalla afirmaba que el ciudadano no tiene ninguno.
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '{"codigo-respuesta":"412.00","body":null}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionRegistrosRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadEntradas(citizenId: 'sid-1', documentNumber: '99999999R'),
        throwsA(isA<AuthorizationRequiredException>()),
      );
    });

    test('el sobre con el 3034 dentro de un error HTTP también se traduce', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 403,
          contentType: Headers.textPlainContentType,
          body: '{"codigo-respuesta":"200.00","info-error":{"errores":[{"codigo-error":"3034"}]}}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionRegistrosRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadSalidas(citizenId: 'sid-1', documentNumber: '99999999R'),
        throwsA(isA<AuthorizationRequiredException>()),
      );
    });

    test('does not use the SIACI code as title when the summary is absent', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '{"publicacionportal":{"item":{"registro":"ENT-1","asunto":"S020"}}}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionRegistrosRepositoryImpl(dio: dio);

      final result = await repository.loadEntradas(citizenId: 'sid-1', documentNumber: '99999999R');

      expect(result.single.titulo, isEmpty);
    });
  });
}
