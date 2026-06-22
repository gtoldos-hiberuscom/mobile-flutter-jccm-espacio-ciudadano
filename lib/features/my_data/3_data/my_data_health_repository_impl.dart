import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';

final class MyDataHealthRepositoryImpl implements MyDataHealthRepository {
  const MyDataHealthRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<String?> loadCip({required final String documentNumber}) async {
    final Response<String> response;
    try {
      response = await _dio.get<String>(
        '/api/v1/sescam/cip/${Uri.encodeComponent(documentNumber)}',
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }

    final payload = response.data;
    if (payload == null || payload.trim().isEmpty) {
      return null;
    }

    final body = _asStringMap(_asStringMap(_decodePayload(payload))?['body']);
    return _firstString(body, const ['cip', 'CIP']);
  }

  @override
  Future<List<HealthAppointment>> loadAppointments({
    required final String documentNumber,
    required final HealthAppointmentFilter filter,
  }) async {
    final path = switch (filter) {
      HealthAppointmentFilter.pending => '/api/v1/sescam/citas/${Uri.encodeComponent(documentNumber)}',
      HealthAppointmentFilter.past => '/api/v1/sescam/citas-pasadas/${Uri.encodeComponent(documentNumber)}',
    };
    final Response<String> response;
    try {
      response = await _dio.get<String>(
        path,
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      rethrow;
    }

    final payload = response.data;
    if (payload == null || payload.trim().isEmpty) {
      return const [];
    }

    return _appointmentMaps(_decodePayload(payload)).map(_tryParseAppointment).nonNulls.toList(growable: false)..sort(
      (final a, final b) => filter == HealthAppointmentFilter.past ? b.dateTime.compareTo(a.dateTime) : a.dateTime.compareTo(b.dateTime),
    );
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

  List<Map<String, dynamic>> _appointmentMaps(final Object? value) {
    final root = _asStringMap(value);
    final body = _asStringMap(root?['body']);
    final rawAppointments = body?['listaCitas'];
    if (body != null && rawAppointments is List<dynamic>) {
      final centerData = <String, dynamic>{
        for (final entry in body.entries)
          if (entry.key != 'listaCitas') entry.key: entry.value,
      };
      return rawAppointments
          .map(_asStringMap)
          .nonNulls
          .map(
            (final appointment) => <String, dynamic>{
              ...centerData,
              ...appointment,
            },
          )
          .toList(growable: false);
    }

    return _collectMaps(value);
  }

  List<Map<String, dynamic>> _collectMaps(final Object? value) {
    final maps = <Map<String, dynamic>>[];

    void visit(final Object? node) {
      switch (node) {
        case final Map<String, dynamic> map:
          maps.add(map);
          map.values.forEach(visit);
        case final Map<dynamic, dynamic> map:
          final normalized = <String, dynamic>{
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

  HealthAppointment? _tryParseAppointment(final Map<String, dynamic> raw) {
    final dateTime = _extractDateTime(raw);
    if (dateTime == null) {
      return null;
    }

    final professional = _firstString(raw, const [
      'nomProfesionalRealizador',
      'profesionalRealizador',
      'nombreProfesional',
      'nombreCompletoProfesional',
      'profesional',
      'medico',
      'doctor',
    ]);
    final description = _firstString(raw, const [
      'nomTvisita',
      'nomTVisita',
      'nomTipoVisita',
      'tipoCita',
      'descTipoCita',
      'descripcionCita',
      'descripcion',
      'especialidad',
    ]);
    final modality = _firstString(raw, const [
      'nomModoVisita',
      'modalidad',
      'descripcionModalidad',
      'tipoConsulta',
      'tipoAsistencia',
    ]);
    final center = _firstString(raw, const [
      'nombreCentro',
      'centroSalud',
      'centro',
      'dirCentro',
      'municipioCentro',
    ]);

    return HealthAppointment(
      dateTime: dateTime,
      professional: professional ?? description ?? 'Cita sanitaria',
      description: description ?? 'Cita sanitaria',
      channel: modality,
      modality: modality,
      center: center,
    );
  }

  DateTime? _extractDateTime(final Map<String, dynamic> raw) {
    final combined = _firstString(raw, const [
      'fechaHora',
      'fecha_hora',
      'fechaCita',
      'fecha_cita',
      'dateTime',
      'datetime',
    ]);
    final parsedCombined = _parseDateTime(combined);
    if (parsedCombined != null) {
      return parsedCombined;
    }

    final date = _firstString(raw, const ['fecha', 'date', 'dia']);
    final time = _firstString(raw, const ['hora', 'time']);
    if (date == null) {
      return null;
    }
    return _parseDateTime('${date.trim()} ${time?.trim().isNotEmpty ?? false ? time!.trim() : '00:00'}') ?? _parseDateTime(date);
  }

  DateTime? _parseDateTime(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return iso;
    }

    final match = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})(?:\s+(\d{1,2}):(\d{2}))?').firstMatch(trimmed);
    if (match == null) {
      return null;
    }
    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    final hour = int.tryParse(match.group(4) ?? '0');
    final minute = int.tryParse(match.group(5) ?? '0');
    if (day == null || month == null || year == null || hour == null || minute == null) {
      return null;
    }
    return DateTime(year, month, day, hour, minute);
  }

  Map<String, dynamic>? _asStringMap(final Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return <String, dynamic>{
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  String? _firstString(final Map<String, dynamic>? raw, final List<String> keys) {
    if (raw == null) {
      return null;
    }
    final normalized = <String, Object?>{
      for (final entry in raw.entries) entry.key.toLowerCase(): entry.value,
    };
    for (final key in keys) {
      final value = normalized[key.toLowerCase()];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value is num) {
        return value.toString();
      }
    }
    return null;
  }
}
