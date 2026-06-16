import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';

final class AgendaRepositoryImpl implements AgendaRepository {
  const AgendaRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<AgendaAppointment>> loadAppointments({
    required final String documentNumber,
    final String? agentId,
  }) async {
    final trimmedAgentId = agentId?.trim();
    final responses = await Future.wait([
      _loadAppointmentsFrom(
        '/api/v1/sescam/citas/$documentNumber',
        source: _AgendaAppointmentSource.health,
      ),
      if (trimmedAgentId != null && trimmedAgentId.isNotEmpty)
        _loadAppointmentsFrom(
          '/api/v1/agenda/$trimmedAgentId/eventos/todos',
          source: _AgendaAppointmentSource.general,
          ignoreBadRequest: true,
        ),
    ]);

    final appointments = responses.expand((final appointments) => appointments).toList(growable: false)..sort((final a, final b) => a.dateTime.compareTo(b.dateTime));

    return appointments;
  }

  Future<List<AgendaAppointment>> _loadAppointmentsFrom(
    final String path, {
    required final _AgendaAppointmentSource source,
    final bool ignoreBadRequest = false,
  }) async {
    final Response<String> response;
    try {
      response = await _dio.get<String>(
        path,
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 404 || (ignoreBadRequest && statusCode == 400)) {
        return const [];
      }
      rethrow;
    }
    final payload = response.data;
    if (payload == null || payload.trim().isEmpty) {
      return const [];
    }

    final decoded = _decodePayload(payload);
    final objects = _appointmentMaps(decoded);
    return objects.map((final raw) => _tryParseAppointment(raw, source: source)).nonNulls.toList(growable: false);
  }

  Object? _decodePayload(final String payload) {
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

  AgendaAppointment? _tryParseAppointment(
    final Map<String, dynamic> raw, {
    required final _AgendaAppointmentSource source,
  }) {
    final dateTime = _extractDateTime(raw);
    if (dateTime == null) {
      return null;
    }

    final title = _firstString(raw, const [
      'titulo',
      'title',
      'nombre',
      'asunto',
      'resumen',
      'summary',
      'evento',
      'nombreEvento',
      'descripcionEvento',
    ]);
    final professional = _firstString(raw, const [
      'profesional',
      'nombreProfesional',
      'nombreCompletoProfesional',
      'nombre_medico',
      'medico',
      'facultativo',
      'doctor',
      'doctorNombre',
      'nombreDoctor',
      'nomProfesionalRealizador',
      'profesionalRealizador',
    ]);
    final specialty = _firstString(raw, const [
      'especialidad',
      'servicio',
      'agenda',
      'prestacion',
      'tipoCita',
      'descTipoCita',
      'descripcionTipoCita',
      'descripcionCita',
      'nombreCita',
      'nomTvisita',
      'nomTVisita',
      'nomTipoVisita',
      'nombreTipoVisita',
      'tipoEvento',
      'descTipoEvento',
      'descripcionTipoEvento',
      'tipo',
      'descripcion',
      'motivo',
      'nomVisita',
    ]);
    final center = _firstString(raw, const [
      'centro',
      'centroSalud',
      'centro_sanitario',
      'nombreCentro',
      'dirCentro',
      'municipioCentro',
      'ubicacion',
      'localizacion',
    ]);
    final channel = _firstString(raw, const [
      'canal',
      'descripcionCanal',
      'modalidad',
      'descripcionModalidad',
      'tipoConsulta',
      'tipoAsistencia',
      'nomModoVisita',
      'forma',
    ]);
    final detail = _firstString(raw, const [
      'detalle',
      'detalleCita',
      'descripcionConsulta',
      'descripcionModoVisita',
      'descModoVisita',
      'descripcionTipoConsulta',
      'descTipoConsulta',
      'nombreTipoConsulta',
      'nomTipoVisita',
      'tipoVisita',
      'subtipoCita',
      'observaciones',
    ]);

    final description = switch (source) {
      _AgendaAppointmentSource.health => specialty ?? 'Cita sanitaria',
      _AgendaAppointmentSource.general => specialty ?? title ?? 'Cita',
    };

    return AgendaAppointment(
      dateTime: dateTime,
      title: source == _AgendaAppointmentSource.health ? professional ?? specialty ?? 'Cita sanitaria' : title ?? specialty ?? 'Cita',
      description: description,
      channel: channel,
      detail: detail ?? center,
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
      'inicio',
      'start',
      'fechaInicio',
      'fecha_inicio',
      'startDate',
      'start_date',
    ]);
    final parsedCombined = _parseDateTime(combined);
    if (parsedCombined != null) {
      return parsedCombined;
    }

    final date = _firstString(raw, const [
      'fecha',
      'date',
      'dia',
      'fechaInicio',
      'fecha_inicio',
      'fechaEvento',
      'fecha_evento',
      'diaEvento',
    ]);
    final time = _firstString(raw, const [
      'hora',
      'time',
      'horaInicio',
      'hora_inicio',
      'horaEvento',
      'hora_evento',
    ]);
    return _parseDateAndTime(date: date, time: time);
  }

  DateTime? _parseDateAndTime({required final String? date, required final String? time}) {
    if (date == null) {
      return null;
    }
    final normalizedTime = time == null || time.trim().isEmpty ? '00:00' : time.trim();
    return _parseDateTime('${date.trim()} $normalizedTime') ?? _parseDateTime(date);
  }

  DateTime? _parseDateTime(final String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return iso;
    }

    final dateTimeMatch = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})(?:\s+(\d{1,2}):(\d{2}))?').firstMatch(trimmed);
    if (dateTimeMatch == null) {
      return null;
    }

    final day = int.tryParse(dateTimeMatch.group(1)!);
    final month = int.tryParse(dateTimeMatch.group(2)!);
    final year = int.tryParse(dateTimeMatch.group(3)!);
    final hour = int.tryParse(dateTimeMatch.group(4) ?? '0');
    final minute = int.tryParse(dateTimeMatch.group(5) ?? '0');
    if (day == null || month == null || year == null || hour == null || minute == null) {
      return null;
    }
    return DateTime(year, month, day, hour, minute);
  }

  String? _firstString(final Map<String, dynamic> raw, final List<String> keys) {
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

enum _AgendaAppointmentSource {
  health,
  general,
}
