import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for ConsultaTitulosNoUniversitariosApi
void main() {
  final instance =
      EspacioCiudadanoApi().getConsultaTitulosNoUniversitariosApi();

  group(ConsultaTitulosNoUniversitariosApi, () {
    // Obtener títulos no universitarios
    //
    // Consulta los títulos no universitarios de un ciudadano.
    //
    //Future<RespuestaFachadaInterm> obtenerTitulosNoUniversitariosIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerTitulosNoUniversitariosIntermediacion', () async {
      // TODO
    });
  });
}
