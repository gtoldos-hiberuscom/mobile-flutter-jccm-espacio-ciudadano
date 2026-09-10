/// Cita hospitalaria del SESCAM.
///
/// Corresponde a `CitaHospitalariaDetalleSescam` del gateway de Espacio
/// Ciudadano. Se modela aparte de `HealthAppointment` porque el contrato de
/// atención hospitalaria expone servicio, prestación, sala y estado, y no el
/// profesional/modalidad de atención primaria.
final class HospitalAppointment {
  const HospitalAppointment({
    required this.dateTime,
    required this.service,
    required this.provision,
    this.room,
    this.status,
    this.center,
    this.agendaCode,
    this.agendaDescription,
    this.clinicalRecordNumber,
    this.id,
  });

  final DateTime dateTime;

  /// Servicio médico, p. ej. `TRAUMATOLOGIA`.
  final String service;

  /// Tipo de prestación, p. ej. `CONSULTA SUCESIVA`.
  final String provision;

  /// Sala o ubicación de atención.
  final String? room;

  /// Estado de la cita, p. ej. `PENDIENTE` o `REALIZADA`.
  final String? status;

  /// Nombre del centro hospitalario.
  final String? center;

  final String? agendaCode;

  /// Descripción de la agenda o del profesional asignado.
  final String? agendaDescription;

  /// Número de historia clínica. Dato de salud: no debe registrarse en logs.
  final String? clinicalRecordNumber;

  final String? id;
}
