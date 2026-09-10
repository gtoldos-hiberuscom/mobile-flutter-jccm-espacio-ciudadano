import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for CiudadanosApi
void main() {
  final instance = EspacioCiudadanoApi().getCiudadanosApi();

  group(CiudadanosApi, () {
    // Actualizar las cláusulas de consentimiento de un agente
    //
    // Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.
    //
    //Future<Respuesta> actualizarClausulas(String idAgente, ClausulasAgente clausulasAgente, { String authorization }) async
    test('test actualizarClausulas', () async {
      // TODO
    });

    // Actualizar datos de contacto del ciudadano en Registro Poblacional
    //
    // Actualiza los datos de contacto (correo y/o teléfono) del ciudadano en el Registro Poblacional. El body debe contener los campos a actualizar. Requiere autenticación mediante token JWT y que el NIF del token coincida con el ciudadano a modificar. Si el servicio externo devuelve un error, se propagará el mismo código y mensaje en la respuesta.
    //
    //Future<Respuesta> actualizarContactoRegistroPoblacional(String id, ContactoRegistroPoblacionalRequestDto contactoRegistroPoblacionalRequestDto, { String authorization }) async
    test('test actualizarContactoRegistroPoblacional', () async {
      // TODO
    });

    // Actualizar los hechos vitales seleccionados por un agente
    //
    // Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado=true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.
    //
    //Future<Respuesta> actualizarListaHechos(String idAgente, ListaHechosAgente listaHechosAgente, { String authorization }) async
    test('test actualizarListaHechos', () async {
      // TODO
    });

    // Consultar citas futuras del SESCAM
    //
    // Obtiene el listado de citas médicas futuras programadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora ascendente.(Mas cercana a mas lejana en el futuro)Requiere que el usuario tenga marcada la cláusula de consentimiento correspondiente.
    //
    //Future<Respuesta> citasFuturas1(String numDocumento, { String authorization }) async
    test('test citasFuturas1', () async {
      // TODO
    });

    // Consultar citas hospitalarias pasadas del ciudadano
    //
    // Obtiene el listado de citas hospitalarias pasadas de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).
    //
    //Future<Respuesta> citasHospitalariasPasadas(String idAgente, { String authorization }) async
    test('test citasHospitalariasPasadas', () async {
      // TODO
    });

    // Consultar citas hospitalarias pasadas del ciudadano
    //
    // Obtiene el listado de citas hospitalarias pasadas de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).
    //
    //Future<Respuesta> citasHospitalariasPasadas1(String idAgente, { String authorization }) async
    test('test citasHospitalariasPasadas1', () async {
      // TODO
    });

    // Consultar citas hospitalarias pendientes del ciudadano
    //
    // Obtiene el listado de citas hospitalarias pendientes de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).
    //
    //Future<Respuesta> citasHospitalariasPendientes(String idAgente, { String authorization }) async
    test('test citasHospitalariasPendientes', () async {
      // TODO
    });

    // Consultar citas hospitalarias pendientes del ciudadano
    //
    // Obtiene el listado de citas hospitalarias pendientes de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).
    //
    //Future<Respuesta> citasHospitalariasPendientes1(String idAgente, { String authorization }) async
    test('test citasHospitalariasPendientes1', () async {
      // TODO
    });

    // Consultar historial de citas pasadas del SESCAM
    //
    // Obtiene el historial paginado de citas médicas pasadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora descendente. (Mas cercana a mas lejana en el pasado)Permite consultar el histórico de visitas médicas realizadas con soporte de paginación.
    //
    //Future<Respuesta> citasPasadas(String numDocumento, { int pagina, String authorization }) async
    test('test citasPasadas', () async {
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

    // Descargar documento de una notificación
    //
    // Descarga un documento adjunto específico de una notificación electrónica identificado por su orden. Los documentos pueden ser resoluciones, anexos o cualquier contenido notificado al ciudadano.
    //
    //Future<Uint8List> descargarDocumento(String id, int notificacionId, int orden, { String authorization, String sisOrigen, String origen }) async
    test('test descargarDocumento', () async {
      // TODO
    });

    // Descargar justificante de una notificación
    //
    // Descarga el documento PDF que acredita el puesta a disposición, acceso o rechazo de una notificación electrónica. El justificante tiene valor probatorio conforme a la normativa de notificaciones electrónicas.
    //
    //Future<Uint8List> descargarJustificante(String id, int notificacionId, { String authorization, String sisOrigen, String origen }) async
    test('test descargarJustificante', () async {
      // TODO
    });

    // Eliminar preferencias y configuración de hechos vitales de un agente
    //
    // Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.
    //
    //Future<Respuesta> eliminarPreferencias1(String idAgente, { String authorization }) async
    test('test eliminarPreferencias1', () async {
      // TODO
    });

    // Dar de alta las cláusulas de consentimiento de un agente
    //
    // Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.
    //
    //Future<Respuesta> enviarClausulas(String idAgente, ClausulasAgente clausulasAgente, { String authorization }) async
    test('test enviarClausulas', () async {
      // TODO
    });

    // Obtener CIP a partir del NIF
    //
    // Servicio traductor que obtiene el Código de Identificación Personal (CIP) del SESCAM a partir del número de documento de identidad (NIF/NIE) del ciudadano. El CIP es el identificador único del paciente en el sistema sanitario de Castilla-La Mancha.
    //
    //Future<Respuesta> getCipFromNif1(String numDocumento, { String authorization }) async
    test('test getCipFromNif1', () async {
      // TODO
    });

    // Obtener datos catastrales
    //
    // Consulta los datos catastrales del ciudadano en el servicio de Catastro.
    //
    //Future<Respuesta> getDatosCatastrales1(String numDocumento, DTCTROCDATREQ DTCTROCDATREQ, { String authorization }) async
    test('test getDatosCatastrales1', () async {
      // TODO
    });

    // Obtener datos de residencia (INE)
    //
    // Consulta los datos de residencia del ciudadano en el servicio INE. El documento del cuerpo se valida frente al token y al parámetro de ruta.
    //
    //Future<Respuesta> getDatosResidencia1(String numDocumento, DTINECDRFREQ DTINECDRFREQ, { String authorization }) async
    test('test getDatosResidencia1', () async {
      // TODO
    });

    // Consultar situacion de demandante de empleo a fecha actual
    //
    // Consulta en el servicio SEPE si el ciudadano figura como demandante de empleo en la fecha actual y devuelve el resultado de la tramitacion.
    //
    //Future<Respuesta> getDemandanteEmpleoFechaActual1(String numDocumento, DTSEPESVDIDEFAREQ DTSEPESVDIDEFAREQ, { String authorization }) async
    test('test getDemandanteEmpleoFechaActual1', () async {
      // TODO
    });

    // Iniciar procedimiento administrativo
    //
    // Inicia un nuevo procedimiento administrativo en el sistema CESAR. Valida los datos del procedimiento y crea el registro correspondiente.
    //
    //Future<Respuesta> getIniProc1(String idAgente, String idExpediente, DTProcedimiento dTProcedimiento) async
    test('test getIniProc1', () async {
      // TODO
    });

    // Consultar listado de vehiculos de un ciudadano
    //
    // Consulta en el servicio DGT el listado de vehiculos asociados a un ciudadano identificado por NIF y devuelve el resultado completo de la tramitacion.
    //
    //Future<Respuesta> getListaVehiculos1(String numDocumento, DTDGTLISTADOVEHICULOSREQ DTDGTLISTADOVEHICULOSREQ, { String authorization }) async
    test('test getListaVehiculos1', () async {
      // TODO
    });

    // Obtener servicios segmentados por hechos vitales
    //
    // Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.
    //
    //Future<Respuesta> getServiciosSegmentados1(String idAgente, { String operacion, String size, String page, String ultimosDias, BuiltList<int> hechosvitales, String authorization }) async
    test('test getServiciosSegmentados1', () async {
      // TODO
    });

    // Obtener titulos no universitarios
    //
    // Consulta los titulos no universitarios del ciudadano en el servicio de Educacion.
    //
    //Future<Respuesta> getTitulosNoUniversitarios1(String numDocumento, DTEDUTNUREQ DTEDUTNUREQ, { String authorization }) async
    test('test getTitulosNoUniversitarios1', () async {
      // TODO
    });

    // Obtener titulos universitarios
    //
    // Consulta los titulos universitarios del ciudadano en el servicio de Educacion.
    //
    //Future<Respuesta> getTitulosUniversitarios1(String numDocumento, DTEDUTUOREQ DTEDUTUOREQ, { String authorization }) async
    test('test getTitulosUniversitarios1', () async {
      // TODO
    });

    // Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma
    //
    //Future<RESULTADOPROCEDIMIENTO> miSubirAdjuntoSinFirmaOperation1(String idAgente, String idExpediente, ADJUNTO ADJUNTO) async
    test('test miSubirAdjuntoSinFirmaOperation1', () async {
      // TODO
    });

    // Modificar el contacto de un ciudadano en Notifica
    //
    // Actualiza los datos de contacto (email, teléfono) de un tercero previamente registrado en Notifica. El ciudadano debe existir en el sistema. Requiere que el NIF del token coincida con el NIF a modificar.
    //
    //Future<TerceroN2Dto> modificarCiudadano(String id, TerceroN2Dto terceroN2Dto, { String authorization, String sisOrigen, String origen }) async
    test('test modificarCiudadano', () async {
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

    // Consultar registros de entrada por documento del ciudadano
    //
    // Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
    //
    //Future<Respuesta> myPubliSelecByNifTipoProcEntradaOperation(String idAgente, DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ) async
    test('test myPubliSelecByNifTipoProcEntradaOperation', () async {
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

    // Obtener carné joven digital
    //
    // Recupera los datos del carné joven digital asociados al ciudadano autenticado.
    //
    //Future<Respuesta> obtenerCarnetJoven(String dni, { String authorization }) async
    test('test obtenerCarnetJoven', () async {
      // TODO
    });

    // Obtener contacto de un ciudadano registrado en Notifica
    //
    // Consulta los datos de contacto (email, teléfono) de un tercero previamente registrado en el sistema Notifica. Devuelve 404 si el ciudadano no está registrado.
    //
    //Future<TerceroN2Dto> obtenerCiudadano(String id, { String authorization, String sisOrigen, String origen }) async
    test('test obtenerCiudadano', () async {
      // TODO
    });

    // Obtener cláusulas de consentimiento asociadas a un agente
    //
    // Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.
    //
    //Future<Respuesta> obtenerClausulasPorAgente(String idAgente, { String authorization }) async
    test('test obtenerClausulasPorAgente', () async {
      // TODO
    });

    // Consultar datos de contacto del ciudadano en Registro Poblacional
    //
    // Recupera los datos de contacto (correo electrónico y teléfono) y datos parciales de dirección del ciudadano en el Registro Poblacional identificado por su NIF/NIE. Requiere autenticación mediante token JWT y validación del NIF del token. En caso de error del servicio externo, la respuesta conservará el código y el mensaje proporcionado por dicho servicio.
    //
    //Future<Respuesta> obtenerContactoRegistroPoblacional(String id, { String authorization }) async
    test('test obtenerContactoRegistroPoblacional', () async {
      // TODO
    });

    // Obtener datos de atencion a la dependencia
    //
    // Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.
    //
    //Future<Respuesta> obtenerDatosAtencionDependenciaIntermediacion(String idAgente, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosAtencionDependenciaIntermediacion', () async {
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

    // Obtener datos de discapacidad por intermediación
    //
    // Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.
    //
    //Future<Respuesta> obtenerDatosDiscapacidadIntermediacion(String id, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosDiscapacidadIntermediacion', () async {
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

    // Obtener datos de familia numerosa por intermediación
    //
    // Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.
    //
    //Future<Respuesta> obtenerDatosFamiliaNumerosaIntermediacion(String numDocumento, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosFamiliaNumerosaIntermediacion', () async {
      // TODO
    });

    // Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
    //
    // Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla-La Mancha. La respuesta incluye el identificador de la tarjeta, modalidad (Persona con Discapacidad o Movilidad Reducida), fechas de vigencia de inicio y fin, y demás datos asociados a la tarjeta.
    //
    //Future<Respuesta> obtenerDatosTarjetaEstacionamientoIntermediacion1(String idAgente, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTarjetaEstacionamientoIntermediacion1', () async {
      // TODO
    });

    // Obtener datos del último balneario adjudicado del programa de termalismo
    //
    // Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.
    //
    //Future<Respuesta> obtenerDatosTermalismoIntermediacion(String idAgente, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerDatosTermalismoIntermediacion', () async {
      // TODO
    });

    // Obtener eventos de la Agenda
    //
    // Obtiene los eventos de agenda de un agente para un periodo determinado.
    //
    //Future<Respuesta> obtenerEventosAgenda1(String idAgente, String periodo, { String authorization }) async
    test('test obtenerEventosAgenda1', () async {
      // TODO
    });

    // Obtener lista de hechos vitales por agente
    //
    // Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.
    //
    //Future<Respuesta> obtenerListaHechosByIdAgente(String idAgente, { String authorization }) async
    test('test obtenerListaHechosByIdAgente', () async {
      // TODO
    });

    // Obtener una notificación concreta de un ciudadano
    //
    // Recupera el detalle completo de una notificación electrónica específica, incluyendo documentos adjuntos, histórico de estados e interesados. Aplica control de acceso para verificar que el ciudadano autenticado es interesado en la notificación.
    //
    //Future<Respuesta> obtenerNotificacion(String id, int notificacionId, { String authorization, String sisOrigen, String origen }) async
    test('test obtenerNotificacion', () async {
      // TODO
    });

    // Obtener notificaciones de un ciudadano
    //
    // Recupera el listado de notificaciones electrónicas asociadas a un ciudadano identificado por su NIF/NIE. Permite filtrar por estado y paginar los resultados. Requiere autenticación mediante token JWT y validación de la cláusula de consentimiento.
    //
    //Future<BuiltList<NotificacionIndexaDto>> obtenerNotificacionesCiudadano(String id, { String authorization, String estado, int page, int size }) async
    test('test obtenerNotificacionesCiudadano', () async {
      // TODO
    });

    // Obtener ofertas de empleo inscritas
    //
    // Consulta las ofertas de empleo en las que el ciudadano figura inscrito. La respuesta se muestra con la estructura completa Respuesta y el listado de ofertas en datosespecificos.
    //
    //Future<Respuesta> obtenerOfertasEmpleoInscritas1(String idAgente, BaseRequestIntermediacion baseRequestIntermediacion, { String authorization }) async
    test('test obtenerOfertasEmpleoInscritas1', () async {
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

    // Obtener PKPass del carné joven digital
    //
    // Genera el fichero PKPass del carné joven digital del ciudadano autenticado para su uso en wallet compatible.
    //
    //Future<Respuesta> obtenerPkPass(String dni, { String authorization }) async
    test('test obtenerPkPass', () async {
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

    // Obtener PKPass del carné de familia numerosa
    //
    // Genera el fichero PKPass del carné digital de familia numerosa del ciudadano autenticado.
    //
    //Future<Respuesta> obtenerPkPassFamiliaNumerosa(String dni, { String authorization }) async
    test('test obtenerPkPassFamiliaNumerosa', () async {
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

    // Refrescar eventos de la Agenda por idAgente
    //
    // Refresca los eventos de agenda del agente y devuelve el resumen del proceso.
    //
    //Future<Respuesta> refrescarAgendaEvents1(String idAgente, { String authorization }) async
    test('test refrescarAgendaEvents1', () async {
      // TODO
    });

    // Registrar el contacto de un ciudadano en Notifica
    //
    // Crea un nuevo registro de contacto (tercero) en el sistema Notifica para recibir notificaciones electrónicas. El NIF del ciudadano debe coincidir con el del token de autenticación. Requiere aceptación previa de la cláusula de consentimiento.
    //
    //Future<TerceroN2Dto> registrarCiudadano(String id, TerceroN2Dto terceroN2Dto, { String authorization, String sisOrigen, String origen }) async
    test('test registrarCiudadano', () async {
      // TODO
    });

    // Registrar fichero y obtener justificante
    //
    // Registra un fichero en el procedimiento administrativo indicado. Devuelve el justificante de registro como fichero PDF firmado o justificante de envío.
    //
    //Future<Uint8List> registrarFicheroOperation(String idAgente, String idExpediente, RegistrarFicheroRequest registrarFicheroRequest) async
    test('test registrarFicheroOperation', () async {
      // TODO
    });

    // Realizar una transición sobre una notificación
    //
    // Ejecuta una transición de estado sobre una notificación (por ejemplo: comparecer, aceptar, rechazar). La transición modifica el estado de la notificación según las reglas de negocio del sistema Notifica. Puede requerir justificación según el tipo de transición.
    //
    //Future<Respuesta> transicionNotificacion(String id, int notificacionId, { String authorization, String sisOrigen, String origen }) async
    test('test transicionNotificacion', () async {
      // TODO
    });

  });
}
