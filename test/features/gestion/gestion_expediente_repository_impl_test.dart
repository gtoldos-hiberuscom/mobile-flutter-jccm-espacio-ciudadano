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
      "tipoproc": "020",
      "desproc": "SOLICITUD DE AYUDAS PARA EL FOMENTO DE LA ACUICULTURA",
      "desconsej": "CONSEJERÍA DE DESARROLLO SOSTENIBLE",
      "desuniorg": "",
      "fechaini": "2024-10-22",
      "fechafin": "0000-00-00",
      "estado": "01",
      "descrip": "SOLICITUD ENTRADA EN ÓRGANO COMPETENTE",
      "uniorg": "012848",
      "consej": "001952",
      "bland": "45",
      "asunto": "S020",
      "desasunto": "Solicitud de ayudas",
      "source": "TRAM",
      "nombre": "Juan",
      "apellido1": "García",
      "apellido2": "López",
      "numdoc": "03874761C",
      "codpos": "45000",
      "calle": "Calle Mayor",
      "ncalle": "1",
      "tlfno": "600000000",
      "bezei": "Toledo",
      "registro": "123456/2024",
      "fechareg": "2024-10-22"
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
      expect(result.tipoproc, '020');
      expect(result.datosAportacion?.uniorg, '012848');
      expect(result.datosAportacion?.consej, '001952');
      expect(result.datosAportacion?.bland, '45');
      expect(result.datosAportacion?.asunto, 'S020');
      expect(result.datosAportacion?.desasunto, 'Solicitud de ayudas');
      expect(result.datosAportacion?.source, 'TRAM');
      expect(result.datosAportacion?.registro, '123456/2024');
      expect(result.datosAportacion?.fechareg, '2024-10-22');
      expect(result.datosAportacion?.nombre, 'Juan');
      expect(result.datosAportacion?.apellido1, 'García');
      expect(result.datosAportacion?.apellido2, 'López');
      expect(result.datosAportacion?.numdoc, '03874761C');
      expect(result.datosAportacion?.codpos, '45000');
      expect(result.datosAportacion?.calle, 'Calle Mayor');
      expect(result.datosAportacion?.ncalle, '1');
      expect(result.datosAportacion?.tlfno, '600000000');
      expect(result.datosAportacion?.bezei, 'Toledo');
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
