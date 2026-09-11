import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';

/// Manejo común de las respuestas de intermediación del recurso ciudadano.
///
/// Tres estados, nunca menos:
///
/// - **404** → `null`: el organismo no tiene datos del ciudadano.
/// - **Rechazo de autorización** (sobre con `codigo-respuesta` `412.00` o
///   `codigo-error` `3034`, venga como 2xx o dentro de un error HTTP) →
///   [MyDataAuthorizationRequired], para que la pantalla ofrezca autorizar.
/// - **Cualquier otro fallo** → la `DioException` se propaga. Interpretar un
///   error de transporte como «sin datos» es lo que fabricaba estados vacíos
///   (o afirmativos) falsos durante caídas del backend.
Future<Object?> intermediacionRawResponse(final Future<Object?> Function() fetch) async {
  final Object? data;
  try {
    data = await fetch();
  } on DioException catch (error) {
    if (error.response?.statusCode == 404) {
      return null;
    }
    final rawData = error.response?.data;
    if (rawData != null && isIntermediacionAuthorizationRequired(rawData)) {
      throw const MyDataAuthorizationRequired();
    }
    rethrow;
  }
  if (data != null && isIntermediacionAuthorizationRequired(data)) {
    throw const MyDataAuthorizationRequired();
  }
  return data;
}

/// Códigos de estado que la capa de datos de intermediación sabe interpretar:
/// una respuesta correcta (2xx), la negativa por falta de autorización (403) o
/// la ausencia de datos del ciudadano (404). Cualquier otro debe salir como
/// `DioException` para que los interceptores de red hagan su trabajo.
///
/// Los 3xx quedan **fuera** a propósito: una redirección del gateway o de un
/// portal cautivo entraba por la rama «manejada» y su HTML se decodificaba a
/// `null`, es decir, a «sin datos». Dio sigue las redirecciones por su cuenta,
/// así que un 3xx que llega hasta aquí es precisamente el caso raro que no hay
/// que interpretar como negocio.
bool isHandledIntermediacionStatus(final int? status) => status != null && ((status >= 200 && status < 300) || status == 403 || status == 404);

/// Aplica el contrato de autorización a una respuesta ya admitida por
/// [isHandledIntermediacionStatus]. Lanza, o no hace nada.
///
/// Es el único sitio donde se decide qué es una falta de autorización, y el
/// orden importa:
///
/// 1. **El sobre manda.** Si dice `412.00`/`3034` es falta de autorización,
///    venga en un 2xx o en el cuerpo de un 403. Comprobarlo solo en el 403
///    dejaba pasar el `412.00` dentro de un 200 —el fallo cerrado del
///    gateway—, que llegaba a la pantalla como datos y se pintaba como
///    "CIP: -" o "no tienes citas" (MD-1).
/// 2. **403 sin sobre → fallo de servicio.** La fachada devuelve
///    "403 Forbidden: [no body]" cuando falla contra su microservicio, y
///    presentarlo como "necesitas autorizar" metía al ciudadano en un bucle sin
///    salida: iba a Preferencias, veía la cláusula aceptada, volvía y seguía el
///    403 (MD-2). Sale como error reintentable, igual que un 500.
void checkIntermediacionAuthorization(final Response<Object?> response) {
  if (isIntermediacionAuthorizationRequired(response.data)) {
    throw const MyDataAuthorizationRequired();
  }
  if (response.statusCode == 403) {
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: const NetworkError(message: 'Server error 403: rechazo sin sobre de autorización', statusCode: 403),
    );
  }
}

/// `true` cuando el sobre expresa que la consulta requiere autorización
/// (cláusula sin aceptar).
///
/// Delega en [isAuthorizationRequiredEnvelope]: el sobre es de la fachada, no
/// de Mis Datos, y lo comparten notificaciones, carnets y vivienda.
bool isIntermediacionAuthorizationRequired(final Object? data) => isAuthorizationRequiredEnvelope(data);
