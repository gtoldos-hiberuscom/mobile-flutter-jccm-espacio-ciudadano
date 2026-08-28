import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';

/// Cliente de hechos vitales y preferencias del recurso ciudadano.
///
/// Rutas `/api/v1/ciudadanos/{id}/hechos` y `/api/v1/ciudadanos/{id}/preferencias`.
/// El valor de `{id}` lo decide quien llama: `idAgente` contra la fachada y
/// `sub_alt` contra el gateway. Ver `citizenEndpointIdsProvider`.
///
/// No se altera `validateStatus`: los 4xx salen como `DioException` para que el
/// 401 llegue a `AuthRefreshInterceptor` y para que el repositorio pueda
/// inspeccionar el cuerpo de error.
final class HechosApi {
  const HechosApi(this._dio);

  final Dio _dio;

  /// Catálogo completo de hechos vitales con la marca de selección del agente.
  Future<Map<String, dynamic>?> obtenerHechos({required final String citizenId}) async {
    final response = await _dio.get<Object?>(_hechosPath(citizenId));
    return decodeApiEnvelope(response.data);
  }

  /// Graba la selección de hechos vitales.
  Future<void> actualizarHechos({
    required final String citizenId,
    required final Map<String, dynamic> body,
  }) async {
    await _dio.patch<Object?>(_hechosPath(citizenId), data: body);
  }

  /// Borra todas las preferencias del ciudadano: hechos vitales y cláusulas.
  ///
  /// Irreversible desde la perspectiva del usuario.
  Future<void> eliminarPreferencias({required final String citizenId}) async {
    await _dio.delete<Object?>('/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/preferencias');
  }

  String _hechosPath(final String citizenId) => '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/hechos';
}
