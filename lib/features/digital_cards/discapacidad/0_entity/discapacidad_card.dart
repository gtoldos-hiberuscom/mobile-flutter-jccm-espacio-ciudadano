/// Carnet Discapacidad (EPIC-7 / STORY-51) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;

/// Reason why a discapacidad payload could not be fully parsed.
///
/// The repository / parser may still produce a [DiscapacidadCard] with
/// a degraded status (`notValid` / `notAvailable`); this enum lets the
/// presentation layer reason about *why* without coupling to free-form
/// strings and lets analytics distinguish the failure modes.
enum DiscapacidadParseFailure {
  /// Payload was structurally OK but the `grado` field was absent.
  missingGrado,

  /// `grado` was present but not a valid `1..100` integer.
  malformedGrado,

  /// Payload could not be parsed at all (neither map nor recognisable
  /// string shape).
  payloadUnparseable,
}

/// Aggregate value type modelling the carnet o acreditación de
/// discapacidad as exposed to the citizen.
///
/// Reuses [DigitalCardStatus] from the catalogue feature so the per-
/// card detail surface renders identical "available / notValid /
/// notAvailable" branches without duplicating the enum.
final class DiscapacidadCard {
  const DiscapacidadCard({
    required this.id,
    required this.status,
    this.holderName,
    this.grado,
    this.gradoLabel,
    this.expiryDate,
    this.parseFailure,
  });

  /// Stable identifier (used for analytics / list keys).
  final String id;

  /// Printed name of the carnet holder (titular).
  final String? holderName;

  /// Reconocimiento de grado de discapacidad expressed as an integer
  /// percentage (commonly 33 / 65 / 75; tolerated range 1..100).
  ///
  /// `null` when the backend does not provide a structured value
  /// (in that case [gradoLabel] may carry the raw label instead).
  final int? grado;

  /// Raw label provided by the backend when the payload was not
  /// structured (e.g. `"Grado 65 - Vigente"`). Only used when the UI
  /// cannot derive the canonical [grado] integer.
  final String? gradoLabel;

  /// Optional expiry date. When `null` the UI omits the expiry label.
  final DateTime? expiryDate;

  /// Lifecycle status — actions PKPass are only enabled when the
  /// status is [DigitalCardStatus.available].
  final DigitalCardStatus status;

  /// Optional parse-failure reason when the payload was degraded.
  final DiscapacidadParseFailure? parseFailure;

  /// Convenience: PKPass action is only enabled when the carnet is
  /// vigente.
  bool get actionsEnabled => status == DigitalCardStatus.available;
}
