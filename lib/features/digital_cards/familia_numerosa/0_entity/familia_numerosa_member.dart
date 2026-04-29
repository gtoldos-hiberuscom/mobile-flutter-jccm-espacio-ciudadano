/// Familia numerosa carnet (EPIC-7 / STORY-49) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

/// Single member of a `FamiliaNumerosaCard` (titular, cónyuge, hijo/a,
/// etc.). [dni] and [fechaNacimiento] are optional because the backend
/// may project a partial member list when the citizen has not yet
/// completed the registry update.
final class FamiliaNumerosaMember {
  const FamiliaNumerosaMember({
    required this.name,
    required this.parentesco,
    this.dni,
    this.fechaNacimiento,
  });

  /// Full printed name as it appears in the carnet.
  final String name;

  /// Relationship slug (e.g. `titular`, `conyuge`, `hijo`, `hija`,
  /// `otro`). The presentation layer maps it to a localised label.
  final String parentesco;

  /// Optional DNI / NIE. Never logged with PII.
  final String? dni;

  /// Optional birth date. The presentation layer renders it via
  /// `MaterialLocalizations.formatCompactDate`.
  final DateTime? fechaNacimiento;
}
