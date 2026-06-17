final class HealthAppointment {
  const HealthAppointment({
    required this.dateTime,
    required this.professional,
    required this.description,
    this.channel,
    this.modality,
    this.center,
  });

  final DateTime dateTime;
  final String professional;
  final String description;
  final String? channel;
  final String? modality;
  final String? center;
}
