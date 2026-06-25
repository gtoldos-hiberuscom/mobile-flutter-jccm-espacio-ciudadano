import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';

final class GestionExpedienteRepositoryImpl implements GestionExpedienteRepository {
  const GestionExpedienteRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Expediente>> loadExpedientes({required final String documentNumber}) async {
    final response = await _dio.post<Object?>(
      '/api/v1/publicacion/misexpedientes',
      data: {'pnumdoc': documentNumber},
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

    final expedientesNode = root['expedientes'];
    final itemsNode = _asMap(expedientesNode)?['item'];

    final items = switch (itemsNode) {
      final List<dynamic> list => list,
      final Map<dynamic, dynamic> single => [single],
      _ => const <dynamic>[],
    };

    return items.map(_asMap).whereType<Map<String, Object?>>().map(_toExpediente).where((final e) => e.numexp.isNotEmpty).toList(growable: false);
  }

  Expediente _toExpediente(final Map<String, Object?> data) {
    return Expediente(
      numexp: _string(data, 'numexp') ?? '',
      titulo: _string(data, 'titulo') ?? _string(data, 'descrip') ?? _string(data, 'desproc') ?? '',
      consejeria: _string(data, 'desconsej') ?? _string(data, 'consej') ?? '',
      fechaInicio: _string(data, 'fechareg'),
      estado: _string(data, 'estado') ?? _string(data, 'estadosede'),
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
