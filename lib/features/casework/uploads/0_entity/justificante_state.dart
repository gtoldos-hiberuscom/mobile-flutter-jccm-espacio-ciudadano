/// State of the post-upload "justificante" (proof-of-deposit).
///
/// Sealed-style class hierarchy. Three concrete cases:
/// * `JustificantePending` — session is not finalized yet.
/// * `JustificanteUnavailable` — backend confirmed the request but
///   the binary builder is not yet implemented (see TASK-40).
/// * `JustificanteAvailable` — opaque `downloadRef` the data layer
///   can use to fetch the binary on demand.
sealed class JustificanteState {
  const JustificanteState();

  const factory JustificanteState.pending() = JustificantePending;
  const factory JustificanteState.unavailable(final String reason) =
      JustificanteUnavailable;
  const factory JustificanteState.available(final String downloadRef) =
      JustificanteAvailable;
}

final class JustificantePending extends JustificanteState {
  const JustificantePending();
}

final class JustificanteUnavailable extends JustificanteState {
  const JustificanteUnavailable(this.reason);
  final String reason;
}

final class JustificanteAvailable extends JustificanteState {
  const JustificanteAvailable(this.downloadRef);
  final String downloadRef;
}
