import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';

final class GestionNotificacionesRepositoryImpl implements GestionNotificacionesRepository {
  const GestionNotificacionesRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final String? estado,
  }) async {
    final response = await _dio.get<Object?>(
      '/api/v1/ciudadanos/$citizenId/notificaciones',
      queryParameters: {
        'estado': ?estado,
      },
      options: Options(
        validateStatus: (final status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 404) {
      return const [];
    }

    final data = response.data;
    if (data is! List) {
      return const [];
    }

    return data.whereType<Map<String, Object?>>().map(_toNotificacion).toList(growable: false);
  }

  Notificacion _toNotificacion(final Map<String, Object?> data) {
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
}
