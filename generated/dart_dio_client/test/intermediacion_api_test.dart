import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for IntermediacionApi
void main() {
  final instance = EspacioCiudadanoApi().getIntermediacionApi();

  group(IntermediacionApi, () {
    // Obtener datos de atención a la dependencia
    //
    // Consulta la situación actual de las prestaciones en ayuda a la dependencia.
    //
    //Future<RespuestaFachadaInterm> obtenerDatosAtencionDependenciaIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosAtencionDependenciaIntermediacion', () async {
      // TODO
    });

    // Obtener datos del carné de discapacidad
    //
    //Future<RespuestaFachadaInterm> obtenerDatosDiscapacidadIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosDiscapacidadIntermediacion', () async {
      // TODO
    });

    // Obtener datos del carné de familia numerosa
    //
    //Future<RespuestaFachadaInterm> obtenerDatosFamiliaNumerosaIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosaIntermediacion', () async {
      // TODO
    });

    // Obtener datos de la tarjeta de estacionamiento
    //
    // Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla La Mancha.
    //
    //Future<RespuestaFachadaInterm> obtenerDatosTarjetaEstacionamientoIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTarjetaEstacionamientoIntermediacion', () async {
      // TODO
    });

    // Obtener datos de termalismo
    //
    // Consulta el último balneario adjudicado del programa de termalismo.
    //
    //Future<RespuestaFachadaInterm> obtenerDatosTermalismoIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTermalismoIntermediacion', () async {
      // TODO
    });

    // Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.
    //
    // Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.
    //
    //Future<RespuestaFachadaInterm> obtenerOfertasEmpleoInscritas(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerOfertasEmpleoInscritas', () async {
      // TODO
    });

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
