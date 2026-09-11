import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for PublicacionApi
void main() {
  final instance = EspacioCiudadanoApi().getPublicacionApi();

  group(PublicacionApi, () {
    // Consultar el detalle de un tramite en cesar
    //
    //Future<ZCSRFCPUBLISELECTBYNIFResponse> miDetalleOperation(DTQUERY DTQUERY) async
    test('test miDetalleOperation', () async {
      // TODO
    });

    // Consultar un expediente de publicación por número de registro
    //
    // Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.
    //
    //Future<Respuesta> myPubliNumRegOperation(String idAgente, String idRegistro, ZCSRFCPUBLISELECTBYNUMREG ZCSRFCPUBLISELECTBYNUMREG) async
    test('test myPubliNumRegOperation', () async {
      // TODO
    });

    // Consultar un expediente de publicación por número de registro
    //
    // Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.
    //
    //Future<Respuesta> myPubliNumRegOperation1(String idAgente, String idRegistro, ZCSRFCPUBLISELECTBYNUMREG ZCSRFCPUBLISELECTBYNUMREG) async
    test('test myPubliNumRegOperation1', () async {
      // TODO
    });

    // Consultar expedientes y publicaciones asociados a un documento de identidad
    //
    // Consulta los expedientes de publicación asociados a un ciudadano mediante su tipo y número de documento. La respuesta devuelve la estructura completa con el resultado de la consulta, incluyendo los expedientes localizados, datos del interesado, estado de tramitación, órgano responsable y documentos asociados.
    //
    //Future<Respuesta> myPubliSelecByNifOperation(DTSELECTBYNIFREQ DTSELECTBYNIFREQ) async
    test('test myPubliSelecByNifOperation', () async {
      // TODO
    });

    // Consultar registros de entrada por documento del ciudadano
    //
    // Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcEntradaOperation(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcEntradaOperation', () async {
      // TODO
    });

    // Consultar registros de entrada por documento del ciudadano
    //
    // Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcEntradaOperation1(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcEntradaOperation1', () async {
      // TODO
    });

    // Consultar expedientes por documento del ciudadano
    //
    // Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcExpOperation(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcExpOperation', () async {
      // TODO
    });

    // Consultar expedientes por documento del ciudadano
    //
    // Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcExpOperation1(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcExpOperation1', () async {
      // TODO
    });

    // Busqueda de registros por tipo
    //
    // Devuelve los registros de tipo entrada para el NIF proporcionado. Se invoca mediante el mismo path con el parámetro query 'tipo=entrada'. Ejemplo: /ciudadanos/{idAgente}/registros?tipo=entrada.
    //
    //Future<MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response> myPubliSelecByNifTipoProcRegistrosEntradaOperation1(String tipo, String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcRegistrosEntradaOperation1', () async {
      // TODO
    });

    // Consultar registros de salida por documento del ciudadano
    //
    // Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcSalidaOperation(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcSalidaOperation', () async {
      // TODO
    });

    // Consultar registros de salida por documento del ciudadano
    //
    // Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcSalidaOperation1(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcSalidaOperation1', () async {
      // TODO
    });

    // Consultar un expediente de publicación por número de expediente
    //
    // Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.
    //
    //Future<Respuesta> myPubliSelecByNumExpOperation(String idAgente, String idExpediente, ZCSRFCPUBLISELECTBYNUMEXP ZCSRFCPUBLISELECTBYNUMEXP) async
    test('test myPubliSelecByNumExpOperation', () async {
      // TODO
    });

    // Consultar un expediente de publicación por número de expediente
    //
    // Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.
    //
    //Future<Respuesta> myPubliSelecByNumExpOperation1(String idAgente, String idExpediente, ZCSRFCPUBLISELECTBYNUMEXP ZCSRFCPUBLISELECTBYNUMEXP) async
    test('test myPubliSelecByNumExpOperation1', () async {
      // TODO
    });

  });
}
