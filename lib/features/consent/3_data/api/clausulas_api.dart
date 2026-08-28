import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';

/// Cliente de las cláusulas de consentimiento del recurso ciudadano.
///
/// Rutas `/api/v1/ciudadanos/{id}/clausulas`, publicadas tanto por la fachada
/// como por el gateway de Espacio Ciudadano. El valor de `{id}` lo decide quien
/// llama: `idAgente` contra la fachada y `sub_alt` contra el gateway, que lo
/// traduce. Ver `citizenEndpointIdsProvider`.
///
/// No se altera `validateStatus` a propósito: los 4xx deben salir como
/// `DioException` para que el 401 llegue a `AuthRefreshInterceptor` y para que
/// el repositorio pueda distinguir el 404 —sin cláusulas dadas de alta— y
/// reintentar con el verbo contrario.
final class ClausulasApi {
  const ClausulasApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>?> obtener({required final String citizenId}) async {
    final response = await _dio.get<Object?>(_path(citizenId));
    return decodeApiEnvelope(response.data);
  }

  /// Alta inicial de la selección de cláusulas.
  Future<void> enviar({
    required final String citizenId,
    required final Map<String, dynamic> body,
  }) async {
    await _dio.post<Object?>(_path(citizenId), data: body);
  }

  /// Actualización de una selección ya existente.
  Future<void> actualizar({
    required final String citizenId,
    required final Map<String, dynamic> body,
  }) async {
    await _dio.patch<Object?>(_path(citizenId), data: body);
  }

  String _path(final String citizenId) => '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/clausulas';
}
