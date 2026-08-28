final class AgendaAppointment {
  const AgendaAppointment({
    required this.dateTime,
    required this.title,
    required this.description,
    this.kind = AgendaAppointmentKind.notification,
    this.channel,
    this.detail,
    this.center,
  });

  final DateTime dateTime;
  final String title;
  final String description;
  final AgendaAppointmentKind kind;
  final String? channel;
  final String? detail;
  final String? center;
}

enum AgendaAppointmentKind {
  notification,
  health,
  credential,
}
