import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for SoporteApi
void main() {
  final instance = EspacioCiudadanoApi().getSoporteApi();

  group(SoporteApi, () {
    // Crear tarea de soporte/incidencia
    //
    // Crea una nueva tarea de soporte o incidencia en el sistema SIGUE. Permite adjuntar un archivo opcional (captura, documento, etc.). El campo 'datos' debe ser un JSON con los datos de la incidencia.
    //
    //Future<Respuesta> crearTareaSoporte(String idAgente, String datos, { MultipartFile adjunto }) async
    test('test crearTareaSoporte', () async {
      // TODO
    });

    // Crear tarea de soporte/incidencia
    //
    // Crea una nueva tarea de soporte o incidencia en el sistema SIGUE. Permite adjuntar un archivo opcional (captura, documento, etc.). El campo 'datos' debe ser un JSON con los datos de la incidencia.
    //
    //Future<Respuesta> crearTareaSoporte1(String idAgente, String datos, { MultipartFile adjunto }) async
    test('test crearTareaSoporte1', () async {
      // TODO
    });

  });
}
