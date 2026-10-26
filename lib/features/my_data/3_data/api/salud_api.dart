import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

/// Cliente de las operaciones de salud orientadas al recurso ciudadano.
///
/// Rutas `/api/v1/ciudadanos/{id}/salud/...`. Ya existen en la fachada, y el
/// gateway de Espacio Ciudadano las expondrá con las mismas rutas cuando se
/// ponga delante.
///
/// El valor de `{id}` **depende de la operación**: la fachada declara
/// `{numDocumento}` en CIP y primaria, y `{idAgente}` en hospitalaria. Con el
/// gateway todas aceptarán `sub_alt`. Quien llama decide cuál enviar; ver
/// `citizenEndpointIdsProvider`.
///
/// Tratamiento de los códigos de respuesta:
///
/// - **403** (cláusula 1 sin aceptar, o identificador que no corresponde al del
///   token) se
///   traduce a [MyDataAuthorizationRequired] para que la pantalla ofrezca
///   autorizar en vez de afirmar que no hay datos.
/// - **404** se traduce a ausencia de datos.
/// - **401** se deja fallar a propósito: es la única forma de que
///   `AuthRefreshInterceptor` refresque la sesión y reintente. Aceptarlo como
///   respuesta válida desactivaría el refresco de token.
/// - **429** (rate limit) y **5xx** se dejan fallar para que lleguen a la
///   pantalla como error de servicio reintentable, no como listado vacío.
///
/// Se escribe a mano en lugar de usar el cliente generado porque el OpenAPI
/// publicado sigue siendo el de la fachada y no incluye estas rutas.
final class SaludApi {
  const SaludApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>?> getCip({required final String citizenId}) {
    return _get(_path(citizenId, 'cip'));
  }

  Future<Map<String, dynamic>?> getPrimaryCarePendingAppointments({required final String citizenId}) {
    return _get(
      _path(citizenId, 'primaria-citas-pendientes'),
      mapCipMissingError: true,
    );
  }

  Future<Map<String, dynamic>?> getPrimaryCarePastAppointments({
    required final String citizenId,
    final int page = 0,
  }) {
    return _get(
      _path(citizenId, 'primaria-citas-pasadas'),
      queryParameters: {'pagina': page},
      mapCipMissingError: true,
    );
  }

  Future<Map<String, dynamic>?> getHospitalPendingAppointments({required final String citizenId}) {
    return _get(_path(citizenId, 'hospitalaria-citas-pendientes'));
  }

  Future<Map<String, dynamic>?> getHospitalPastAppointments({required final String citizenId}) {
    return _get(_path(citizenId, 'hospitalaria-citas-pasadas'));
  }

  String _path(final String citizenId, final String operation) {
    return '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/salud/$operation';
  }

  Future<Map<String, dynamic>?> _get(
    final String path, {
    final Map<String, Object?>? queryParameters,
    final bool mapCipMissingError = false,
  }) async {
    // Lo que no acepta `isHandledIntermediacionStatus` sale como `DioException`,
    // ya mapeada a `AppError` por `ErrorInterceptor`: el 401 tras un refresco
    // fallido, el 429 y los 5xx llegan a la pantalla como error de servicio,
    // nunca como "sin datos".
    final Response<Object?> response;
    try {
      response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: Options(validateStatus: isHandledIntermediacionStatus),
      );
    } on DioException catch (error) {
      // Las dos consultas de primaria clasifican el 3031 igual: para un
      // ciudadano sin CIP SESCAM lo devuelve en ambas, y tratarlo distinto
      // en cada pestaña contaba dos cosas contradictorias (JCCMEC-266).
      if (mapCipMissingError && _containsErrorCode(error.response?.data, '3031')) {
        throw const MyDataHealthCipMissing();
      }
      rethrow;
    }

    checkIntermediacionAuthorization(response);
    return response.statusCode == 404 ? null : decodeApiEnvelope(response.data);
  }

  bool _containsErrorCode(final Object? value, final String expectedCode) {
    bool visit(final Object? node) {
      if (node is Map) {
        for (final entry in node.entries) {
          final key = entry.key?.toString().toLowerCase();
          if ((key == 'codigo-error' || key == 'codigoerror') && entry.value?.toString() == expectedCode) {
            return true;
          }
          if (visit(entry.value)) {
            return true;
          }
        }
      } else if (node is Iterable) {
        return node.any(visit);
      }
      return false;
    }

    return visit(decodeApiEnvelope(value) ?? value);
  }
}
