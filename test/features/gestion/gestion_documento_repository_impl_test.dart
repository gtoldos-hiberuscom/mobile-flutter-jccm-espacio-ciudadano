import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente_aportacion_datos.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_documento_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('GestionDocumentoRepositoryImpl', () {
    test('treats a 200 wrapped in the generic Respuesta envelope as success and returns the hash', () async {
      // Confirmado contra backend real de UAT: este endpoint responde 200
      // con el sobre genérico `Respuesta` ({body, timestamp,
      // mensaje-respuesta, codigo-respuesta, info-error}), no con la forma
      // `RESULTADOPROCEDIMIENTO` que documenta el swagger — la
      // deserialización tipada del cliente generado falla pese a que la
      // petición fue correcta. `body` es el hash del documento.
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

      final hash = await repository.subirDocumentoSinFirma(
        citizenId: 'sid-1',
        documentNumber: '03874761C',
        idUnico: '03874761C_1700000000000',
        tipoProcedimiento: '020',
        nombreFichero: 'documento.pdf',
        bytes: bytes,
      );

      expect(hash, '2AACB86A2DDD8C8A41E9C51C4B0207732B10FDBB231D06D086D5A225D21B61B');
      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/sid-1/expedientes/03874761C_1700000000000/ficheros');
      expect(
        adapter.requests.single.jsonBody,
        <String, dynamic>{
          'idunico': '03874761C_1700000000000',
          'nifcif': '03874761C',
          'nombre': 'documento.pdf',
          'tipoprocedimiento': '020',
          'data': base64Encode(bytes),
          // Metadatos requeridos según api-rest-doc.html, con los valores
          // literales de su ejemplo oficial; `tipodoc` derivado de la
          // extensión del fichero.
          'categoria': '501',
          'tdoc': 'C',
          'origen': '0',
          'idprop': '03874761C',
          'tipodoc': 'PDF',
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
          citizenId: 'sid-1',
          documentNumber: '03874761C',
          idUnico: '03874761C_1700000000000',
          tipoProcedimiento: '020',
          nombreFichero: 'documento.pdf',
          bytes: Uint8List.fromList('x'.codeUnits),
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('rethrows a DioExceptionType.cancel when the CancelToken is already cancelled', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 200, body: '{}'),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionDocumentoRepositoryImpl(dio: dio);
      final cancelToken = CancelToken()..cancel();

      await expectLater(
        repository.subirDocumentoSinFirma(
          citizenId: 'sid-1',
          documentNumber: '03874761C',
          idUnico: '03874761C_1700000000000',
          tipoProcedimiento: '020',
          nombreFichero: 'documento.pdf',
          bytes: Uint8List.fromList('x'.codeUnits),
          cancelToken: cancelToken,
        ),
        throwsA(isA<DioException>().having((final e) => e.type, 'type', DioExceptionType.cancel)),
      );
    });

    test('iniciarProcedimiento parses the confirmed idunico and pregistro fields on estado OK', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '''
{
  "body": {
    "idunico": "03874761C_171447919011026",
    "mensaje": "El procedimiento se ha iniciado correctamente",
    "estado": "OK",
    "idregistro": "",
    "datosregistro": {
      "pregistro": {
        "asuid": "SIM2",
        "descrip": "desc",
        "uniorg": "012848",
        "numdoc": "03874761C",
        "nombre": "Juan",
        "apellido1": "García",
        "apellido2": "López"
      }
    }
  },
  "timestamp": "2024-12-13T10:03:40.965876",
  "mensaje-respuesta": "Respuesta correcta",
  "codigo-respuesta": "200.00",
  "info-error": null
}
''',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionDocumentoRepositoryImpl(dio: dio);
      const expediente = Expediente(
        numexp: 'EXP-1',
        titulo: 't',
        consejeria: 'c',
        tipoproc: '020',
        datosAportacion: ExpedienteAportacionDatos(
          uniorg: '012848',
          consej: '001952',
          registro: '123456/2024',
          fechareg: '2024-10-22',
        ),
      );

      final resultado = await repository.iniciarProcedimiento(
        citizenId: 'sid-1',
        idUnico: '03874761C_171447919011019',
        documentNumber: '03874761C',
        expediente: expediente,
      );

      expect(resultado.idunico, '03874761C_171447919011026');
      expect(resultado.estado, 'OK');
      expect(resultado.uniorg, '012848');
      expect(resultado.nombre, 'Juan');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/sid-1/expedientes/03874761C_171447919011019/ficheros/iniciar');
      // Confirmado contra backend real de UAT: enviar `registro` vacío
      // ({fecha: "", noregistro: ""}) para un expediente que ya tiene un
      // registro de entrada real provocó un 500 del servidor — debe
      // reutilizarse el registro/fecha ya existentes del expediente.
      final requestBody = adapter.requests.single.jsonBody as Map<String, dynamic>?;
      expect(requestBody?['registro'], <String, dynamic>{'fecha': '2024-10-22', 'noregistro': '123456/2024'});
      // Bypass del cliente generado: `datosprocedimiento` se envía como
      // `null` literal (no `{}`) — el modelo generado no puede representar
      // esto, de ahí la construcción manual del body. Confirmado contra
      // backend real de UAT: enviar `{}` en su lugar también devolvió 500.
      expect(requestBody?.containsKey('datosprocedimiento'), isTrue);
      expect(requestBody?['datosprocedimiento'], isNull);
    });

    test('iniciarProcedimiento throws when estado is not OK', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: '''
{
  "body": {"idunico": "x", "mensaje": "fallo", "estado": "KO", "idregistro": "", "datosregistro": {"pregistro": {}}},
  "timestamp": "2024-12-13T10:03:40.965876",
  "mensaje-respuesta": "Respuesta correcta",
  "codigo-respuesta": "200.00",
  "info-error": null
}
''',
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionDocumentoRepositoryImpl(dio: dio);
      const expediente = Expediente(numexp: 'EXP-1', titulo: 't', consejeria: 'c');

      await expectLater(
        repository.iniciarProcedimiento(citizenId: 'sid-1', idUnico: 'x', documentNumber: '03874761C', expediente: expediente),
        throwsA(isA<StateError>()),
      );
    });

    test('registrarFicheros returns the raw PDF bytes', () async {
      const pdfContent = '%PDF-1.4 fake justificante content';
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 200, body: pdfContent, contentType: 'application/pdf'),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = GestionDocumentoRepositoryImpl(dio: dio);
      const expediente = Expediente(
        numexp: 'EXP-1',
        titulo: 't',
        consejeria: 'c',
        tipoproc: '020',
        oficinaTramitadora: 'UNIDAD DE TRAMITACIÓN',
        datosAportacion: ExpedienteAportacionDatos(desasunto: 'Solicitud de ayudas', fechareg: '2024-10-22'),
      );
      const inicio = InicioProcedimientoResultado(
        idunico: '03874761C_171447919011026',
        estado: 'OK',
        asuid: 'SIM2',
        descrip: 'desc',
        uniorg: '012848',
        numdoc: '03874761C',
        nombre: 'Juan',
        apellido1: 'García',
        apellido2: 'López',
      );

      final bytes = await repository.registrarFicheros(
        citizenId: 'sid-1',
        documentNumber: '03874761C',
        expediente: expediente,
        inicio: inicio,
        documentos: const [(nombre: 'documento.pdf', hash: 'abc123', tamanioBytes: 81920)],
      );

      expect(utf8.decode(bytes), pdfContent);
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/sid-1/expedientes/03874761C_171447919011026/ficheros/registrar');
      final requestBody = adapter.requests.single.jsonBody as Map<String, dynamic>?;
      final confirmarProcedimiento = requestBody?['confirmarProcedimiento'] as Map<String, dynamic>?;
      final procedimiento = confirmarProcedimiento?['procedimiento'] as Map<String, dynamic>?;
      // Mismo bypass que en inicproc: `datosprocedimiento` se envía como
      // `null` literal, no `{}` — confirmado necesario contra backend real
      // de UAT (el mismo 500 que sufrió inicproc antes del bypass).
      expect(procedimiento?.containsKey('datosprocedimiento'), isTrue);
      expect(procedimiento?['datosprocedimiento'], isNull);
      expect(procedimiento?['idunico'], '03874761C_171447919011026');
      // Campos documentados en el ejemplo "Datos Entrada Registrar Fichero"
      // del manual de integración que la implementación anterior omitía por
      // completo — candidatos al 500 sin detalle observado contra UAT real.
      expect(procedimiento?['datospago'], <String, dynamic>{});
      expect(procedimiento?['firma'], '');
      // Ejemplo literal del manual de integración para este endpoint:
      // `registro`/`identificacionrep` vacíos, a diferencia de inicproc.
      expect(procedimiento?['registro'], <String, dynamic>{});
      expect(procedimiento?['identificacionrep'], <String, dynamic>{});
      final documentos = requestBody?['documentos'] as List<dynamic>?;
      expect(documentos?.single, <String, dynamic>{
        'nombre': 'documento.pdf',
        'algoritmo': 'SHA-512',
        'hash': 'abc123',
        'fileSize': '80kb',
      });
      // Campos de nivel raíz (hermanos de `confirmarProcedimiento`) que
      // api-rest-doc.html documenta como `required` para este endpoint y
      // que las 4 iteraciones anteriores del 500 omitían por completo.
      expect(requestBody?['oficinaTramitadora'], 'UNIDAD DE TRAMITACIÓN');
      expect(requestBody?['procedimiento'], 'Solicitud de ayudas');
      expect(requestBody?['fechaInicioTramitacion'], '2024-10-22');
      final hoy = DateTime.now();
      final hoyIso = '${hoy.year.toString().padLeft(4, '0')}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
      expect(requestBody?['fechaCierreTramitacion'], hoyIso);
      expect(requestBody?['estadoTramitacion'], 'En curso');
      // Claves raíz de los ejemplos oficiales que ninguna iteración
      // anterior enviaba (6ª iteración del 500 sin detalle en UAT).
      expect(requestBody?['consejeriaTramitadora'], 'c');
      expect(requestBody?['xmlRegistro'], <String, dynamic>{'xmlClave': ''});
      expect(requestBody?['esPorContraste'], false);
      expect(requestBody?['datosRepresentante'], <String, dynamic>{
        'nombre': '',
        'apellido1': '',
        'apellido2': '',
        'nifcif': '',
        'tipodoc': '',
      });
    });
  });
}
