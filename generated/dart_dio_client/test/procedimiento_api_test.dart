import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for ProcedimientoApi
void main() {
  final instance = EspacioCiudadanoApi().getProcedimientoApi();

  group(ProcedimientoApi, () {
    // Servicio que permite generar el hash de un documento codificado en base64 sin firma
    //
    //Future<RESULTADOPROCEDIMIENTO> hashAdjuntoaOperation(ADJUNTO ADJUNTO) async
    test('test hashAdjuntoaOperation', () async {
      // TODO
    });

    // Servicio para realizar la escritura de un procedimiento en cesar
    //
    //Future<RESULTADOPROCEDIMIENTO> miConfirmarProcOperation(CONFIRMARPROCEDIMIENTO CONFIRMARPROCEDIMIENTO) async
    test('test miConfirmarProcOperation', () async {
      // TODO
    });

    // Servicio para realizar la validacion de un procedimiento en cesar
    //
    //Future<RESULTADOPROCEDIMIENTO> miIniProcOperation(DTProcedimiento dTProcedimiento) async
    test('test miIniProcOperation', () async {
      // TODO
    });

    // Consultar la respuesta de un expediente en cesar
    //
    //Future<ZCSRMOBTRESPUESTAEXPResponse> miObtenerRespuestaOperation(ZCSRMOBTRESPUESTAEXP ZCSRMOBTRESPUESTAEXP) async
    test('test miObtenerRespuestaOperation', () async {
      // TODO
    });

    // Servicio que permite subir al buzon de tramitacion un documento codificado en base64 firmado
    //
    //Future<RESULTADOPROCEDIMIENTO> miSubirAdjuntoOperation(ADJUNTO ADJUNTO) async
    test('test miSubirAdjuntoOperation', () async {
      // TODO
    });

    // Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma
    //
    //Future<RESULTADOPROCEDIMIENTO> miSubirAdjuntoSinFirmaOperation(ADJUNTO ADJUNTO) async
    test('test miSubirAdjuntoSinFirmaOperation', () async {
      // TODO
    });
  });
}
