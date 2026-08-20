import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for ProcedimientoApi
void main() {
  final instance = EspacioCiudadanoApi().getProcedimientoApi();

  group(ProcedimientoApi, () {
    // Iniciar procedimiento administrativo
    //
    // Inicia un nuevo procedimiento administrativo en el sistema CESAR. Valida los datos del procedimiento y crea el registro correspondiente.
    //
    //Future<Respuesta> getIniProc(String idAgente, String idExpediente, DTProcedimiento dTProcedimiento) async
    test('test getIniProc', () async {
      // TODO
    });

    // Iniciar procedimiento administrativo
    //
    // Inicia un nuevo procedimiento administrativo en el sistema CESAR. Valida los datos del procedimiento y crea el registro correspondiente.
    //
    //Future<Respuesta> getIniProc1(String idAgente, String idExpediente, DTProcedimiento dTProcedimiento) async
    test('test getIniProc1', () async {
      // TODO
    });

    // Servicio que permite generar el hash de un documento codificado en base64 sin firma
    //
    //Future<RESULTADOPROCEDIMIENTO> hashAdjuntoaOperation(ADJUNTO ADJUNTO) async
    test('test hashAdjuntoaOperation', () async {
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
    //Future<RESULTADOPROCEDIMIENTO> miSubirAdjuntoSinFirmaOperation(String idAgente, String idExpediente, ADJUNTO ADJUNTO) async
    test('test miSubirAdjuntoSinFirmaOperation', () async {
      // TODO
    });

    // Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma
    //
    //Future<RESULTADOPROCEDIMIENTO> miSubirAdjuntoSinFirmaOperation1(String idAgente, String idExpediente, ADJUNTO ADJUNTO) async
    test('test miSubirAdjuntoSinFirmaOperation1', () async {
      // TODO
    });

  });
}
