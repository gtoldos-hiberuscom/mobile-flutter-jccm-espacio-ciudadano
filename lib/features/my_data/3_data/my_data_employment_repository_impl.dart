import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_employment_repository.dart';

final class MyDataEmploymentRepositoryImpl implements MyDataEmploymentRepository {
  const MyDataEmploymentRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<EmploymentDemand?> loadDemand({
    required final String documentNumber,
  }) async {
    final response = await _dio.post<Object?>(
      '/api/v1/sepe/demandante-empleo-fecha-actual/${Uri.encodeComponent(documentNumber)}',
      data: {
        'docu': documentNumber,
        'tipodoc': _documentType(documentNumber),
      },
      options: Options(
        responseType: ResponseType.plain,
        validateStatus: (final status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 404) {
      return null;
    }

    final payload = _decodePayload(response.data);
    final root = _asStringMap(payload);
    final body = root == null ? null : _asStringMap(_decodePayload(root['body']));
    final data = body ?? root ?? _collectMaps(payload).firstOrNull;
    if (data == null) {
      return null;
    }

    final demand = EmploymentDemand(
      status: _statusLabel(
        _firstString(data, const ['inscrito', 'estado', 'situacion', 'situación', 'resul']),
      ),
      uninterruptedRegistrationDate: _parseDate(
        _firstString(data, const ['ultimainscrip', 'ultimaInscrip', 'fechaInscripcion', 'fecha_inscripcion']),
      ),
      message: _firstString(data, const ['mensaje', 'literalError', 'descripcion']),
    );

    return demand.hasData ? demand : null;
  }

  Object? _decodePayload(final Object? payload) {
    Object? current = payload;
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

  List<Map<String, Object?>> _collectMaps(final Object? value) {
    final maps = <Map<String, Object?>>[];

    void visit(final Object? node) {
      switch (node) {
        case final Map<String, Object?> map:
          maps.add(map);
          map.values.forEach(visit);
        case final Map<dynamic, dynamic> map:
          final normalized = <String, Object?>{
            for (final entry in map.entries)
              if (entry.key != null) entry.key.toString(): entry.value,
          };
          maps.add(normalized);
          normalized.values.forEach(visit);
        case final List<dynamic> list:
          list.forEach(visit);
      }
    }

    visit(value);
    return maps;
  }

  Map<String, Object?>? _asStringMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return <String, Object?>{
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  String? _firstString(final Map<String, Object?> map, final List<String> keys) {
    for (final key in keys) {
      final value = _valueForKey(map, key);
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value is num) {
        return value.toString();
      }
      if (value is bool) {
        return value.toString();
      }
    }
    return null;
  }

  Object? _valueForKey(final Map<String, Object?> map, final String key) {
    final lowerKey = key.toLowerCase();
    for (final entry in map.entries) {
      if (entry.key.toLowerCase() == lowerKey) {
        return entry.value;
      }
    }
    return null;
  }

  DateTime? _parseDate(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return iso;
    }

    final compact = RegExp(r'^(\d{4})(\d{2})(\d{2})$').firstMatch(trimmed);
    if (compact != null) {
      return DateTime(
        int.parse(compact.group(1)!),
        int.parse(compact.group(2)!),
        int.parse(compact.group(3)!),
      );
    }

    final match = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})').firstMatch(trimmed);
    if (match == null) {
      return null;
    }

    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (day == null || month == null || year == null) {
      return null;
    }
    if (month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }
    return DateTime(year, month, day);
  }

  String _statusLabel(final String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return 'Activa';
    }
    final upper = normalized.toUpperCase();
    if (upper == 'S' || upper == 'SI' || upper == 'SÍ' || upper == 'TRUE' || upper == '1') {
      return 'Activa';
    }
    if (upper == 'N' || upper == 'NO' || upper == 'FALSE' || upper == '0') {
      return 'No Inscrito';
    }
    return normalized;
  }

  String _documentType(final String documentNumber) {
    final normalized = documentNumber.trim().toUpperCase();
    if (RegExp('^[XYZ]').hasMatch(normalized)) {
      return 'NIE';
    }
    return 'NIF';
  }
}
