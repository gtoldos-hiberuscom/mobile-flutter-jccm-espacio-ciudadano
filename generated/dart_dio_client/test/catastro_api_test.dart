import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for CatastroApi
void main() {
  final instance = EspacioCiudadanoApi().getCatastroApi();

  group(CatastroApi, () {
    // Obtener datos catastrales
    //
    // Consulta los datos catastrales del ciudadano en el servicio de Catastro.
    //
    //Future<Respuesta> getDatosCatastrales(String numDocumento, DTCTROCDATREQ DTCTROCDATREQ, { String authorization }) async
    test('test getDatosCatastrales', () async {
      // TODO
    });

    // Obtener datos catastrales
    //
    // Consulta los datos catastrales del ciudadano en el servicio de Catastro.
    //
    //Future<Respuesta> getDatosCatastrales1(String numDocumento, DTCTROCDATREQ DTCTROCDATREQ, { String authorization }) async
    test('test getDatosCatastrales1', () async {
      // TODO
    });

  });
}
