import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for CarnetDigitalApi
void main() {
  final instance = EspacioCiudadanoApi().getCarnetDigitalApi();

  group(CarnetDigitalApi, () {
    // Obtener carnet joven
    //
    //Future<CarnetJoven> obtenerCarnetJoven(String dni, { String authorization }) async
    test('test obtenerCarnetJoven', () async {
      // TODO
    });

    // Obtener datos del carné de familia numerosa
    //
    //Future<String> obtenerDatosFamiliaNumerosa(RequestFachadaDiscapacidadInterm requestFachadaDiscapacidadInterm, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosa', () async {
      // TODO
    });

    // Obtener datos del carné de familia numerosa
    //
    //Future<String> obtenerDatosFamiliaNumerosa1(String dni, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosa1', () async {
      // TODO
    });

    // Obtener datos del carné de familia numerosa
    //
    // (Método GET) Obtiene los datos de familia numerosa por DNI.
    //
    //Future<DatosFamiliaNumerosa> obtenerDatosFamiliaNumerosa2(String dni, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosa2', () async {
      // TODO
    });

    // Obtener Pdf de un carné
    //
    //Future<String> obtenerPdf(String dni, { String authorization }) async
    test('test obtenerPdf', () async {
      // TODO
    });

    // Obtener PkPass de un carné
    //
    //Future<String> obtenerPkPass(String dni, { String authorization }) async
    test('test obtenerPkPass', () async {
      // TODO
    });

    // Obtener PkPass del carné de familia numerosa
    //
    // (Método GET) Obtiene el PKPASS de familia numerosa por DNI.
    //
    //Future<PkpassFamiliaNumerosa> obtenerPkPassFamiliaNumerosa(String dni, { String authorization }) async
    test('test obtenerPkPassFamiliaNumerosa', () async {
      // TODO
    });

    // Obtener PkPass del carné de familia numerosa
    //
    //Future<String> obtenerPkPassFamiliaNumerosa1(String dni, { String authorization }) async
    test('test obtenerPkPassFamiliaNumerosa1', () async {
      // TODO
    });

    // Obtener Qr de un carné
    //
    //Future<CarnetQr> obtenerQr(String dni, { String authorization }) async
    test('test obtenerQr', () async {
      // TODO
    });
  });
}
