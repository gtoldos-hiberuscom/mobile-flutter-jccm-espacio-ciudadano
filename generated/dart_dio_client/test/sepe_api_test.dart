import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for SepeApi
void main() {
  final instance = EspacioCiudadanoApi().getSepeApi();

  group(SepeApi, () {
    // Consultar situacion de demandante de empleo a fecha actual
    //
    // Consulta en el servicio SEPE si el ciudadano figura como demandante de empleo en la fecha actual y devuelve el resultado de la tramitacion.
    //
    //Future<Respuesta> getDemandanteEmpleoFechaActual(String numDocumento, DTSEPESVDIDEFAREQ DTSEPESVDIDEFAREQ, { String authorization }) async
    test('test getDemandanteEmpleoFechaActual', () async {
      // TODO
    });

  });
}
