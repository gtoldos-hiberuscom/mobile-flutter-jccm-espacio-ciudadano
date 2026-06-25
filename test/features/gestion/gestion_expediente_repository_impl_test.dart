import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_expediente_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('GestionExpedienteRepositoryImpl', () {
    test('loads expedientes when backend sends a singleton item as object', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '{"expedientes":{"item":{"numexp":"EXP-1","titulo":"Solicitud general","desconsej":"Consejería A","fechareg":"2026-06-20","estado":"ABIERTO"}}}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      final result = await repository.loadExpedientes(documentNumber: '99999999R');

      expect(result, hasLength(1));
      expect(result.single.numexp, 'EXP-1');
      expect(result.single.titulo, 'Solicitud general');
      expect(result.single.consejeria, 'Consejería A');
      expect(result.single.fechaInicio, '2026-06-20');
      expect(result.single.estado, 'ABIERTO');
      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/publicacion/misexpedientes');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{'pnumdoc': '99999999R'},
      );
    });

    test('falls back to selectbynifexp when misexpedientes returns no usable data', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '{"expedientes":{"item":[]}}',
        ),
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '{"publicacionportal":{"item":{"numexp":"EXP-2","desproc":"Expediente por NIF","desconsej":"Consejería B","fechareg":"2026-06-21","estado":"EN_TRAMITE"}}}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      final result = await repository.loadExpedientes(documentNumber: '99999999R');

      expect(result, hasLength(1));
      expect(result.single.numexp, 'EXP-2');
      expect(result.single.titulo, 'Expediente por NIF');
      expect(result.single.consejeria, 'Consejería B');
      expect(result.single.fechaInicio, '2026-06-21');
      expect(result.single.estado, 'EN_TRAMITE');
      expect(adapter.requests.map((final request) => request.path), [
        '/api/v1/publicacion/misexpedientes',
        '/api/v1/publicacion/selectbynifexp',
      ]);
      expect(adapter.requests.first.jsonBody, <String, dynamic>{'pnumdoc': '99999999R'});
      expect(adapter.requests.last.jsonBody, <String, dynamic>{'numerodocumento': '99999999R'});
    });
  });
}
