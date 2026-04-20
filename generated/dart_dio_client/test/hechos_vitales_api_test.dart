import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for HechosVitalesApi
void main() {
  final instance = EspacioCiudadanoApi().getHechosVitalesApi();

  group(HechosVitalesApi, () {
    // Actualizar lista de hechos
    //
    //Future<Respuesta> actualizarListaHechos(ListaHechosAgente listaHechosAgente, { String authorization }) async
    test('test actualizarListaHechos', () async {
      // TODO
    });

    // Eliminar preferencias por idAgente
    //
    //Future<Respuesta> eliminarPreferencias(String idAgente, { String authorization }) async
    test('test eliminarPreferencias', () async {
      // TODO
    });

    // Procesar las clausulas seleccionadas por un idAgente
    //
    //Future<Clausulas> enviarClausulas(ClausulasAgente clausulasAgente, { String authorization }) async
    test('test enviarClausulas', () async {
      // TODO
    });

    // Procesar las clausulas seleccionadas por un idAgente
    //
    //Future<Clausulas> enviarClausulas1(ClausulasAgente clausulasAgente, { String authorization }) async
    test('test enviarClausulas1', () async {
      // TODO
    });

    // Obtencion de servicios en los ultimos dias disponibles para tramitacion
    //
    //Future<Clausulas> enviarClausulas2(String idAgente, { String operacion, String size, String page, String ultimosDias, BuiltList<int> hechosvitales, String authorization }) async
    test('test enviarClausulas2', () async {
      // TODO
    });

    // Obtener servicios
    //
    //Future<ListaTramitesPorHechos> getServicios(String idAgente, { String authorization }) async
    test('test getServicios', () async {
      // TODO
    });

    // Obtener Clausulas asociadas a un Agente
    //
    //Future<Respuesta> obtenerClausulas(String idAgente, { String authorization }) async
    test('test obtenerClausulas', () async {
      // TODO
    });

    // Obtener lista de hechos vitales por idAgente
    //
    //Future<ListaHechos> obtenerListaHechosByIdAgente(String idAgente, { String authorization }) async
    test('test obtenerListaHechosByIdAgente', () async {
      // TODO
    });

  });
}
