import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for IntermediacionApi
void main() {
  final instance = EspacioCiudadanoApi().getIntermediacionApi();

  group(IntermediacionApi, () {
    // Obtener datos de atencion a la dependencia
    //
    // Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.
    //
    //Future<Respuesta> obtenerDatosAtencionDependenciaIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosAtencionDependenciaIntermediacion', () async {
      // TODO
    });

    // Obtener datos de discapacidad por intermediación
    //
    // Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.
    //
    //Future<Respuesta> obtenerDatosDiscapacidadIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosDiscapacidadIntermediacion', () async {
      // TODO
    });

    // Obtener datos de familia numerosa por intermediación
    //
    // Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.
    //
    //Future<Respuesta> obtenerDatosFamiliaNumerosaIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosaIntermediacion', () async {
      // TODO
    });

    // Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
    //
    // Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla-La Mancha. La respuesta incluye el identificador de la tarjeta, modalidad (Persona con Discapacidad o Movilidad Reducida), fechas de vigencia de inicio y fin, y demás datos asociados a la tarjeta.
    //
    //Future<Respuesta> obtenerDatosTarjetaEstacionamientoIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTarjetaEstacionamientoIntermediacion', () async {
      // TODO
    });

    // Obtener datos del último balneario adjudicado del programa de termalismo
    //
    // Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.
    //
    //Future<Respuesta> obtenerDatosTermalismoIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTermalismoIntermediacion', () async {
      // TODO
    });

    // Obtener ofertas de empleo inscritas
    //
    // Consulta las ofertas de empleo en las que el ciudadano figura inscrito. La respuesta se muestra con la estructura completa Respuesta y el listado de ofertas en datosespecificos.
    //
    //Future<Respuesta> obtenerOfertasEmpleoInscritas(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerOfertasEmpleoInscritas', () async {
      // TODO
    });

    // Obtener títulos no universitarios del ciudadano
    //
    // Consulta los títulos no universitarios (Ciclos Formativos de Grado Superior y Grado Medio) registrados para el ciudadano. La respuesta incluye información detallada de cada título obtenido como denominación, tipo de ciclo (CFGS/CFGM), centro educativo, localidad y fechas de obtención y expedición del título.
    //
    //Future<Respuesta> obtenerTitulosNoUniversitariosIntermediacion(BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerTitulosNoUniversitariosIntermediacion', () async {
      // TODO
    });

  });
}
