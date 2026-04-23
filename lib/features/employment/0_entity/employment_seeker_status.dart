/// Pure-Dart entity describing the citizen's job-seeker (demandante de
/// empleo) status sourced from SEPE.
final class EmploymentSeekerStatus {
  const EmploymentSeekerStatus({
    required this.estado,
    required this.fechaInscripcion,
    required this.fechaContinuidad,
  });

  /// Stable status identifier (e.g. `'inscrito'`, `'no_inscrito'`,
  /// `'baja_temporal'`). Locale-independent.
  final String estado;
  final DateTime fechaInscripcion;
  final DateTime fechaContinuidad;
}
