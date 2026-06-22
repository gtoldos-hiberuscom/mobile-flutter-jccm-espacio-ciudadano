import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';

enum HealthAppointmentFilter { pending, past }

abstract interface class MyDataHealthRepository {
  Future<String?> loadCip({required final String documentNumber});

  Future<List<HealthAppointment>> loadAppointments({
    required final String documentNumber,
    required final HealthAppointmentFilter filter,
  });
}
