import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for CcaaApi
void main() {
  final instance = EspacioCiudadanoApi().getCcaaApi();

  group(CcaaApi, () {
    // Servicio para obtener los datos de familia numerosa
    //
    //Future<DTMINHAFPCCCAFNRES> getDatosFamiliaNumerosa(String numDocumento, DTMINHAFPCCCAFNREQ dTMINHAFPCCCAFNREQBody, { String authorization }) async
    test('test getDatosFamiliaNumerosa', () async {
      // TODO
    });

  });
}
