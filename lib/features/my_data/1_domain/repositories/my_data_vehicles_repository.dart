import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';

/// Repository contract for vehicles (DGT) data.
abstract interface class MyDataVehiclesRepository {
  /// Fetches vehicles for the given document number.
  ///
  /// Returns a list of [Vehicle] objects.
  /// Throws on network or API errors.
  Future<List<Vehicle>> loadVehicles({
    required final String documentNumber,
  });
}
