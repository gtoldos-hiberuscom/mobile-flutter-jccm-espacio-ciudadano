/// Pure-Dart entity for a beneficiary listed in the familia numerosa
/// title.
final class FamilyNumerosaBeneficiary {
  const FamilyNumerosaBeneficiary({
    required this.relacion,
    required this.fechaNacimiento,
  });

  /// Stable relación enum-like identifier (e.g. `'titular'`, `'conyuge'`,
  /// `'hijo'`). Locale-independent.
  final String relacion;
  final DateTime fechaNacimiento;
}

/// Pure-Dart entity describing a familia numerosa title issued by the
/// Comunidad Autónoma.
final class FamilyNumerosaTitle {
  const FamilyNumerosaTitle({
    required this.numero,
    required this.categoria,
    required this.fechaCaducidad,
    required this.beneficiarios,
  });

  /// Stable categoría identifier (`'general'`, `'especial'`).
  final String categoria;

  /// Title number — opaque string identifier issued by the CCAA.
  final String numero;
  final DateTime fechaCaducidad;
  final List<FamilyNumerosaBeneficiary> beneficiarios;
}
