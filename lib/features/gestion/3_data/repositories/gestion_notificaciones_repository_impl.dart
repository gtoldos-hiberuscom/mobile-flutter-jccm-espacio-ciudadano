import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';

// Valores del enum `estado` del endpoint GET .../notificaciones.
// El DTO indexado no expone el estado por notificación, así que para "Todo"
// consultamos cada estado y etiquetamos el resultado con el estado consultado.
const List<String> _kEstadosConocidos = ['pendiente', 'expirada', 'aceptada', 'rechazada'];
const int _kNotificationsPageSize = 100;

final class GestionNotificacionesRepositoryImpl implements GestionNotificacionesRepository {
  GestionNotificacionesRepositoryImpl({required final Dio dio}) : _dio = withGeneratedApiCompat(dio), _api = CiudadanosApi(withGeneratedApiCompat(dio), standardSerializers);

  final Dio _dio;
  final CiudadanosApi _api;

  @override
  Future<NotificacionDetalle> loadNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String estado,
    final String? sistemaOrigen,
  }) async {
    final response = await _api.obtenerNotificacion(
      id: citizenId,
      notificacionId: notificacionId,
      sisOrigen: sistemaOrigen,
      extra: {generatedApiDecodeStringResponseExtraKey: true},
    );
    final raw = response.extra[generatedApiRawResponseDataExtraKey];
    final body = _bodyMap(raw, notificacionId);
    return _toDetalle(body, fallbackEstado: estado, fallbackSistema: sistemaOrigen);
  }

  @override
  Future<void> transitionNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String accion,
    final String? sistemaOrigen,
    final String? justificacion,
  }) async {
    if (accion.toUpperCase() != 'ACEPTAR') {
      throw UnsupportedError('UAT solo publica la comparecencia para aceptar notificaciones.');
    }

    final encodedCitizenId = Uri.encodeComponent(citizenId);
    await _dio.post<void>(
      '/api/v1/ciudadanos/$encodedCitizenId/notificaciones/$notificacionId/comparecer',
      options: Options(
        headers: {
          'sisOrigen': ?sistemaOrigen,
        },
      ),
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
    final String? estado,
  }) async {
    if (estado != null) {
      return _loadForEstado(citizenId: citizenId, estado: estado);
    }

    // "Todo": el DTO no trae estado y el backend no garantiza el conjunto
    // completo al omitir el filtro, así que consultamos cada estado en paralelo
    // y fusionamos. Toleramos fallos parciales; solo propagamos si todos fallan.
    final results = await Future.wait(
      _kEstadosConocidos.map(
        (final e) => _loadForEstado(citizenId: citizenId, estado: e).then<(List<Notificacion>?, Object?, StackTrace?)>((final list) => (list, null, null)).catchError((final Object error, final StackTrace stack) => (null, error, stack)),
      ),
    );

    final merged = <int, Notificacion>{};
    Object? lastError;
    StackTrace? lastStack;
    var anySuccess = false;
    for (final (list, error, stack) in results) {
      if (list != null) {
        anySuccess = true;
        for (final notif in list) {
          merged.putIfAbsent(notif.id, () => notif);
        }
      } else if (error != null) {
        lastError = error;
        lastStack = stack;
      }
    }

    if (!anySuccess && lastError != null) {
      Error.throwWithStackTrace(lastError, lastStack ?? StackTrace.current);
    }
    return merged.values.toList(growable: false);
  }

  Future<List<Notificacion>> _loadForEstado({
    required final String citizenId,
    required final String estado,
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
    required final String estado,
    required final int page,
  }) async {
    final encodedCitizenId = Uri.encodeComponent(citizenId);
    try {
      final response = await _dio.get<Object?>(
        '/api/v1/ciudadanos/$encodedCitizenId/notificaciones',
        queryParameters: {
          'estado': estado,
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
      return _rawNotificaciones(response.data, estado);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      final parsed = _rawNotificaciones(rawData, estado);
      if (parsed.isNotEmpty) {
        return parsed;
      }
      rethrow;
    }
  }

  List<Notificacion> _rawNotificaciones(final Object? data, final String estado) {
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

  Notificacion _toNotificacionMap(final Map<String, Object?> data, final String estado) {
    final procMap = _map(data['procedimientoAdministrativo']);
    final unidadMap = _map(data['unidadOrganica']);
    final fechaStr = _string(data, 'fechaCaducidad') ?? _string(data, 'fecCaducidad') ?? _string(data, 'fechaExpiracion');

    return Notificacion(
      id: _int(data, 'idNotificacion') ?? _int(data, 'id') ?? 0,
      concepto: _string(data, 'concepto') ?? _string(data, 'descripcion') ?? '',
      procedimientoDenominacion: _string(procMap, 'denominacion') ?? _additional(procMap, 'denominacion') ?? '',
      fechaCaducidad: fechaStr != null ? DateTime.tryParse(fechaStr) : null,
      procedimientoIdFicha: _string(procMap, 'idFicha'),
      unidadOrganicaNombre: _string(unidadMap, 'nombre') ?? _additional(unidadMap, 'nombre'),
      sistemaOrigen: _string(data, 'sistemaOrigen') ?? _string(unidadMap, 'sistema'),
      estado: estado,
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
    required final String fallbackEstado,
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

    final docs = _list(data['documentos'])
        .map((final item) {
          final map = _map(item);
          final nested = _map(map?['documento']);
          final order = _int(map, 'orden') ?? 0;
          return NotificacionDocumento(
            orden: order,
            nombre: _string(map, 'nombre') ?? _string(map, 'nombreFichero') ?? _string(nested, 'nombre') ?? 'Documento $order.pdf',
            tamanoBytes: _int(map, 'tamano') ?? _int(map, 'tamanoBytes'),
          );
        })
        .toList(growable: false);
    return NotificacionDetalle(
      id: _int(data, 'id') ?? _int(data, 'idNotificacion') ?? 0,
      titulo: _string(data, 'concepto') ?? _string(data, 'descripcion') ?? 'Notificación',
      estado: (_string(data, 'estado') ?? fallbackEstado).toLowerCase(),
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
