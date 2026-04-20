import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for IntermediacionApi
void main() {
  final instance = EspacioCiudadanoApi().getIntermediacionApi();

  group(IntermediacionApi, () {
    // Obtener datos del carné de familia numerosa
    //
    //Future<String> obtenerDatosFamiliaNumerosa(RequestFachadaDiscapacidadInterm requestFachadaDiscapacidadInterm, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosa', () async {
      // TODO
    });

    //Future<RespuestaRespuestaFachadaFamiliaNumerosaInterm> obtenerDatosFamiliaNumerosaIntermediacion(RequestFachadaFamiliaNumerosaInterm requestFachadaFamiliaNumerosaInterm, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosaIntermediacion', () async {
      // TODO
    });

  });
}
