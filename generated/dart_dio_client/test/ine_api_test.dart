import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for IneApi
void main() {
  final instance = EspacioCiudadanoApi().getIneApi();

  group(IneApi, () {
    // Obtener datos de residencia (INE)
    //
    // Consulta los datos de residencia del ciudadano en el servicio INE. El documento del cuerpo se valida frente al token y al parámetro de ruta.
    //
    //Future<Respuesta> getDatosResidencia(String numDocumento, DTINECDRFREQ DTINECDRFREQ, { String authorization }) async
    test('test getDatosResidencia', () async {
      // TODO
    });

    // Obtener datos de residencia (INE)
    //
    // Consulta los datos de residencia del ciudadano en el servicio INE. El documento del cuerpo se valida frente al token y al parámetro de ruta.
    //
    //Future<Respuesta> getDatosResidencia1(String numDocumento, DTINECDRFREQ DTINECDRFREQ, { String authorization }) async
    test('test getDatosResidencia1', () async {
      // TODO
    });

  });
}
