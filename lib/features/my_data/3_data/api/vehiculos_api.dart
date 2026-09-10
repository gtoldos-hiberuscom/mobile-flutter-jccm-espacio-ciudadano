import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

/// Cliente del listado de vehículos (DGT) del recurso ciudadano.
///
/// Requiere la cláusula 2 autorizada.
final class VehiculosApi {
  const VehiculosApi(this._dio);

  /// Ruta de la operación.
  ///
  /// La documentación del gateway la llama `vehiculos/listado`, pero el OpenAPI
  /// de la fachada —generado desde el código— la expone como `vehiculos` a
  /// secas. Se sigue la fachada, por la misma regla que resolvió el segmento de
  /// ofertas de empleo: el gateway reescribe el identificador del path y reenvía
  /// el resto tal cual, así que quien resuelve la ruta es la fachada.
  static const String operationPath = 'vehiculos';

  final Dio _dio;

  /// Listado de vehículos. Cuerpo `DTDGTLISTADOVEHICULOSREQ`.
  ///
  /// Mismo contrato de estados que `SaludApi`: 403 → [MyDataAuthorizationRequired],
  /// 404 → `null`, y todo lo demás (401 tras refresco fallido, 429, 4xx de
  /// negocio, 5xx) sale como `DioException` — nunca como «sin datos».
  Future<Object?> listado({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/$operationPath',
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
