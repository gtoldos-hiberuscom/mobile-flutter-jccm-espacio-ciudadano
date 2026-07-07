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
    //Future<Respuesta> getIniProc(DTProcedimiento dTProcedimiento) async
    test('test getIniProc', () async {
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
    //Future<RESULTADOPROCEDIMIENTO> miSubirAdjuntoSinFirmaOperation(ADJUNTO ADJUNTO) async
    test('test miSubirAdjuntoSinFirmaOperation', () async {
      // TODO
    });

  });
}
