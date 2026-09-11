import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';

/// Fuentes que alimentan la agenda. Cada una viaja por su propio endpoint y
/// puede caer por separado: `health` son las citas de Atención Primaria de
/// SESCAM y `general` los eventos de la agenda del ciudadano.
enum AgendaAppointmentSource {
  health,
  general,
}

/// Resultado de una carga de agenda que puede haber sido parcial.
///
/// [failedSources] contiene **solo las fuentes que se intentaron y fallaron**:
/// una fuente que ni siquiera se pide (la agenda general sin `idAgente`) no es
/// un fallo, y una lista vacía es un éxito legítimo (el sobre `404.01` del
/// gateway significa "sin resultados"). Por eso la degradación no puede
/// deducirse de [appointments] vacío y viaja en su propio campo.
final class AgendaAppointmentsSnapshot {
  const AgendaAppointmentsSnapshot({
    required this.appointments,
    this.failedSources = const {},
  });

  final List<AgendaAppointment> appointments;
  final Set<AgendaAppointmentSource> failedSources;

  /// La carga trae menos de lo que debería: la pantalla debe avisar de lo que
  /// falta sin bloquear lo que sí llegó.
  bool get isPartial => failedSources.isNotEmpty;
}
