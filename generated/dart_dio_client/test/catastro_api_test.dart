import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for CatastroApi
void main() {
  final instance = EspacioCiudadanoApi().getCatastroApi();

  group(CatastroApi, () {
    // Servicio para obtener los datos catastrales
    //
    //Future<Respuesta> getDatosCatastrales(String numDocumento, DTCTROCDATREQ dTCTROCDATREQBody, { String authorization }) async
    test('test getDatosCatastrales', () async {
      // TODO
    });
  });
}
