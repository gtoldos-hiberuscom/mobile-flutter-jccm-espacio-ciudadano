/// Lifecycle status assigned to a signature document (STORY-45).
///
/// The real backend value-set for documents returned by
/// `POST /afirma/milistardocumentosreq` is not yet confirmed, so the
/// enum follows the tolerant-parser strategy: any unmapped raw value
/// falls into [unknown] and is rendered with a neutral chip.
///
/// Pure Dart — no Flutter / Riverpod / l10n imports (canon §11). The
/// human-readable label is resolved by the presentation layer through
/// the [labelKey] slot.
enum SignatureDocumentStatus {
  pendiente('signatureStatusPendiente'),
  firmado('signatureStatusFirmado'),
  expirado('signatureStatusExpirado'),
  error('signatureStatusError'),
  unknown('signatureStatusUnknown');

  const SignatureDocumentStatus(this.labelKey);

  /// Stable key used by the presentation layer to look up the localised
  /// label in `AppLocalizations` (no l10n dependency in this layer).
  final String labelKey;
}
