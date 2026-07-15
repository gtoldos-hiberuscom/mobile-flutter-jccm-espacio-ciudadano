import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';

// Valores del enum `estado` del endpoint GET .../notificaciones.
// El DTO indexado no expone el estado por notificación, así que para "Todo"
// consultamos cada estado y etiquetamos el resultado con el estado consultado.
const List<String> _kEstadosConocidos = ['pendiente', 'expirada', 'aceptada', 'rechazada'];

final class GestionNotificacionesRepositoryImpl implements GestionNotificacionesRepository {
  GestionNotificacionesRepositoryImpl({required final Dio dio}) : _api = CiudadanosApi(withGeneratedApiCompat(dio), standardSerializers);

  final CiudadanosApi _api;

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
    try {
      final response = await _api.obtenerNotificacionesCiudadano(
        id: citizenId,
        estado: estado,
        extra: {
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
        },
        validateStatus: (final status) => status != null && status < 500,
      );

      if (response.statusCode == 404) {
        return const [];
      }

      final data = response.data;
      if (data != null) {
        return data.map((final dto) => _toNotificacionDto(dto, estado)).toList(growable: false);
      }

      return _rawNotificaciones(response.extra[generatedApiRawResponseDataExtraKey], estado);
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

  Notificacion _toNotificacionDto(final NotificacionIndexaDto data, final String estado) {
    return Notificacion(
      id: data.idNotificacion ?? 0,
      concepto: _emptyToNull(data.concepto) ?? '',
      procedimientoDenominacion: _emptyToNull(data.procedimientoAdministrativo?.denominacion) ?? '',
      fechaCaducidad: data.fechaCaducidad,
      procedimientoIdFicha: _emptyToNull(data.procedimientoAdministrativo?.idFicha),
      unidadOrganicaNombre: _emptyToNull(data.unidadOrganica?.nombre),
      sistemaOrigen: _emptyToNull(data.sistemaOrigen),
      estado: estado,
    );
  }

  List<Notificacion> _rawNotificaciones(final Object? data, final String estado) {
    final payload = switch (data) {
      final Map<dynamic, dynamic> map => map['body'],
      _ => data,
    };
    final items = switch (payload) {
      final List<dynamic> list => list,
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

  Notificacion _toNotificacionMap(final Map<String, Object?> data, final String estado) {
    final procRaw = data['procedimientoAdministrativo'];
    final procMap = procRaw is Map<String, Object?> ? procRaw : null;
    final unidadRaw = data['unidadOrganica'];
    final unidadMap = unidadRaw is Map<String, Object?> ? unidadRaw : null;
    final fechaStr = _string(data, 'fechaCaducidad');

    return Notificacion(
      id: _int(data, 'idNotificacion') ?? 0,
      concepto: _string(data, 'concepto') ?? '',
      procedimientoDenominacion: _string(procMap, 'denominacion') ?? '',
      fechaCaducidad: fechaStr != null ? DateTime.tryParse(fechaStr) : null,
      procedimientoIdFicha: _string(procMap, 'idFicha'),
      unidadOrganicaNombre: _string(unidadMap, 'nombre'),
      sistemaOrigen: _string(data, 'sistemaOrigen'),
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

  String? _emptyToNull(final String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
