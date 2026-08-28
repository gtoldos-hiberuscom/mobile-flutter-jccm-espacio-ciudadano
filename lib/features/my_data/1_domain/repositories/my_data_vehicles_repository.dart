import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';

/// Repository contract for vehicles (DGT) data.
abstract interface class MyDataVehiclesRepository {
  /// Fetches vehicles for the given document number.
  ///
  /// `citizenId` es el segmento de la ruta `/ciudadanos/{id}/vehiculos` y
  /// `documentNumber` el documento consultado, que viaja en el cuerpo.
  ///
  /// Returns a list of [Vehicle] objects.
  /// Throws on network or API errors.
  Future<List<Vehicle>> loadVehicles({
    required final String citizenId,
    required final String documentNumber,
  });
}
