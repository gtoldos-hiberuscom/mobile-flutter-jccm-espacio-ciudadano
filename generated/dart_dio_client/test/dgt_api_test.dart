import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for DgtApi
void main() {
  final instance = EspacioCiudadanoApi().getDgtApi();

  group(DgtApi, () {
    // Servicio para consultar el listado de vehiculos
    //
    //Future<DTDGTLISTADOVEHICULOSRES> getListaVehiculos(String numDocumento, DTDGTLISTADOVEHICULOSREQ dTDGTLISTADOVEHICULOSREQBody, { String authorization }) async
    test('test getListaVehiculos', () async {
      // TODO
    });
  });
}
