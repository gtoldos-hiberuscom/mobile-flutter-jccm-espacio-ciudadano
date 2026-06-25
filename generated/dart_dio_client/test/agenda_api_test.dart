import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for AgendaApi
void main() {
  final instance = EspacioCiudadanoApi().getAgendaApi();

  group(AgendaApi, () {
    // Obtener eventos de la Agenda
    //
    //Future<String> obtenerEventosAgenda(String idAgente, String periodo, { String authorization }) async
    test('test obtenerEventosAgenda', () async {
      // TODO
    });

    // Refrescar eventos de la Agenda por idAgente
    //
    // Refresca los eventos de la agenda usando idAgente
    //
    //Future<String> refrescarAgendaEvents(String idAgente, { String authorization }) async
    test('test refrescarAgendaEvents', () async {
      // TODO
    });
  });
}
