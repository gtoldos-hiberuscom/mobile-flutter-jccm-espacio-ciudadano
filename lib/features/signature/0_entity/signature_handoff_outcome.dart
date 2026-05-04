/// Terminal / in-flight states of an external signature handoff
/// (STORY-46).
///
/// The [pending] value covers the period between launching the external
/// flow and receiving the deep-link return; the other three values are
/// terminal.
enum SignatureHandoffStatus {
  /// The external flow has been launched but has not yet returned.
  pending,

  /// The citizen completed the signature successfully.
  signed,

  /// The citizen cancelled the signature in the external flow.
  cancelled,

  /// The external flow returned an error or could not be launched.
  error,
}

/// Outcome of an external signature handoff (STORY-46).
///
/// Pure value type — no Flutter, no Dio, no Riverpod (canon §11).
final class SignatureHandoffOutcome {
  const SignatureHandoffOutcome({
    required this.status,
    required this.documentId,
    this.errorReason,
    this.completedAt,
  });

  /// Convenience constructor for the in-flight state, before the
  /// deep-link return has been parsed.
  const SignatureHandoffOutcome.pending({required this.documentId}) : status = SignatureHandoffStatus.pending, errorReason = null, completedAt = null;

  final SignatureHandoffStatus status;
  final String documentId;

  /// Optional human-readable reason for an [SignatureHandoffStatus.error]
  /// outcome. Free-form — UI must localize before showing.
  final String? errorReason;

  /// Timestamp of the terminal outcome — `null` while [status] is
  /// [SignatureHandoffStatus.pending].
  final DateTime? completedAt;
}

/// Failure modes the deep-link parser surfaces when it cannot map a
/// return URI onto a [SignatureHandoffOutcome] (STORY-46).
///
/// Currently informational — the parser returns `null` on any of these
/// conditions; the enum is exposed so future logging / analytics can
/// classify malformed returns without re-running the parser.
enum SignatureHandoffParseFailure {
  /// The `docId` query parameter was missing or empty.
  missingDocumentId,

  /// The `result` query parameter was missing or did not match any
  /// known [SignatureHandoffStatus] value.
  missingResult,

  /// The URI did not match the expected scheme / host / path.
  malformedUri,
}
