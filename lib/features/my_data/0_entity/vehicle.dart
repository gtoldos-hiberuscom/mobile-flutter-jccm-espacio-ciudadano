/// Vehicle entity representing a vehicle registration.
///
/// Maps to the backend's "lista-vehiculos" response structure.
final class Vehicle {
  const Vehicle({
    required this.licensePlate,
  });

  /// License plate number ("matricula")
  final String licensePlate;
}
