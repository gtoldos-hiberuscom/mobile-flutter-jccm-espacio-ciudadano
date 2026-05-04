/// Result state of validating the citizen certificate / VEC against
/// `POST /afirma/mivecreq` (STORY-45).
///
/// Pure Dart enum — the human label is resolved by the presentation
/// layer using the `labelKey` slot.
enum CertificateValidationState {
  valid('signatureCertificateValidTitle'),
  missing('signatureCertificateMissingTitle'),
  expired('signatureCertificateExpiredTitle'),
  invalid('signatureCertificateInvalidTitle'),
  vecAvailable('signatureCertificateVecTitle'),
  unknown('signatureCertificateUnknownTitle')
  ;

  const CertificateValidationState(this.labelKey);

  /// Stable key used by the presentation layer to look up the localised
  /// label in `AppLocalizations`.
  final String labelKey;
}

/// Value object describing the outcome of a certificate / VEC check.
///
/// Pure value type — no Flutter / Dio / Riverpod (canon §11). All
/// failure detail is mapped to [state] and an opaque [message]; raw
/// transport / SDK errors must not leak into this layer.
final class CertificateValidation {
  const CertificateValidation({
    required this.state,
    this.holderName,
    this.expiresAt,
    this.message,
  });

  final CertificateValidationState state;
  final String? holderName;
  final DateTime? expiresAt;
  final String? message;

  /// Convenience flag — true when the citizen is allowed to proceed to
  /// the external Afirma flow.
  bool get canSign => state == CertificateValidationState.valid || state == CertificateValidationState.vecAvailable;
}
