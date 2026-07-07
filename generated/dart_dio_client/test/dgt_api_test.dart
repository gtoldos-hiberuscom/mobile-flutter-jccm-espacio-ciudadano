import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for DgtApi
void main() {
  final instance = EspacioCiudadanoApi().getDgtApi();

  group(DgtApi, () {
    // Consultar listado de vehiculos de un ciudadano
    //
    // Consulta en el servicio DGT el listado de vehiculos asociados a un ciudadano identificado por NIF y devuelve el resultado completo de la tramitacion.
    //
    //Future<Respuesta> getListaVehiculos(String numDocumento, DTDGTLISTADOVEHICULOSREQ DTDGTLISTADOVEHICULOSREQ, { String authorization }) async
    test('test getListaVehiculos', () async {
      // TODO
    });

  });
}
