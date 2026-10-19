/// Fila «etiqueta: valor» del cuerpo de un evento, tal como la publica la
/// agenda en párrafos («Profesional: …», «Servicio: …», «Sala: …»).
typedef AgendaAppointmentDetail = ({String label, String value});

final class AgendaAppointment {
  const AgendaAppointment({
    required this.dateTime,
    required this.title,
    required this.description,
    this.kind = AgendaAppointmentKind.notification,
    this.channel,
    this.detail,
    this.center,
    this.details = const [],
  });

  final DateTime dateTime;
  final String title;
  final String description;
  final AgendaAppointmentKind kind;
  final String? channel;
  final String? detail;
  final String? center;

  /// Filas extraídas de los párrafos etiquetados del mensaje del evento, en su
  /// orden original. Vacío cuando el mensaje no viene estructurado.
  final List<AgendaAppointmentDetail> details;
}

enum AgendaAppointmentKind {
  notification,
  health,
  credential,
}
