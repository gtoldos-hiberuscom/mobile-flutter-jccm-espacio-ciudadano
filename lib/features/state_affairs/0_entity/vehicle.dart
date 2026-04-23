/// Pure-Dart entity for a vehicle entry sourced from the DGT registry.
final class Vehicle {
  const Vehicle({
    required this.matricula,
    required this.marca,
    required this.modelo,
    required this.combustible,
  });

  final String matricula;
  final String marca;
  final String modelo;
  final String combustible;
}
