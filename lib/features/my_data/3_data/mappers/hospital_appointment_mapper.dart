import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/mappers/sescam_date.dart';

/// Convierte el nodo `body` de las respuestas de citas hospitalarias en
/// entidades de dominio.
///
/// El contrato del gateway devuelve `body` como array de
/// `CitaHospitalariaDetalleSescam`, con `centro` y `agenda` anidados. Las citas
/// sin fecha reconocible se descartan porque el listado se agrupa por año y mes.
List<HospitalAppointment> mapHospitalAppointments(final Object? body) {
  if (body is! List) {
    return const [];
  }

  return body.map(_asStringMap).nonNulls.map(_mapAppointment).nonNulls.toList(growable: false);
}

HospitalAppointment? _mapAppointment(final Map<String, dynamic> raw) {
  final dateTime = parseSescamDateAndTime(
    date: _string(raw['fecha']),
    time: _string(raw['hora']),
  );
  if (dateTime == null) {
    return null;
  }

  final center = _asStringMap(raw['centro']);
  final agenda = _asStringMap(raw['agenda']);

  return HospitalAppointment(
    dateTime: dateTime,
    service: _string(raw['servicio']) ?? '',
    provision: _string(raw['prestacion']) ?? '',
    room: _string(raw['sala']),
    status: _string(raw['estadoCita']),
    center: _string(center?['nombre']),
    agendaCode: _string(agenda?['codigo']),
    agendaDescription: _string(agenda?['descripcion']),
    clinicalRecordNumber: _string(raw['nhc']),
    id: _string(raw['id']),
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

String? _string(final Object? value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is num) {
    return value.toString();
  }
  return null;
}
