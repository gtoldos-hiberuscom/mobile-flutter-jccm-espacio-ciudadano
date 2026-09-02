import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';

/// Cliente de las consultas de empleo del recurso ciudadano.
///
/// Rutas `/api/v1/ciudadanos/{id}/empleo/...`. El valor de `{id}` lo decide
/// quien llama: contra el gateway ambas operaciones aceptan `sub_alt`, y contra
/// la fachada cada una declara el suyo (`idAgente` en ofertas, `numDocumento`
/// en demandante). Ver `citizenEndpointIdsProvider`.
final class EmpleoApi {
  const EmpleoApi(this._dio);

  /// Segmento de las ofertas inscritas.
  ///
  /// La documentación del gateway lo llama `ofertas-empleo`, pero el nombre real
  /// es `ofertas`, el del OpenAPI de la fachada. Confirmado contra UAT: con
  /// `ofertas-empleo` el gateway autentica, traduce `sub_alt` a `idAgente` y
  /// reenvía, y es la fachada la que responde 404 informando la ruta ya
  /// reescrita (`/api/v1/ciudadanos/PER9998003/empleo/ofertas-empleo`). El
  /// gateway sustituye el identificador pero no toca el resto del path, así que
  /// donde las dos fuentes discrepan manda la fachada.
  static const String jobOffersOperation = 'ofertas';

  static const String jobSeekerOperation = 'demandante-empleo-fecha-actual';

  final Dio _dio;

  /// Ofertas de empleo en las que el ciudadano está inscrito.
  Future<Object?> ofertasEmpleo({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) {
    return _post(citizenId, jobOffersOperation, body);
  }

  /// Situación como demandante de empleo a fecha actual.
  Future<Object?> demandanteEmpleoFechaActual({
    required final String citizenId,
    required final Map<String, Object?> body,
  }) {
    return _post(citizenId, jobSeekerOperation, body);
  }

  /// Mismo contrato de estados que `SaludApi`: 403 → [MyDataAuthorizationRequired],
  /// 404 → `null`, y todo lo demás (401 tras refresco fallido, 429, 4xx de
  /// negocio, 5xx) sale como `DioException` — nunca como «sin datos» (ni,
  /// en el caso del demandante, como estado «Activa» fabricado).
  Future<Object?> _post(final String citizenId, final String operation, final Map<String, Object?> body) async {
    final response = await _dio.post<Object?>(
      '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/empleo/$operation',
      data: body,
      options: Options(validateStatus: _isHandledStatus),
    );
    if (response.statusCode == 403) {
      throw const MyDataAuthorizationRequired();
    }
    if (response.statusCode == 404) {
      return null;
    }
    return decodeApiEnvelope(response.data) ?? response.data;
  }

  /// Códigos que esta capa sabe interpretar. El resto debe fallar para que los
  /// interceptores de red hagan su trabajo.
  bool _isHandledStatus(final int? status) => status != null && (status < 400 || status == 403 || status == 404);
}
