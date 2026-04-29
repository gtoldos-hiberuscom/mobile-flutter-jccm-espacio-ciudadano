/// Carnet Joven (EPIC-7 / STORY-50) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;

/// Aggregate value type modelling the Carnet Joven de Castilla-La Mancha.
///
/// Reuses [DigitalCardStatus] from the catalogue feature so the per-card
/// detail surface renders identical "available / notValid /
/// notDownloadable / notAvailable" states without duplicating the enum.
///
/// Unlike the carnet de familia numerosa, the carnet joven does not
/// model a household: it is an individual document held by the citizen.
final class JovenCard {
  const JovenCard({
    required this.id,
    required this.holderName,
    required this.codigo,
    required this.status,
    this.expiryDate,
  });

  /// Stable identifier (used for analytics / list keys).
  final String id;

  /// Printed name of the carnet holder (titular).
  final String holderName;

  /// Carnet code as printed in the physical document.
  ///
  /// Modelled as a plain `String` so prefixes like `CJ-2025-…` survive
  /// without lossy parsing.
  final String codigo;

  /// Lifecycle status — actions QR/PDF/PKPASS are only enabled when
  /// the status is [DigitalCardStatus.available].
  final DigitalCardStatus status;

  /// Optional expiry date. When `null` the UI omits the expiry label.
  final DateTime? expiryDate;

  /// Convenience: actions are only enabled when the carnet is vigente.
  bool get actionsEnabled => status == DigitalCardStatus.available;
}
