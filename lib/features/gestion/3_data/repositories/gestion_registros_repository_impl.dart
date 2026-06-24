import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_registros_repository.dart';

final class GestionRegistrosRepositoryImpl implements GestionRegistrosRepository {
  const GestionRegistrosRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Registro>> loadEntradas({required final String documentNumber}) async {
    return _fetchRegistros('/api/v1/publicacion/selectbynifentrada', documentNumber);
  }

  @override
  Future<List<Registro>> loadSalidas({required final String documentNumber}) async {
    return _fetchRegistros('/api/v1/publicacion/selectbynifsalida', documentNumber);
  }

  Future<List<Registro>> _fetchRegistros(final String endpoint, final String documentNumber) async {
    final response = await _dio.post<Object?>(
      endpoint,
      data: {'numerodocumento': documentNumber},
      options: Options(
        responseType: ResponseType.plain,
        validateStatus: (final status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 404) {
      return const [];
    }

    final payload = _decode(response.data);
    final root = _asMap(payload);
    if (root == null) {
      return const [];
    }

    final portalNode = _asMap(root['publicacionportal']);
    final itemsNode = portalNode?['item'];

    final items = switch (itemsNode) {
      final List<dynamic> list => list,
      final Map<dynamic, dynamic> single => [single],
      _ => const <dynamic>[],
    };

    return items
        .map(_asMap)
        .whereType<Map<String, Object?>>()
        .map(_toRegistro)
        .where((final r) => r.numregistro.isNotEmpty)
        .toList(growable: false);
  }

  Registro _toRegistro(final Map<String, Object?> data) {
    return Registro(
      numregistro: _string(data, 'registro') ?? '',
      titulo:
          _string(data, 'asunto') ??
          _string(data, 'titulo') ??
          _string(data, 'desasunto') ??
          _string(data, 'descrip') ??
          '',
      fecha: _string(data, 'fechareg'),
      consejeria: _string(data, 'desconsej'),
    );
  }

  Object? _decode(final Object? raw) {
    Object? current = raw;
    for (var i = 0; i < 3; i++) {
      if (current is! String) {
        return current;
      }
      final trimmed = current.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        current = jsonDecode(trimmed);
      } on FormatException {
        return trimmed;
      }
    }
    return current;
  }

  Map<String, Object?>? _asMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return {
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  String? _string(final Map<String, Object?> map, final String key) {
    final value = map[key];
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }
}
