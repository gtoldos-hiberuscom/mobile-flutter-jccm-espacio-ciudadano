import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for EducacionApi
void main() {
  final instance = EspacioCiudadanoApi().getEducacionApi();

  group(EducacionApi, () {
    // Servicio para obtener los títulos no universitarios
    //
    //Future<DTEDUTNURES> getTitulosNoUniversitarios(String numDocumento, DTEDUTNUREQ dTEDUTNUREQBody, { String authorization }) async
    test('test getTitulosNoUniversitarios', () async {
      // TODO
    });

    // Servicio para obtener los títulos universitarios
    //
    //Future<DTEDUTUORES> getTitulosUniversitarios(String numDocumento, DTEDUTUOREQ dTEDUTUOREQBody, { String authorization }) async
    test('test getTitulosUniversitarios', () async {
      // TODO
    });

  });
}
