import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for SepeApi
void main() {
  final instance = EspacioCiudadanoApi().getSepeApi();

  group(SepeApi, () {
    // Servicio para obtener los datos de demandante de empleo a Fecha Actual
    //
    //Future<DTSEPESVDIDEFARES> getDemandanteEmpleoFechaActual(String numDocumento, DTSEPESVDIDEFAREQ dTSEPESVDIDEFAREQBody, { String authorization }) async
    test('test getDemandanteEmpleoFechaActual', () async {
      // TODO
    });

  });
}
