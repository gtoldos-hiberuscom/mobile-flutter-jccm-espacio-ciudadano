import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_documento_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('GestionDocumentoRepositoryImpl', () {
    test('treats a 200 wrapped in the generic Respuesta envelope as success', () async {
      // Confirmado contra backend real de UAT: este endpoint responde 200
      // con el sobre genérico `Respuesta` ({body, timestamp,
      // mensaje-respuesta, codigo-respuesta, info-error}), no con la forma
      // `RESULTADOPROCEDIMIENTO` que documenta el swagger — la
      // deserialización tipada del cliente generado falla pese a que la
      // petición fue correcta.
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '''
{
  "body": "2AACB86A2DDD8C8A41E9C51C4B0207732B10FDBB231D06D086D5A225D21B61B",
  "timestamp": "2026-07-08T13:12:27.63982",
  "mensaje-respuesta": "Respuesta correcta",
  "codigo-respuesta": "200.00",
  "info-error": null
}
''',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionDocumentoRepositoryImpl(dio: dio);
      final bytes = Uint8List.fromList('contenido de prueba'.codeUnits);

      await repository.subirDocumentoSinFirma(
        documentNumber: '03874761C',
        idUnico: '03874761C_1700000000000',
        tipoProcedimiento: '020',
        nombreFichero: 'documento.pdf',
        bytes: bytes,
      );

      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/procedimiento/subiradjuntosinfirma');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{
          'idunico': '03874761C_1700000000000',
          'nifcif': '03874761C',
          'nombre': 'documento.pdf',
          'tipoprocedimiento': '020',
          'data': base64Encode(bytes),
        },
      );
    });

    test('rethrows when subiradjuntosinfirma returns 400', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 400,
          body: '{"status":400,"error":"Bad Request"}',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionDocumentoRepositoryImpl(dio: dio);

      await expectLater(
        repository.subirDocumentoSinFirma(
          documentNumber: '03874761C',
          idUnico: '03874761C_1700000000000',
          tipoProcedimiento: '020',
          nombreFichero: 'documento.pdf',
          bytes: Uint8List.fromList('x'.codeUnits),
        ),
        throwsA(isA<DioException>()),
      );
    });
  });
}
