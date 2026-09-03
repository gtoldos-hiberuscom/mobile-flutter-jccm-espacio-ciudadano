import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/mappers/notificacion_estado_mapper.dart';

/// Tamaño de página del listado de notificaciones.
///
/// La pestaña "Todo" barre los cuatro estados, así que cada página de más son
/// cuatro peticiones de más: con 10 (el ejemplo del swagger) un ciudadano con
/// ~45 aceptadas costaba 9 peticiones por visita.
///
/// **Asume que el gateway respeta el `size` pedido**, porque la paginación se
/// detiene en la primera página incompleta. Si el backend recortara el tamaño
/// por su cuenta, la primera página parecería la última y se perderían
/// notificaciones: hay que comprobarlo en UAT antes de mergear.
const int _kNotificationsPageSize = 50;

final class GestionNotificacionesRepositoryImpl implements GestionNotificacionesRepository {
  GestionNotificacionesRepositoryImpl({required final Dio dio}) : _dio = withGeneratedApiCompat(dio), _api = CiudadanosApi(withGeneratedApiCompat(dio), standardSerializers);

  final Dio _dio;
  final CiudadanosApi _api;

  @override
  Future<NotificacionDetalle> loadNotificacion({
    required final String citizenId,
    required final int notificacionId,
    final NotificacionEstado? fallbackEstado,
    final String? sistemaOrigen,
  }) async {
    final Response<Object?> response;
    try {
      response = await _api.obtenerNotificacion(
        id: citizenId,
        notificacionId: notificacionId,
        sisOrigen: sistemaOrigen,
        extra: {generatedApiDecodeStringResponseExtraKey: true},
      );
    } on DioException catch (error) {
      _throwIfAuthorizationRequired(
        error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey],
        statusCode: error.response?.statusCode,
        path: 'notificaciones/$notificacionId',
      );
      rethrow;
    }
    final raw = response.extra[generatedApiRawResponseDataExtraKey];
    final body = _bodyMap(raw, notificacionId);
    return _toDetalle(body, requestedId: notificacionId, fallbackEstado: fallbackEstado, fallbackSistema: sistemaOrigen);
  }

  @override
  Future<void> transitionNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String accion,
    final String? sistemaOrigen,
    final String? justificacion,
  }) async {
    // API 1.86: el endpoint de transiciones con cuerpo (TransicionDto) fue
    // sustituido por POST .../notificaciones/{id}/comparecer sin cuerpo. La
    // acción y la justificación ya no viajan al backend, que aplica la
    // transición según sus reglas de negocio; se conserva la validación de
    // acciones conocidas para no silenciar llamadas erróneas.
    const supportedActions = {'COMPARECER', 'ACEPTAR', 'RECHAZAR'};
    final normalizedAction = accion.trim().toUpperCase();
    if (!supportedActions.contains(normalizedAction)) {
      throw ArgumentError.value(accion, 'accion', 'Transición no soportada');
    }
    await _api.transicionNotificacion(
      id: citizenId,
      notificacionId: notificacionId,
      sisOrigen: sistemaOrigen,
      extra: const {
        generatedApiDecodeStringResponseExtraKey: true,
      },
    );
  }

  @override
  Future<List<int>> downloadDocumento({
    required final String citizenId,
    required final int notificacionId,
    required final int orden,
    final String? sistemaOrigen,
  }) async {
    final response = await _api.descargarDocumento(
      id: citizenId,
      notificacionId: notificacionId,
      orden: orden,
      sisOrigen: sistemaOrigen,
    );
    return response.data?.toList(growable: false) ?? const [];
  }

  @override
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final NotificacionEstado? estado,
  }) async {
    if (estado != null) {
      return _loadForEstado(citizenId: citizenId, estado: estado);
    }
    // "Todo": el listado indexado no informa el estado de cada elemento, y sin
    // estado la tarjeta no puede pintar ni la etiqueta ni la fecha de
    // expiración. El parámetro `estado` del contrato es un enum cerrado, así
    // que se consultan los cuatro en paralelo y cada elemento queda etiquetado
    // con el estado por el que se encontró (`_toNotificacionMap`).
    //
    // `Future.wait` espera a los cuatro y propaga el primer error: si un estado
    // falla, "Todo" falla — nunca se muestra una lista incompleta como si
    // estuviera completa. Un 404 no es fallo, ya se traduce a lista vacía.
    final sweeps = await Future.wait(
      NotificacionEstado.values.map(
        (final value) => _loadForEstado(citizenId: citizenId, estado: value),
      ),
    );
    return _mergeSweeps(sweeps);
  }

  /// Fusiona por `id` los barridos de "Todo", recorridos en orden de enum y
  /// resolviendo las colisiones con [pickByNotificacionEstadoPrecedence]: un
  /// elemento solo aparece en dos barridos si transitó durante la consulta.
  ///
  /// El resultado se ordena con [compareNotificacionesForInbox]: al fusionar
  /// cuatro listas filtradas no queda ningún orden del backend que preservar,
  /// así que "Todo" define el suyo en vez de heredar el del mapa.
  List<Notificacion> _mergeSweeps(final List<List<Notificacion>> sweeps) {
    final merged = <int, Notificacion>{};
    for (final sweep in sweeps) {
      for (final notification in sweep) {
        final current = merged[notification.id];
        merged[notification.id] = current == null ? notification : pickByNotificacionEstadoPrecedence(current, notification);
      }
    }
    return merged.values.toList()..sort(compareNotificacionesForInbox);
  }

  Future<List<Notificacion>> _loadForEstado({
    required final String citizenId,
    required final NotificacionEstado estado,
  }) async {
    final notifications = <int, Notificacion>{};
    for (var page = 0; ; page++) {
      final pageNotifications = await _loadPageForEstado(
        citizenId: citizenId,
        estado: estado,
        page: page,
      );
      final previousLength = notifications.length;
      for (final notification in pageNotifications) {
        notifications[notification.id] = notification;
      }

      if (pageNotifications.length < _kNotificationsPageSize || notifications.length == previousLength) {
        return notifications.values.toList(growable: false);
      }
    }
  }

  Future<List<Notificacion>> _loadPageForEstado({
    required final String citizenId,
    required final NotificacionEstado estado,
    required final int page,
  }) async {
    final encodedCitizenId = Uri.encodeComponent(citizenId);
    final estadoQuery = notificacionEstadoQueryValue(estado);
    try {
      final response = await _dio.get<Object?>(
        '/api/v1/ciudadanos/$encodedCitizenId/notificaciones',
        queryParameters: {
          'estado': estadoQuery,
          'page': page,
          'size': _kNotificationsPageSize,
        },
        options: Options(
          validateStatus: (final status) => status == 404 || (status != null && status >= 200 && status < 300),
        ),
      );

      if (response.statusCode == 404) {
        return const [];
      }
      _throwIfAuthorizationRequired(
        response.data,
        statusCode: response.statusCode,
        path: 'notificaciones',
      );
      return _rawNotificaciones(response.data, estado);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      _throwIfAuthorizationRequired(
        rawData,
        statusCode: error.response?.statusCode,
        path: 'notificaciones',
      );
      final parsed = _rawNotificaciones(rawData, estado);
      if (parsed.isNotEmpty) {
        return parsed;
      }
      rethrow;
    }
  }

  /// Traduce el sobre de autorización de la fachada a una señal tipada.
  ///
  /// La fachada lo devuelve con 403, pero también aparece dentro de un 2xx, así
  /// que se comprueban los dos caminos. Quien lo resuelve es
  /// `withAuthorizationGuard`: aquí no se sabe **qué** autorización falta, y el
  /// sobre tampoco distingue una revocación de un fallo de preferencias.
  void _throwIfAuthorizationRequired(
    final Object? data, {
    required final String path,
    final int? statusCode,
  }) {
    if (isAuthorizationRequiredEnvelope(data)) {
      throw AuthorizationRequiredException(statusCode: statusCode, path: path);
    }
  }

  List<Notificacion> _rawNotificaciones(final Object? data, final NotificacionEstado estado) {
    final payload = _notificationPayload(data);
    final items = switch (payload) {
      final List<dynamic> list => list,
      final Map<dynamic, dynamic> map when _hasNotificationId(map) => [map],
      _ => const <dynamic>[],
    };
    return items
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (final item) => <String, Object?>{
            for (final entry in item.entries)
              if (entry.key != null) entry.key.toString(): entry.value,
          },
        )
        .map((final map) => _toNotificacionMap(map, estado))
        .nonNulls
        .toList(growable: false);
  }

  Object? _notificationPayload(final Object? data) {
    Object? current = data;
    for (var i = 0; i < 3 && current is String; i++) {
      try {
        current = jsonDecode(current);
      } on FormatException {
        return current;
      }
    }
    if (current is! Map<dynamic, dynamic>) {
      return current;
    }
    for (final key in const ['body', 'content', 'items', 'notificaciones', 'results', 'data']) {
      if (current.containsKey(key)) {
        return _notificationPayload(current[key]);
      }
    }
    return current;
  }

  bool _hasNotificationId(final Map<dynamic, dynamic> data) => data.containsKey('idNotificacion') || data.containsKey('id');

  /// `null` cuando el elemento no trae un id utilizable.
  ///
  /// Esta capa indexa por id cuanto hace con un listado: la acumulación de
  /// páginas de un estado y la fusión de los cuatro barridos de la pestaña
  /// "Todo". Un id fabricado (antes `?? 0`) convertía **dos notificaciones
  /// distintas sin id en una sola tarjeta**, con los datos de una y el estado de
  /// la otra al resolver la precedencia entre barridos; y podía cortar la
  /// paginación antes de tiempo, porque una página que no aporta ids nuevos se
  /// interpreta como final del listado.
  Notificacion? _toNotificacionMap(final Map<String, Object?> data, final NotificacionEstado estado) {
    final id = _int(data, 'idNotificacion') ?? _int(data, 'id');
    if (id == null) {
      // Solo las claves, nunca los valores: el concepto de una notificación es
      // dato personal.
      logger.w('[notificaciones] elemento sin id utilizable descartado (claves: ${data.keys.join(', ')})');
      return null;
    }
    final procMap = _map(data['procedimientoAdministrativo']);
    final unidadMap = _map(data['unidadOrganica']);
    final fechaStr = _string(data, 'fechaCaducidad') ?? _string(data, 'fecCaducidad') ?? _string(data, 'fechaExpiracion');

    return Notificacion(
      id: id,
      concepto: _string(data, 'concepto') ?? _string(data, 'descripcion') ?? '',
      procedimientoDenominacion: _string(procMap, 'denominacion') ?? _additional(procMap, 'denominacion') ?? '',
      fechaCaducidad: fechaStr != null ? DateTime.tryParse(fechaStr) : null,
      procedimientoIdFicha: _string(procMap, 'idFicha'),
      unidadOrganicaNombre: _string(unidadMap, 'nombre') ?? _additional(unidadMap, 'nombre'),
      sistemaOrigen: _string(data, 'sistemaOrigen') ?? _string(unidadMap, 'sistema'),
      // El DTO indexado no informa el estado; cuando el elemento no lo trae,
      // el estado conocido es el que se consultó. Todo listado se pide filtrando
      // por un estado (también "Todo", que pide los cuatro), así que aquí nunca
      // queda `null` — y desde luego nunca `''`, que la UI leía como expirada.
      estado: notificacionEstadoFromBackend(_string(data, 'estado')) ?? estado,
    );
  }

  int? _int(final Map<String, Object?>? map, final String key) {
    if (map == null) {
      return null;
    }
    return switch (map[key]) {
      final int v => v,
      final double v => v.toInt(),
      final String v => int.tryParse(v),
      _ => null,
    };
  }

  String? _string(final Map<String, Object?>? map, final String key) {
    if (map == null) {
      return null;
    }
    final val = map[key];
    if (val is String) {
      final trimmed = val.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  Map<String, Object?> _bodyMap(final Object? raw, final int id) {
    Object? value = raw;
    if (value is String) {
      try {
        value = jsonDecode(value);
      } on FormatException {
        throw const FormatException('Respuesta de detalle no válida.');
      }
    }
    if (value is Map<Object?, Object?>) {
      value = value['body'] ?? value;
    }
    if (value is List) {
      final items = value.whereType<Map<Object?, Object?>>().toList(growable: false);
      if (items.isEmpty) {
        throw const FormatException('El detalle de la notificación está vacío.');
      }
      value = items.firstWhere(
        (final item) => _int(_stringKeyMap(item), 'idNotificacion') == id,
        orElse: () => items.first,
      );
    }
    if (value is! Map<Object?, Object?>) {
      throw const FormatException('El detalle de la notificación está vacío.');
    }
    return _stringKeyMap(value);
  }

  Map<String, Object?> _stringKeyMap(final Map<dynamic, dynamic> source) => {
    for (final entry in source.entries) entry.key.toString(): entry.value,
  };

  NotificacionDetalle _toDetalle(
    final Map<String, Object?> data, {
    required final int requestedId,
    final NotificacionEstado? fallbackEstado,
    final String? fallbackSistema,
  }) {
    final unidad = _map(data['unidadOrganica']);
    final procedimiento = _map(data['procedimientoAdministrativo']);
    final expediente = _map(data['expediente']);
    final historico = _list(data['historicoEstados']);
    DateTime? dateFor(final String state) {
      for (final item in historico.reversed) {
        final map = _map(item);
        if (map != null && (_string(map, 'estado') ?? '').toUpperCase() == state) {
          return _date(map['fecha-cambio'] ?? map['fechaCambio']);
        }
      }
      return null;
    }

    final docs = _list(data['documentos']).indexed
        .map((final entry) {
          final (index, item) = entry;
          final map = _map(item);
          final nested = _map(map?['documento']);
          final name = _documentName(map) ?? _documentName(nested);
          if (name == null) {
            return null;
          }
          final order = _int(map, 'orden') ?? index + 1;
          return NotificacionDocumento(
            orden: order,
            nombre: name,
            tamanoBytes: _int(map, 'tamano') ?? _int(map, 'tamanoBytes') ?? _int(nested, 'tamano') ?? _int(nested, 'tamanoBytes'),
          );
        })
        .nonNulls
        .toList(growable: false);
    return NotificacionDetalle(
      // El detalle se pide POR id, así que si el sobre no lo repite se conoce
      // igualmente: el respaldo es el id consultado, no un 0 fabricado.
      id: _int(data, 'id') ?? _int(data, 'idNotificacion') ?? requestedId,
      titulo: _string(data, 'concepto') ?? _string(data, 'descripcion') ?? 'Notificación',
      estado: notificacionEstadoFromBackend(_string(data, 'estado')) ?? fallbackEstado,
      organismo: _string(data, 'organismo') ?? _string(unidad, 'nombre') ?? _additional(unidad, 'nombre'),
      procedimiento: _string(data, 'procedimiento') ?? _string(procedimiento, 'idFicha') ?? _string(procedimiento, 'denominacion') ?? _additional(procedimiento, 'denominacion'),
      expediente: _string(data, 'numeroExpediente') ?? _string(expediente, 'identificador'),
      fechaPuestaDisposicion: _date(data['fechaPuestaDisposicion'] ?? data['fecAlta']) ?? dateFor('PUESTO_A_DISPOSICION'),
      fechaExpiracion: _date(data['fechaExpiracion'] ?? data['fechaCaducidad'] ?? data['fecCaducidad']),
      fechaLectura: _date(data['fechaLectura']) ?? dateFor('ACEPTADA') ?? dateFor('RECHAZADA'),
      sistemaOrigen: _string(data, 'sistemaOrigen') ?? _string(unidad, 'sistema') ?? fallbackSistema,
      documentos: docs,
    );
  }

  Map<String, Object?>? _map(final Object? value) => value is Map ? _stringKeyMap(value) : null;
  List<Object?> _list(final Object? value) => value is List ? value.cast<Object?>() : const [];
  DateTime? _date(final Object? value) => value is String ? DateTime.tryParse(value) : null;
  String? _documentName(final Map<String, Object?>? map) => _string(map, 'nombre') ?? _string(map, 'nombreFichero') ?? _string(map, 'nombreDocumento') ?? _string(map, 'titulo') ?? _string(map, 'descripcion');

  String? _additional(final Map<String, Object?>? map, final String key) {
    for (final item in _list(map?['informacionAdicional'])) {
      final entry = _map(item);
      if (_string(entry, 'clave') == key) {
        return _string(entry, 'valor');
      }
    }
    return null;
  }
}
