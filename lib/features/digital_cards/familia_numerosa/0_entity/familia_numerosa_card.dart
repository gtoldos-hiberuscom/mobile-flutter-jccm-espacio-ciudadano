/// Familia numerosa carnet (EPIC-7 / STORY-49) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_categoria.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_member.dart';

/// Aggregate value type modelling the carnet digital de familia numerosa.
///
/// Reuses [DigitalCardStatus] from the catalogue feature so the per-card
/// detail page renders identical "available / notValid / notDownloadable
/// / notAvailable" states without duplicating the enum.
final class FamiliaNumerosaCard {
  const FamiliaNumerosaCard({
    required this.id,
    required this.holderName,
    required this.cardNumber,
    required this.categoria,
    required this.status,
    required this.members,
    this.expiryDate,
  });

  /// Stable identifier (used for analytics / list keys).
  final String id;

  /// Printed name of the carnet holder (titular).
  final String holderName;

  /// Carnet number as printed in the physical document (string —
  /// may contain a hyphenated prefix).
  final String cardNumber;

  /// Categoría general / especial (or `unknown` when not projected).
  final FamiliaNumerosaCategoria categoria;

  /// Lifecycle status — actions QR/PDF/PKPASS are only enabled when
  /// the status is [DigitalCardStatus.available].
  final DigitalCardStatus status;

  /// Members of the family unit (titular + cónyuge + hijos/as + otros).
  final List<FamiliaNumerosaMember> members;

  /// Optional expiry date. When `null` the UI omits the expiry label.
  final DateTime? expiryDate;

  /// Convenience: actions are only enabled when the carnet is vigente.
  bool get actionsEnabled => status == DigitalCardStatus.available;
}
