import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for ConsultaApi
void main() {
  final instance = EspacioCiudadanoApi().getConsultaApi();

  group(ConsultaApi, () {
    // Consultar el servicio para obtener el texto de la consulta o reclamacion y la respuesta
    //
    //Future<ZCSRFCCONSULTAFAQResponse> miConsultafaqOperation(ZCSRFCCONSULTAFAQ zCSRFCCONSULTAFAQBody) async
    test('test miConsultafaqOperation', () async {
      // TODO
    });

  });
}
