import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';

/// Lifecycle status for a casework item (expediente / entrada / salida).
///
/// Locale-independent — UI labels are resolved through l10n in
/// the presentation layer.
enum CaseworkItemStatus { enTramite, finalizado, pendiente, rechazado }

/// A single row of the "Mis gestiones" workspace.
///
/// Shared between the three tabs (expedientes, entradas de registro,
/// salidas de registro) — see STORY-34 / STORY-39 for the search story
/// that extends this same entity.
final class CaseworkItem {
  const CaseworkItem({
    required this.id,
    required this.type,
    required this.number,
    required this.date,
    required this.organism,
    required this.subject,
    required this.status,
  });

  /// Stable identifier — never PII content.
  final String id;

  /// Tab/category this item belongs to.
  final CaseworkTab type;

  /// Administrative number (e.g. "EXP/2025/00123" or "REG/E/45612").
  final String number;

  /// Submission / entry / exit date depending on [type].
  final DateTime date;

  /// Issuing or receiving organism.
  final String organism;

  /// Free-text subject line as shown to the citizen.
  final String subject;

  final CaseworkItemStatus status;
}
