import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';

/// Eje temporal del listado de citas.
enum HealthAppointmentFilter { pending, past }

/// Ámbito asistencial del listado de citas.
enum HealthAppointmentScope { primaryCare, hospital }

abstract interface class MyDataHealthRepository {
  /// Código de identificación personal del ciudadano.
  Future<String?> loadCip({required final String citizenId});

  Future<List<HealthAppointment>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  });

  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  });
}
