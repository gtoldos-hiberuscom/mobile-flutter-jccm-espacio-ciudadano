import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';

abstract interface class MyDataEmploymentRepository {
  Future<EmploymentDemand?> loadDemand({
    required final String documentNumber,
  });
}
