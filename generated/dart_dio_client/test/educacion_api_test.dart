import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for EducacionApi
void main() {
  final instance = EspacioCiudadanoApi().getEducacionApi();

  group(EducacionApi, () {
    // Obtener titulos no universitarios
    //
    // Consulta los titulos no universitarios del ciudadano en el servicio de Educacion.
    //
    //Future<Respuesta> getTitulosNoUniversitarios(String numDocumento, DTEDUTNUREQ DTEDUTNUREQ, { String authorization }) async
    test('test getTitulosNoUniversitarios', () async {
      // TODO
    });

    // Obtener titulos universitarios
    //
    // Consulta los titulos universitarios del ciudadano en el servicio de Educacion.
    //
    //Future<Respuesta> getTitulosUniversitarios(String numDocumento, DTEDUTUOREQ DTEDUTUOREQ, { String authorization }) async
    test('test getTitulosUniversitarios', () async {
      // TODO
    });

  });
}
