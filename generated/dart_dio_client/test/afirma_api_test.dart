import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for AfirmaApi
void main() {
  final instance = EspacioCiudadanoApi().getAfirmaApi();

  group(AfirmaApi, () {
    // Consultar el listado de los tipos de documentos en cesar
    //
    //Future<ZCSVECResponse> miListarDocumentosReq(ZCSLISTARTIPOSDOC ZCSLISTARTIPOSDOC) async
    test('test miListarDocumentosReq', () async {
      // TODO
    });

    // Consultar el servicio para la validación de la firma en cesar
    //
    //Future<ZCSVECResponse> miVecReq(ZCSVEC ZCSVEC) async
    test('test miVecReq', () async {
      // TODO
    });
  });
}
