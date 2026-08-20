import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';

/// Cliente de las recomendaciones (trámites segmentados por hechos vitales).
///
/// Envuelve `HechosVitalesApi.getServiciosSegmentados1` del cliente generado
/// (`GET /api/v1/ciudadanos/{idAgente}/recomendaciones`, API 1.86). Unifica las
/// dos operaciones anteriores: `hechos-vitales/servicios/{idAgente}` (todos) y
/// `hechos-vitales/servicios/segmentacion/{idAgente}` (segmentadas). La
/// diferencia está en el query `operacion`.
///
/// Requiere la cláusula 3 · Recomendaciones autorizada.
final class RecomendacionesApi {
  RecomendacionesApi(final Dio dio) : _api = HechosVitalesApi(withGeneratedApiCompat(dio), standardSerializers);

  final HechosVitalesApi _api;

  /// Devuelve la carga cruda, incluida la de los 4xx: el backend informa ahí los
  /// códigos de negocio (`404.01` sin resultados, `412.00` sin autorización) que
  /// el repositorio traduce a listado vacío.
  ///
  /// El 401 queda fuera para que salga como `DioException` y
  /// `AuthRefreshInterceptor` refresque la sesión.
  ///
  /// El query `hechosvitales` del contrato no se envía: con él el backend
  /// devuelve vacío incluso con hechos configurados, mientras que sin él
  /// responde todos los trámites de los hechos del ciudadano — el
  /// comportamiento confirmado con el cliente. El filtrado por hechos se hace
  /// en presentación.
  Future<Object?> obtener({
    required final String citizenId,
    final String? operacion,
    final String? size,
    final String? page,
    final String? ultimosDias,
  }) async {
    final response = await _api.getServiciosSegmentados1(
      idAgente: citizenId,
      operacion: operacion,
      size: size,
      page: page,
      ultimosDias: ultimosDias,
      extra: const {generatedApiDecodeStringResponseExtraKey: true},
      validateStatus: (final status) => status != null && status < 500 && status != 401,
    );
    return response.extra[generatedApiRawResponseDataExtraKey];
  }
}
