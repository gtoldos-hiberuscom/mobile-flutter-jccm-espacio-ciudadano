import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';

/// Cliente de las consultas de educación del recurso ciudadano.
///
/// Rutas `/api/v1/ciudadanos/{id}/educacion/...`. El valor de `{id}` lo decide
/// quien llama: `numDocumento` contra la fachada y `sub_alt` contra el gateway.
/// Ambas operaciones requieren la cláusula 2 autorizada.
final class EducacionApi {
  const EducacionApi(this._dio);

  final Dio _dio;

  Future<Object?> titulosUniversitarios({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) {
    return _post(citizenId, 'titulos-universitarios', body);
  }

  Future<Object?> titulosNoUniversitarios({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) {
    return _post(citizenId, 'titulos-no-universitarios', body);
  }

  /// Devuelve la carga cruda, incluida la de los 4xx, donde el backend informa
  /// los errores de negocio. El 401 queda fuera para que salga como
  /// `DioException` y `AuthRefreshInterceptor` refresque la sesión.
  Future<Object?> _post(final String citizenId, final String operation, final Map<String, Object?> body) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/educacion/$operation',
      data: body,
      options: Options(validateStatus: (final status) => status != null && status < 500 && status != 401),
    );
    if (response.statusCode == 404) {
      return null;
    }
    return decodeApiEnvelope(response.data) ?? response.data;
  }
}
