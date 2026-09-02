import 'package:dio/dio.dart';
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

/// `true` cuando el sobre expresa que la consulta requiere autorización
/// (cláusula sin aceptar).
///
/// Delega en [isAuthorizationRequiredEnvelope]: el sobre es de la fachada, no
/// de Mis Datos, y lo comparten notificaciones, carnets y vivienda.
bool isIntermediacionAuthorizationRequired(final Object? data) => isAuthorizationRequiredEnvelope(data);
