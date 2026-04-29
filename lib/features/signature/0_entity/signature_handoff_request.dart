/// External-signature handoff request payload (STORY-46).
///
/// Pure value type — no Flutter, no Dio, no Riverpod (canon §11).
/// Built by the presentation layer when the citizen taps the "Firmar"
/// CTA on a pending signature document. Consumed by the domain
/// controller, which forwards [externalUri] to the launcher abstraction.
final class SignatureHandoffRequest {
  const SignatureHandoffRequest({
    required this.documentId,
    required this.documentTitle,
    required this.externalUri,
    required this.returnDeepLink,
    required this.requestedAt,
  });

  /// Identifier of the document being signed. Echoed in the deep-link
  /// [returnDeepLink] so the controller can correlate the outcome with
  /// the document that triggered the flow.
  final String documentId;

  /// Human-readable document title — used by analytics / future UI
  /// surfaces (e.g. retry sheets) to identify the in-flight signature
  /// to the citizen.
  final String documentTitle;

  /// External URL handed to the OS / browser. Built by the presentation
  /// layer as a STUB pointing at the placeholder Afirma endpoint —
  /// see the TODO in `UrlLauncherSignatureHandoffLauncher`.
  final Uri externalUri;

  /// Deep-link the external system must redirect to once the signature
  /// has been completed, cancelled or has errored. Typically:
  /// `jccmespacio://sign/afirma/return?docId=$documentId&result=...`.
  final Uri returnDeepLink;

  /// Wall-clock timestamp of when the citizen initiated the handoff.
  /// Useful for analytics and timeout heuristics in future sprints.
  final DateTime requestedAt;
}
