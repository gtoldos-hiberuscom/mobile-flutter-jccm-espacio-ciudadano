import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';

/// Códigos con los que la fachada expresa "falta la autorización/cláusula".
///
/// `412.00` en `codigo-respuesta`, o `3034` dentro de `info-error.errores`. El
/// `mensaje-respuesta` que los acompaña ("No se pudo dar de alta el soporte")
/// es ruido: es el mensaje del endpoint de soporte reutilizado como negativa
/// genérica, así que **no** se usa para reconocer el sobre.
const String _authorizationResponseCode = '412.00';
const String _authorizationErrorCode = '3034';

/// `true` cuando el sobre expresa que la consulta requiere autorización.
///
/// Sirve tanto para un 2xx con sobre de negocio como para el cuerpo de un error
/// HTTP (la fachada lo devuelve con 403).
///
/// **Reconocer el sobre no significa saber qué falta.** El gateway falla
/// cerrado: cuando no puede leer preferencias devuelve exactamente esto, así
/// que es indistinguible de una revocación real. Quien lo reciba debe
/// resolverlo contra una lectura fresca de `/clausulas`
/// (`ResolveAuthorizationFailureUsecase`), nunca darlo por revocación.
bool isAuthorizationRequiredEnvelope(final Object? data) {
  final decoded = decodeApiEnvelope(data);
  if (decoded == null) {
    return false;
  }
  if (decoded['codigo-respuesta']?.toString() == _authorizationResponseCode) {
    return true;
  }
  final infoError = decoded['info-error'];
  if (infoError is! Map) {
    return false;
  }
  final errors = infoError['errores'];
  return errors is List && errors.whereType<Map<dynamic, dynamic>>().any((final error) => error['codigo-error']?.toString() == _authorizationErrorCode);
}

/// Falta la autorización para esta consulta, sin saber todavía cuál.
///
/// La lanza la capa de datos al reconocer el sobre; la de presentación la
/// resuelve. No se muestra nunca al usuario: es una señal interna.
final class AuthorizationRequiredException implements Exception {
  const AuthorizationRequiredException({this.statusCode, this.path});

  /// Estado HTTP con el que llegó el sobre (403 en la fachada), o `null` si
  /// vino en un 2xx.
  final int? statusCode;

  /// Ruta que lo devolvió, solo para trazas.
  final String? path;

  @override
  String toString() => 'AuthorizationRequiredException(status: $statusCode, path: $path)';
}
