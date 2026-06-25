import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for TermalismoApi
void main() {
  final instance = EspacioCiudadanoApi().getTermalismoApi();

  group(TermalismoApi, () {
    // Obtener datos de termalismo
    //
    // Consulta el último balneario adjudicado del programa de termalismo.
    //
    //Future<RespuestaFachadaInterm> obtenerDatosTermalismoIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTermalismoIntermediacion', () async {
      // TODO
    });
  });
}
