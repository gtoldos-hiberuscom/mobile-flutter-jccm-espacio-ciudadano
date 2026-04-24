/// Digital cards (EPIC-7 / STORY-48) — pure-Dart entity.
///
/// Models the federated `carnet-digital/*` cards visible in the catalogue:
/// familia numerosa, carnet joven and discapacidad. Sprint 4 ships only
/// the catalogue container with stub data; live binding against the
/// `/carnet-digital/*` operations is owned by TASK-53.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

/// Federated card type rendered in the catalogue.
///
/// CIP / Tarjeta Sanitaria is intentionally NOT part of this enum —
/// per TASK-71 (CIP_REUSE) it is rendered as a separate read-only mini
/// card owned by STORY-31. Biblioteca is OUT_OF_MVP per TASK-71.
enum DigitalCardType {
  familiaNumerosa,
  joven,
  discapacidad,
}

/// Per-card availability state (canon §15 explicit state model).
///
/// - [available]    — vigente y descargable; QR/PKPASS/PDF habilitados.
/// - [notValid]     — no vigente; mensaje explícito, sin acciones.
/// - [notDownloadable] — vigente pero formato no disponible para descargar.
/// - [notAvailable] — el ciudadano no tiene este carnet (sin datos).
enum DigitalCardStatus {
  available,
  notValid,
  notDownloadable,
  notAvailable,
}

/// Single card row in the catalogue.
final class DigitalCard {
  const DigitalCard({
    required this.id,
    required this.type,
    required this.status,
    this.holderName,
    this.expiryDate,
    this.badge,
  });

  /// Stable identifier for analytics / list keys.
  final String id;
  final DigitalCardType type;
  final DigitalCardStatus status;

  /// Optional citizen name as printed on the card.
  final String? holderName;

  /// Optional expiry date — when present and in the past, the UI may
  /// downgrade [status] visually, but the canonical status comes from
  /// the backend.
  final DateTime? expiryDate;

  /// Optional locale-independent badge slug (e.g. "vigente", "caducado").
  /// The UI maps it to a localised label.
  final String? badge;

  /// Convenience: actions QR/PKPASS/PDF are only enabled when the card
  /// is [DigitalCardStatus.available].
  bool get actionsEnabled => status == DigitalCardStatus.available;
}
