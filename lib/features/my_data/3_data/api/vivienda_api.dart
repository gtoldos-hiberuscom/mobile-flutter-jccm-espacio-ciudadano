import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

/// Cliente de las consultas de vivienda del recurso ciudadano.
///
/// Rutas `/api/v1/ciudadanos/{id}/vivienda/...`. El valor de `{id}` lo decide
/// quien llama: `numDocumento` contra la fachada y `sub_alt` contra el gateway.
/// Ambas operaciones requieren la cláusula 2 autorizada.
final class ViviendaApi {
  const ViviendaApi(this._dio);

  final Dio _dio;

  /// Datos de residencia/padrón (INE). Cuerpo `DTINECDRFREQ`.
  Future<Object?> datosResidencia({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) {
    return _post(citizenId, 'datos-residencia', body);
  }

  /// Datos catastrales. Cuerpo `DTCTROCDATREQ`.
  Future<Object?> datosCatastrales({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) {
    return _post(citizenId, 'datos-catastrales', body);
  }

  /// Mismo contrato de estados que `SaludApi`: 403 → [MyDataAuthorizationRequired],
  /// 404 → `null`, y todo lo demás (401 tras refresco fallido, 429, 4xx de
  /// negocio, 5xx) sale como `DioException` — nunca como «sin datos».
  Future<Object?> _post(final String citizenId, final String operation, final Map<String, Object?> body) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/vivienda/$operation',
      data: body,
      options: Options(validateStatus: isHandledIntermediacionStatus),
    );
    checkIntermediacionAuthorization(response);
    if (response.statusCode == 404) {
      return null;
    }
    return decodeApiEnvelope(response.data) ?? response.data;
  }
}
