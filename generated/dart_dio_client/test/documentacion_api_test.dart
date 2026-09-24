import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for DocumentacionApi
void main() {
  final instance = EspacioCiudadanoApi().getDocumentacionApi();

  group(DocumentacionApi, () {
    // Registrar fichero y obtener justificante
    //
    // Registra un fichero en el procedimiento administrativo indicado. Devuelve el justificante de registro como fichero PDF firmado o justificante de envío.
    //
    //Future<Uint8List> registrarFicheroOperation(String idAgente, String idExpediente, RegistrarFicheroRequest registrarFicheroRequest) async
    test('test registrarFicheroOperation', () async {
      // TODO
    });

    // Registrar fichero y obtener justificante
    //
    // Registra un fichero en el procedimiento administrativo indicado. Devuelve el justificante de registro como fichero PDF firmado o justificante de envío.
    //
    //Future<Uint8List> registrarFicheroOperation1(RegistrarFicheroRequest registrarFicheroRequest) async
    test('test registrarFicheroOperation1', () async {
      // TODO
    });

  });
}
