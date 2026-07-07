import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for AgendaApi
void main() {
  final instance = EspacioCiudadanoApi().getAgendaApi();

  group(AgendaApi, () {
    // Obtener eventos de la Agenda
    //
    // Obtiene los eventos de agenda de un agente para un periodo determinado.
    //
    //Future<Respuesta> obtenerEventosAgenda(String idAgente, String periodo, { String authorization }) async
    test('test obtenerEventosAgenda', () async {
      // TODO
    });

    // Refrescar eventos de la Agenda por idAgente
    //
    // Refresca los eventos de agenda del agente y devuelve el resumen del proceso.
    //
    //Future<Respuesta> refrescarAgendaEvents(String idAgente, { String authorization }) async
    test('test refrescarAgendaEvents', () async {
      // TODO
    });

  });
}
