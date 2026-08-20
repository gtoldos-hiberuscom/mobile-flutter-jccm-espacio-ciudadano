import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for CarnetDigitalApi
void main() {
  final instance = EspacioCiudadanoApi().getCarnetDigitalApi();

  group(CarnetDigitalApi, () {
    // Obtener carné joven digital
    //
    // Recupera los datos del carné joven digital asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerCarnetJoven(String dni, { String authorization }) async
    test('test obtenerCarnetJoven', () async {
      // TODO
    });

    // Obtener carné joven digital
    //
    // Recupera los datos del carné joven digital asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerCarnetJoven1(String dni, { String authorization }) async
    test('test obtenerCarnetJoven1', () async {
      // TODO
    });

    // Obtener datos del carné de discapacidad
    //
    // Recupera los datos del carné digital de discapacidad asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerDatosDiscapacidad(String dni, { String authorization }) async
    test('test obtenerDatosDiscapacidad', () async {
      // TODO
    });

    // Obtener datos del carné de discapacidad
    //
    // Recupera los datos del carné digital de discapacidad asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerDatosDiscapacidad1(String dni, { String authorization }) async
    test('test obtenerDatosDiscapacidad1', () async {
      // TODO
    });

    // Obtener datos del carné de familia numerosa
    //
    // Recupera los datos del carné digital de familia numerosa asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerDatosFamiliaNumerosa(String dni, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosa', () async {
      // TODO
    });

    // Obtener datos del carné de familia numerosa
    //
    // Recupera los datos del carné digital de familia numerosa asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerDatosFamiliaNumerosa1(String dni, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosa1', () async {
      // TODO
    });

    // Obtener datos de familia numerosa por intermediación
    //
    // Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.
    //
    //Future<Respuesta> obtenerDatosFamiliaNumerosaIntermediacion(String numDocumento, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosaIntermediacion', () async {
      // TODO
    });

    // Obtener datos de familia numerosa por intermediación
    //
    // Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.
    //
    //Future<Respuesta> obtenerDatosFamiliaNumerosaIntermediacion1(String numDocumento, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosaIntermediacion1', () async {
      // TODO
    });

    // Obtener PDF del carné joven digital
    //
    // Genera el documento PDF del carné joven digital del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPdf(String dni, { String authorization }) async
    test('test obtenerPdf', () async {
      // TODO
    });

    // Obtener PDF del carné joven digital
    //
    // Genera el documento PDF del carné joven digital del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPdf1(String dni, { String authorization }) async
    test('test obtenerPdf1', () async {
      // TODO
    });

    // Obtener PKPass del carné joven digital
    //
    // Genera el fichero PKPass del carné joven digital del ciudadano autenticado para su uso en wallet compatible.
    //
    //Future<Respuesta> obtenerPkPass(String dni, { String authorization }) async
    test('test obtenerPkPass', () async {
      // TODO
    });

    // Obtener PKPass del carné joven digital
    //
    // Genera el fichero PKPass del carné joven digital del ciudadano autenticado para su uso en wallet compatible.
    //
    //Future<Respuesta> obtenerPkPass1(String dni, { String authorization }) async
    test('test obtenerPkPass1', () async {
      // TODO
    });

    // Obtener PKPass del carné de discapacidad
    //
    // Genera el fichero PKPass del carné digital de discapacidad del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPkPassDiscapacidad(String dni, { String authorization }) async
    test('test obtenerPkPassDiscapacidad', () async {
      // TODO
    });

    // Obtener PKPass del carné de discapacidad
    //
    // Genera el fichero PKPass del carné digital de discapacidad del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPkPassDiscapacidad1(String dni, { String authorization }) async
    test('test obtenerPkPassDiscapacidad1', () async {
      // TODO
    });

    // Obtener PKPass del carné de familia numerosa
    //
    // Genera el fichero PKPass del carné digital de familia numerosa del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPkPassFamiliaNumerosa(String dni, { String authorization }) async
    test('test obtenerPkPassFamiliaNumerosa', () async {
      // TODO
    });

    // Obtener PKPass del carné de familia numerosa
    //
    // Genera el fichero PKPass del carné digital de familia numerosa del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPkPassFamiliaNumerosa1(String dni, { String authorization }) async
    test('test obtenerPkPassFamiliaNumerosa1', () async {
      // TODO
    });

    // Obtener QR del carné joven digital
    //
    // Genera el código QR asociado al carné joven digital del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerQr(String dni, { String authorization }) async
    test('test obtenerQr', () async {
      // TODO
    });

    // Obtener QR del carné joven digital
    //
    // Genera el código QR asociado al carné joven digital del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerQr1(String dni, { String authorization }) async
    test('test obtenerQr1', () async {
      // TODO
    });

  });
}
