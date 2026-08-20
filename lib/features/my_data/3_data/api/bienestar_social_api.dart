import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';

/// Cliente de las consultas de bienestar social por intermediación.
///
/// Rutas `/api/v1/ciudadanos/{id}/bienestar-social/...`. El valor de `{id}` lo
/// decide quien llama: contra la fachada cada operación declara el suyo
/// (`numDocumento` en familia numerosa, `idAgente` en el resto) y contra el
/// gateway todas aceptan `sub_alt`. Ver `citizenEndpointIdsProvider`.
final class BienestarSocialApi {
  const BienestarSocialApi(this._dio);

  final Dio _dio;

  Future<Object?> familiaNumerosa({required final String citizenId, required final Map<String, Object?> body}) {
    return _post(citizenId, 'familia-numerosa', body);
  }

  Future<Object?> discapacidad({required final String citizenId, required final Map<String, Object?> body}) {
    return _post(citizenId, 'discapacidad', body);
  }

  Future<Object?> termalismo({required final String citizenId, required final Map<String, Object?> body}) {
    return _post(citizenId, 'termalismo', body);
  }

  Future<Object?> atencionDependencia({required final String citizenId, required final Map<String, Object?> body}) {
    return _post(citizenId, 'atencion-dependencia', body);
  }

  Future<Object?> tarjetaEstacionamiento({required final String citizenId, required final Map<String, Object?> body}) {
    return _post(citizenId, 'tarjeta-estacionamiento', body);
  }

  /// Devuelve la carga útil cruda, incluida la de los 4xx: el backend informa
  /// ahí los errores de negocio (`codigo-respuesta` `412.00`, error `3034`) que
  /// el repositorio traduce a falta de autorización.
  ///
  /// El 401 queda fuera a propósito para que salga como `DioException` y
  /// `AuthRefreshInterceptor` pueda refrescar la sesión y reintentar.
  Future<Object?> _post(final String citizenId, final String operation, final Map<String, Object?> body) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/bienestar-social/$operation',
      data: body,
      options: Options(validateStatus: (final status) => status != null && status < 500 && status != 401),
    );
    if (response.statusCode == 404) {
      return null;
    }
    return decodeApiEnvelope(response.data) ?? response.data;
  }
}
