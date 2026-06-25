import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for AtencionDependenciaApi
void main() {
  final instance = EspacioCiudadanoApi().getAtencionDependenciaApi();

  group(AtencionDependenciaApi, () {
    // Obtener datos de atención a la dependencia
    //
    // Consulta la situación actual de las prestaciones en ayuda a la dependencia.
    //
    //Future<RespuestaFachadaInterm> obtenerDatosAtencionDependenciaIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosAtencionDependenciaIntermediacion', () async {
      // TODO
    });
  });
}
