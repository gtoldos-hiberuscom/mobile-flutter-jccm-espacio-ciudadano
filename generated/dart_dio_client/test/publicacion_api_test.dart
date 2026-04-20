import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for PublicacionApi
void main() {
  final instance = EspacioCiudadanoApi().getPublicacionApi();

  group(PublicacionApi, () {
    // Consultar el detalle de un tramite en cesar
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> miDetalleOperation(DTQUERY dTQUERYBody) async
    test('test miDetalleOperation', () async {
      // TODO
    });

    // Servicio que permite consultar el documento de certificado de deuda en cesar
    //
    //Future<ZCSRFCDOCSFIRMADOSPFEXPTEResponse> miDocsfirmados(ZCSRFCDOCSFIRMADOSPFEXPTE zCSRFCDOCSFIRMADOSPFEXPTEBody) async
    test('test miDocsfirmados', () async {
      // TODO
    });

    // Consulta un expediente especificado por número de registro
    //
    //Future<ZCSRFCPUBLISELECTBYNUMREGResponse> myPubliNumRegOperation(ZCSRFCPUBLISELECTBYNUMREG zCSRFCPUBLISELECTBYNUMREGBody) async
    test('test myPubliNumRegOperation', () async {
      // TODO
    });

    // Consultar la lista de expedientes vinculados a un NIF o número de identificación
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> myPubliSelecByNifOperation(DTSELECTBYNIFREQ dTSELECTBYNIFREQBody) async
    test('test myPubliSelecByNifOperation', () async {
      // TODO
    });

    // Consultar la lista de salidas vinculados a un NIF o número de identificación
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> myPubliSelecByNifTipoProcOperation(DTSELECTBYNIFV2REQ dTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcOperation', () async {
      // TODO
    });

    // Consultar la lista de expedientes vinculados a un NIF o número de identificación
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> myPubliSelecByNifTipoProcOperation1(DTSELECTBYNIFV2REQ dTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcOperation1', () async {
      // TODO
    });

    // Consultar la lista de entradas vinculados a un NIF o número de identificación
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> myPubliSelecByNifTipoProcOperation2(DTSELECTBYNIFV2REQ dTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcOperation2', () async {
      // TODO
    });

    // Consultar el expediente especificado por número de expediente
    //
    //Future<ZCSRFCPUBLISELECTBYNUMEXPResponse> myPubliSelecByNumExpOperation(ZCSRFCPUBLISELECTBYNUMEXP zCSRFCPUBLISELECTBYNUMEXPBody) async
    test('test myPubliSelecByNumExpOperation', () async {
      // TODO
    });

    // Consultar listado de expedientes asociados a un número de documento
    //
    //Future<ZCSRFCMISEXPEDIENTESResponse> siMisExpedientesOperation(ZCSRFCMISEXPEDIENTES zCSRFCMISEXPEDIENTESBody) async
    test('test siMisExpedientesOperation', () async {
      // TODO
    });

  });
}
