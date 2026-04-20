import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for ServicioApi
void main() {
  final instance = EspacioCiudadanoApi().getServicioApi();

  group(ServicioApi, () {
    // Consultar el detalle de un tramite en cesar
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> miDetalleOperation(DTQUERY dTQUERYBody) async
    test('test miDetalleOperation', () async {
      // TODO
    });

  });
}
