import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for SescamApi
void main() {
  final instance = EspacioCiudadanoApi().getSescamApi();

  group(SescamApi, () {
    // Servicio para consultar las citas futuras
    //
    //Future<String> citasFuturas(String numDocumento, { String authorization }) async
    test('test citasFuturas', () async {
      // TODO
    });

    // Servicio para consultar las citas pasadas
    //
    //Future<String> citasPasadas(String numDocumento, { String authorization }) async
    test('test citasPasadas', () async {
      // TODO
    });

    // Servicio para obtener el CIP de un NIF
    //
    //Future<String> getCipFromNif(String numDocumento, { String authorization }) async
    test('test getCipFromNif', () async {
      // TODO
    });

  });
}
