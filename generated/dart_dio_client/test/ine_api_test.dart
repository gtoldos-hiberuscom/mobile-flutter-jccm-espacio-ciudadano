import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for IneApi
void main() {
  final instance = EspacioCiudadanoApi().getIneApi();

  group(IneApi, () {
    // Servicio para obtener los datos de residencia
    //
    //Future<DTINECDRFRES> getDatosResidencia(String numDocumento, DTINECDRFREQ dTINECDRFREQBody, { String authorization }) async
    test('test getDatosResidencia', () async {
      // TODO
    });
  });
}
