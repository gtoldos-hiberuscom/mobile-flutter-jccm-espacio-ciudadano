import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';


/// tests for CiudadanosApi
void main() {
  final instance = EspacioCiudadanoApi().getCiudadanosApi();

  group(CiudadanosApi, () {
    // Actualizar datos de contacto del ciudadano en Registro Poblacional
    //
    // Actualiza los datos de contacto (correo y/o teléfono) del ciudadano en el Registro Poblacional. El body debe contener los campos a actualizar. Requiere autenticación mediante token JWT y que el NIF del token coincida con el ciudadano a modificar. Si el servicio externo devuelve un error, se propagará el mismo código y mensaje en la respuesta.
    //
    //Future<Respuesta> actualizarContactoRegistroPoblacional(String id, ContactoRegistroPoblacionalRequestDto contactoRegistroPoblacionalRequestDto, { String authorization }) async
    test('test actualizarContactoRegistroPoblacional', () async {
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

    // Modificar el contacto de un ciudadano en Notifica
    //
    // Actualiza los datos de contacto (email, teléfono) de un tercero previamente registrado en Notifica. El ciudadano debe existir en el sistema. Requiere que el NIF del token coincida con el NIF a modificar.
    //
    //Future<TerceroN2Dto> modificarCiudadano(String id, TerceroN2Dto terceroN2Dto, { String authorization, String sisOrigen, String origen }) async
    test('test modificarCiudadano', () async {
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

    // Consultar datos de contacto del ciudadano en Registro Poblacional
    //
    // Recupera los datos de contacto (correo electrónico y teléfono) y datos parciales de dirección del ciudadano en el Registro Poblacional identificado por su NIF/NIE. Requiere autenticación mediante token JWT y validación del NIF del token. En caso de error del servicio externo, la respuesta conservará el código y el mensaje proporcionado por dicho servicio.
    //
    //Future<Respuesta> obtenerContactoRegistroPoblacional(String id, { String authorization }) async
    test('test obtenerContactoRegistroPoblacional', () async {
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

    // Registrar el contacto de un ciudadano en Notifica
    //
    // Crea un nuevo registro de contacto (tercero) en el sistema Notifica para recibir notificaciones electrónicas. El NIF del ciudadano debe coincidir con el del token de autenticación. Requiere aceptación previa de la cláusula de consentimiento.
    //
    //Future<TerceroN2Dto> registrarCiudadano(String id, TerceroN2Dto terceroN2Dto, { String authorization, String sisOrigen, String origen }) async
    test('test registrarCiudadano', () async {
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
