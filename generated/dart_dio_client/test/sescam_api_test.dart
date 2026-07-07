import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for SescamApi
void main() {
  final instance = EspacioCiudadanoApi().getSescamApi();

  group(SescamApi, () {
    // Consultar citas futuras del SESCAM
    //
    // Obtiene el listado de citas médicas futuras programadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora ascendente.(Mas cercana a mas lejana en el futuro)Requiere que el usuario tenga marcada la cláusula de consentimiento correspondiente.
    //
    //Future<Respuesta> citasFuturas(String numDocumento, { String authorization }) async
    test('test citasFuturas', () async {
      // TODO
    });

    // Consultar historial de citas pasadas del SESCAM
    //
    // Obtiene el historial paginado de citas médicas pasadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora descendente. (Mas cercana a mas lejana en el pasado)Permite consultar el histórico de visitas médicas realizadas con soporte de paginación.
    //
    //Future<Respuesta> citasPasadas(String numDocumento, { int pagina, String authorization }) async
    test('test citasPasadas', () async {
      // TODO
    });

    // Obtener CIP a partir del NIF
    //
    // Servicio traductor que obtiene el Código de Identificación Personal (CIP) del SESCAM a partir del número de documento de identidad (NIF/NIE) del ciudadano. El CIP es el identificador único del paciente en el sistema sanitario de Castilla-La Mancha.
    //
    //Future<Respuesta> getCipFromNif(String numDocumento, { String authorization }) async
    test('test getCipFromNif', () async {
      // TODO
    });

  });
}
