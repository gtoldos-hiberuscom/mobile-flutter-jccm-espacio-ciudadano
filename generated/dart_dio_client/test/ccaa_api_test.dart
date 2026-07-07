import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for CcaaApi
void main() {
  final instance = EspacioCiudadanoApi().getCcaaApi();

  group(CcaaApi, () {
    // Obtener datos de familia numerosa
    //
    // Consulta los datos de familia numerosa del ciudadano en el servicio CCAA.
    //
    //Future<Respuesta> getDatosFamiliaNumerosa(String numDocumento, DTMINHAFPCCCAFNREQ DTMINHAFPCCCAFNREQ, { String authorization }) async
    test('test getDatosFamiliaNumerosa', () async {
      // TODO
    });

  });
}
