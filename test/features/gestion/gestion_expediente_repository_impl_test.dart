import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_expediente_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('GestionExpedienteRepositoryImpl', () {
    test('loads expedientes from selectbynif when backend sends a singleton item as object', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          contentType: Headers.textPlainContentType,
          body: '{"publicacionportal":{"item":{"numexp":"EXP-1","titulo":"Solicitud general","desconsej":"Consejería A","fechareg":"2026-06-20","estado":"ABIERTO"}}}',
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
      expect(adapter.requests.single.path, '/api/v1/publicacion/selectbynif');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{
          'numerodocumento': '99999999R',
          'tipodoc': 'NIF',
        },
      );
    });

    test('loads expedientes when backend wraps the response inside body', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '''
{
  "body": {
    "isubrc": 0,
    "publicacionportal": {
      "item": [
        {
          "numexp": "WMEQ/2026/000002",
          "titulo": "",
          "desproc": "MODIFICACIÓN DE DECLARACIONES",
          "desconsej": "CONSEJERÍA DE AGRICULTURA",
          "fechareg": "2026-06-18",
          "estado": "01"
        }
      ]
    },
    "resultado": "Correcto"
  },
  "codigo-respuesta": "200.00"
}
''',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      final result = await repository.loadExpedientes(documentNumber: '99999999R');

      expect(result, hasLength(1));
      expect(result.single.numexp, 'WMEQ/2026/000002');
      expect(result.single.titulo, 'MODIFICACIÓN DE DECLARACIONES');
      expect(result.single.consejeria, 'CONSEJERÍA DE AGRICULTURA');
      expect(result.single.fechaInicio, '2026-06-18');
      expect(result.single.estado, '01');
    });

    test('returns an empty list when selectbynif returns 404', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 404,
          body: '{"status":404,"error":"Not Found"}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      final result = await repository.loadExpedientes(documentNumber: '99999999R');

      expect(result, isEmpty);
      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.path, '/api/v1/publicacion/selectbynif');
    });

    test('loads expediente detail from selectbynumexp mapping the flat publicacionportal object', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '''
{
  "body": {
    "adjuntar": "X",
    "isubrc": 0,
    "publicacionportal": {
      "numexp": "S020/2024/0001-PR",
      "titulo": "",
      "desproc": "SOLICITUD DE AYUDAS PARA EL FOMENTO DE LA ACUICULTURA",
      "desconsej": "CONSEJERÍA DE DESARROLLO SOSTENIBLE",
      "desuniorg": "",
      "fechaini": "2024-10-22",
      "fechafin": "0000-00-00",
      "estado": "01",
      "descrip": "SOLICITUD ENTRADA EN ÓRGANO COMPETENTE"
    },
    "resultado": "Correcto"
  },
  "codigo-respuesta": "200.00"
}
''',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      final result = await repository.loadExpedienteDetail(
        documentNumber: '03874761C',
        numexp: 'S020/2024/0001-PR',
      );

      expect(result.numexp, 'S020/2024/0001-PR');
      expect(result.titulo, 'SOLICITUD ENTRADA EN ÓRGANO COMPETENTE');
      expect(result.consejeria, 'CONSEJERÍA DE DESARROLLO SOSTENIBLE');
      expect(result.oficinaTramitadora, isNull);
      expect(result.fechaInicio, '2024-10-22');
      expect(result.fechaFin, isNull);
      expect(result.estado, 'SOLICITUD ENTRADA EN ÓRGANO COMPETENTE');
      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/publicacion/selectbynumexp');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{
          'pnumdoc': '03874761C',
          'pnumexp': 'S020/2024/0001-PR',
          'ptipodoc': 'NIF',
        },
      );
    });

    test('rethrows when selectbynumexp returns 404', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 404,
          body: '{"status":404,"error":"Not Found"}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadExpedienteDetail(documentNumber: '99999999R', numexp: 'EXP-1'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
