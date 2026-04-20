import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for DocumentacionApi
void main() {
  final instance = EspacioCiudadanoApi().getDocumentacionApi();

  group(DocumentacionApi, () {
    // Permite realizar el registro de un fichero obteniendo el justificante como resultado
    //
    //Future<Uint8List> registrarFicheroOperation(RegistrarFicheroRequest registrarFicheroRequest) async
    test('test registrarFicheroOperation', () async {
      // TODO
    });
  });
}
