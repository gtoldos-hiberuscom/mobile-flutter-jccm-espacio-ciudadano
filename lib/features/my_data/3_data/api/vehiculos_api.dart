import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';

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
  /// Devuelve la carga cruda, incluida la de los 4xx. El 401 queda fuera para
  /// que salga como `DioException` y `AuthRefreshInterceptor` refresque la
  /// sesión.
  Future<Object?> listado({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/$operationPath',
      data: body,
      options: Options(validateStatus: (final status) => status != null && status < 500 && status != 401),
    );
    if (response.statusCode == 404) {
      return null;
    }
    return decodeApiEnvelope(response.data) ?? response.data;
  }
}
