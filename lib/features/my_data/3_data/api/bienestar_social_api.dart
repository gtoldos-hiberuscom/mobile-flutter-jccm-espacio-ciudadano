import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

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

  /// Mismo contrato de estados que el resto de APIs de intermediación:
  /// 403 → [MyDataAuthorizationRequired], 404 → `null`, y todo lo demás (401
  /// tras refresco fallido, 429, 4xx de negocio, 5xx) sale como
  /// `DioException`.
  ///
  /// Antes aceptaba como válido **cualquier** código < 500: el sobre de un 403
  /// o de un 400 se parseaba como datos y la pantalla afirmaba que el
  /// ciudadano no tiene título de familia numerosa, discapacidad, termalismo,
  /// dependencia ni tarjeta de estacionamiento. El sobre de negocio con
  /// `412.00`/`3034` en un 2xx lo sigue reconociendo el repositorio.
  Future<Object?> _post(final String citizenId, final String operation, final Map<String, Object?> body) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/bienestar-social/$operation',
      data: body,
      options: Options(validateStatus: isHandledIntermediacionStatus),
    );
    if (response.statusCode == 403) {
      throw const MyDataAuthorizationRequired();
    }
    if (response.statusCode == 404) {
      return null;
    }
    return decodeApiEnvelope(response.data) ?? response.data;
  }
}
