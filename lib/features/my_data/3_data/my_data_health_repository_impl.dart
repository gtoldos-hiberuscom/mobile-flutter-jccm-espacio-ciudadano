import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/api/salud_api.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/mappers/hospital_appointment_mapper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/mappers/sescam_date.dart';

final class MyDataHealthRepositoryImpl implements MyDataHealthRepository {
  MyDataHealthRepositoryImpl({required final Dio dio}) : _api = SaludApi(dio);

  final SaludApi _api;

  @override
  Future<String?> loadCip({required final String citizenId}) async {
    final envelope = await _api.getCip(citizenId: citizenId);
    final body = _asStringMap(envelope?['body']);
    return _firstString(body, const ['cip']);
  }

  @override
  Future<List<HealthAppointment>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) async {
    final envelope = switch (filter) {
      HealthAppointmentFilter.pending => await _api.getPrimaryCarePendingAppointments(citizenId: citizenId),
      HealthAppointmentFilter.past => await _api.getPrimaryCarePastAppointments(citizenId: citizenId, page: page),
    };
    if (envelope == null) {
      return const [];
    }

    final appointments = _primaryCareAppointmentMaps(envelope).map(_tryParsePrimaryCareAppointment).nonNulls.toList();
    return _sortedByDate(appointments, (final appointment) => appointment.dateTime, filter);
  }

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) async {
    final envelope = switch (filter) {
      HealthAppointmentFilter.pending => await _api.getHospitalPendingAppointments(citizenId: citizenId),
      HealthAppointmentFilter.past => await _api.getHospitalPastAppointments(citizenId: citizenId),
    };
    if (envelope == null) {
      return const [];
    }

    final appointments = mapHospitalAppointments(envelope['body']).toList();
    return _sortedByDate(appointments, (final appointment) => appointment.dateTime, filter);
  }

  /// Ordena ascendente las citas pendientes y descendente las pasadas.
  List<T> _sortedByDate<T>(
    final List<T> appointments,
    final DateTime Function(T appointment) dateOf,
    final HealthAppointmentFilter filter,
  ) {
    appointments.sort(
      (final a, final b) => filter == HealthAppointmentFilter.past ? dateOf(b).compareTo(dateOf(a)) : dateOf(a).compareTo(dateOf(b)),
    );
    return List.unmodifiable(appointments);
  }

  /// Aplana `body.listaCitas` fusionando en cada cita los datos del centro, que
  /// el contrato de primaria informa una sola vez al nivel de `body`.
  List<Map<String, dynamic>> _primaryCareAppointmentMaps(final Map<String, dynamic> envelope) {
    final body = _asStringMap(envelope['body']);
    final rawAppointments = body?['listaCitas'];
    if (body == null || rawAppointments is! List) {
      return const [];
    }

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

  HealthAppointment? _tryParsePrimaryCareAppointment(final Map<String, dynamic> raw) {
    final dateTime = parseSescamDateAndTime(
      date: _firstString(raw, const ['fecha']),
      time: _firstString(raw, const ['hora']),
    );
    if (dateTime == null) {
      return null;
    }

    final professional = _firstString(raw, const ['nomProfesionalRealizador']);
    final description = _firstString(raw, const ['nomTvisita']);
    final modality = _firstString(raw, const ['nomModoVisita']);
    final center = _firstString(raw, const ['nombreCentro', 'dirCentro', 'municipioCentro']);

    return HealthAppointment(
      dateTime: dateTime,
      professional: professional ?? description ?? 'Cita sanitaria',
      description: description ?? 'Cita sanitaria',
      channel: modality,
      modality: modality,
      center: center,
    );
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

  /// Busca la primera clave con contenido, ignorando mayúsculas: el backend ha
  /// alternado `cip`/`CIP` y capitalizaciones distintas en `nomTvisita`.
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
