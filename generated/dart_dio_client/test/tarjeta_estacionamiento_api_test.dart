import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for TarjetaEstacionamientoApi
void main() {
  final instance = EspacioCiudadanoApi().getTarjetaEstacionamientoApi();

  group(TarjetaEstacionamientoApi, () {
    // Obtener datos de la tarjeta de estacionamiento
    //
    // Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla La Mancha.
    //
    //Future<RespuestaFachadaInterm> obtenerDatosTarjetaEstacionamientoIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTarjetaEstacionamientoIntermediacion', () async {
      // TODO
    });
  });
}
