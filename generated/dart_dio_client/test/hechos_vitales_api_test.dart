import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for HechosVitalesApi
void main() {
  final instance = EspacioCiudadanoApi().getHechosVitalesApi();

  group(HechosVitalesApi, () {
    // Actualizar las cláusulas de consentimiento de un agente
    //
    // Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.
    //
    //Future<Respuesta> actualizarClausulas(String idAgente, ClausulasAgente clausulasAgente, { String authorization }) async
    test('test actualizarClausulas', () async {
      // TODO
    });

    // Actualizar las cláusulas de consentimiento de un agente
    //
    // Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.
    //
    //Future<Respuesta> actualizarClausulas1(ClausulasAgente clausulasAgente, { String authorization }) async
    test('test actualizarClausulas1', () async {
      // TODO
    });

    // Actualizar los hechos vitales seleccionados por un agente
    //
    // Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado=true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.
    //
    //Future<Respuesta> actualizarListaHechos(String idAgente, ListaHechosAgente listaHechosAgente, { String authorization }) async
    test('test actualizarListaHechos', () async {
      // TODO
    });

    // Actualizar los hechos vitales seleccionados por un agente
    //
    // Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado=true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.
    //
    //Future<Respuesta> actualizarListaHechos1(ListaHechosAgente listaHechosAgente, { String authorization }) async
    test('test actualizarListaHechos1', () async {
      // TODO
    });

    // Eliminar preferencias y configuración de hechos vitales de un agente
    //
    // Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.
    //
    //Future<Respuesta> eliminarPreferencias(String idAgente, { String authorization }) async
    test('test eliminarPreferencias', () async {
      // TODO
    });

    // Eliminar preferencias y configuración de hechos vitales de un agente
    //
    // Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.
    //
    //Future<Respuesta> eliminarPreferencias1(String idAgente, { String authorization }) async
    test('test eliminarPreferencias1', () async {
      // TODO
    });

    // Dar de alta las cláusulas de consentimiento de un agente
    //
    // Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.
    //
    //Future<Respuesta> enviarClausulas(String idAgente, ClausulasAgente clausulasAgente, { String authorization }) async
    test('test enviarClausulas', () async {
      // TODO
    });

    // Dar de alta las cláusulas de consentimiento de un agente
    //
    // Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.
    //
    //Future<Respuesta> enviarClausulas1(ClausulasAgente clausulasAgente, { String authorization }) async
    test('test enviarClausulas1', () async {
      // TODO
    });

    // Obtener servicios recomendados agrupados por hecho vital
    //
    // Recupera los trámites y servicios disponibles para el ciudadano agrupados por cada hecho vital que tiene seleccionado. Por cada hecho vital activo del agente, devuelve la lista de trámites relacionados con información del trámite, unidad orgánica responsable y periodo de presentación.
    //
    //Future<Respuesta> getServicios(String idAgente, { String authorization }) async
    test('test getServicios', () async {
      // TODO
    });

    // Obtener servicios segmentados por hechos vitales
    //
    // Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.
    //
    //Future<Respuesta> getServiciosSegmentados(String idAgente, { String operacion, String size, String page, String ultimosDias, BuiltList<int> hechosvitales, String authorization }) async
    test('test getServiciosSegmentados', () async {
      // TODO
    });

    // Obtener servicios segmentados por hechos vitales
    //
    // Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.
    //
    //Future<Respuesta> getServiciosSegmentados1(String idAgente, { String operacion, String size, String page, String ultimosDias, BuiltList<int> hechosvitales, String authorization }) async
    test('test getServiciosSegmentados1', () async {
      // TODO
    });

    // Obtener cláusulas de consentimiento asociadas a un agente
    //
    // Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.
    //
    //Future<Respuesta> obtenerClausulasPorAgente(String idAgente, { String authorization }) async
    test('test obtenerClausulasPorAgente', () async {
      // TODO
    });

    // Obtener cláusulas de consentimiento asociadas a un agente
    //
    // Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.
    //
    //Future<Respuesta> obtenerClausulasPorAgente1(String idAgente, { String authorization }) async
    test('test obtenerClausulasPorAgente1', () async {
      // TODO
    });

    // Obtener lista de hechos vitales por agente
    //
    // Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.
    //
    //Future<Respuesta> obtenerListaHechosByIdAgente(String idAgente, { String authorization }) async
    test('test obtenerListaHechosByIdAgente', () async {
      // TODO
    });

    // Obtener lista de hechos vitales por agente
    //
    // Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.
    //
    //Future<Respuesta> obtenerListaHechosByIdAgente1(String idAgente, { String authorization }) async
    test('test obtenerListaHechosByIdAgente1', () async {
      // TODO
    });

  });
}
