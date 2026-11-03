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
    return _getAppointments(citizenId, _path(citizenId, 'primaria-citas-pendientes'));
  }

  Future<Map<String, dynamic>?> getPrimaryCarePastAppointments({
    required final String citizenId,
    final int page = 0,
  }) {
    return _getAppointments(
      citizenId,
      _path(citizenId, 'primaria-citas-pasadas'),
      queryParameters: {'pagina': page},
    );
  }

  Future<Map<String, dynamic>?> getHospitalPendingAppointments({required final String citizenId}) {
    return _getAppointments(citizenId, _path(citizenId, 'hospitalaria-citas-pendientes'));
  }

  Future<Map<String, dynamic>?> getHospitalPastAppointments({required final String citizenId}) {
    return _getAppointments(citizenId, _path(citizenId, 'hospitalaria-citas-pasadas'));
  }

  String _path(final String citizenId, final String operation) {
    return '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/salud/$operation';
  }

  /// Consulta de citas. Cuando el servicio responde con error, la consulta
  /// del CIP es la única forma de saber qué ha pasado: el back todavía no
  /// distingue «sin CIP» de «sin citas» y SESCAM devuelve el mismo 3031 en
  /// los dos casos.
  ///
  /// - **Sin CIP** → [MyDataHealthCipMissing], sea cual sea el código: la
  ///   hospitalaria no responde con 3031, y sin CIP ninguna consulta de citas
  ///   puede salir bien.
  /// - **3031 con CIP** → `null`: el ciudadano no tiene citas.
  /// - **CIP no consultable, o cualquier otro error** → la `DioException` se
  ///   propaga como fallo de servicio. Nunca se afirma «no tienes CIP» ni «no
  ///   tienes citas» sin confirmarlo.
  Future<Map<String, dynamic>?> _getAppointments(
    final String citizenId,
    final String path, {
    final Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await _get(path, queryParameters: queryParameters);
    } on DioException catch (error) {
      final hasNoAppointmentsCode = _containsErrorCode(error.response?.data, '3031');
      final statusCode = error.response?.statusCode;
      if (!hasNoAppointmentsCode && (statusCode == null || statusCode < 500)) {
        rethrow;
      }
      switch (await _cipStatus(citizenId)) {
        case _CipStatus.missing:
          throw const MyDataHealthCipMissing();
        case _CipStatus.present when hasNoAppointmentsCode:
          return null;
        case _CipStatus.present:
        case _CipStatus.unknown:
          rethrow;
      }
    }
  }

  Future<Map<String, dynamic>?> _get(
    final String path, {
    final Map<String, Object?>? queryParameters,
  }) async {
    // Lo que no acepta `isHandledIntermediacionStatus` sale como `DioException`,
    // ya mapeada a `AppError` por `ErrorInterceptor`: el 401 tras un refresco
    // fallido, el 429 y los 5xx llegan a la pantalla como error de servicio,
    // nunca como "sin datos".
    final response = await _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
      options: Options(validateStatus: isHandledIntermediacionStatus),
    );

    checkIntermediacionAuthorization(response);
    return response.statusCode == 404 ? null : decodeApiEnvelope(response.data);
  }

  /// Un fallo de la propia consulta del CIP no confirma nada:
  /// [_CipStatus.unknown].
  Future<_CipStatus> _cipStatus(final String citizenId) async {
    final Map<String, dynamic>? envelope;
    try {
      envelope = await getCip(citizenId: citizenId);
    } on Exception {
      return _CipStatus.unknown;
    }
    final body = envelope?['body'];
    if (body is! Map) {
      return _CipStatus.missing;
    }
    final cip = body.entries.where((final entry) => entry.key.toString().toLowerCase() == 'cip').map((final entry) => entry.value?.toString().trim() ?? '').firstOrNull;
    return cip == null || cip.isEmpty ? _CipStatus.missing : _CipStatus.present;
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

enum _CipStatus { present, missing, unknown }
