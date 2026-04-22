/// Sealed hierarchy representing every possible state of the consent lifecycle.
///
/// Pure Dart — no Flutter, Riverpod, or infrastructure imports allowed.
///
/// States:
/// - [ConsentNotChecked] — initial state before storage is queried.
/// - [ConsentPending]    — consent has not been given yet (show screen).
/// - [ConsentAccepted]   — user has accepted the consent terms (skip screen).
/// - [ConsentRejected]   — user has rejected the consent terms (exit app).
sealed class ConsentState {
  const ConsentState();
}

/// Initial state — consent status has not been checked yet.
final class ConsentNotChecked extends ConsentState {
  const ConsentNotChecked();
}

/// User has not yet accepted consent — the consent screen must be shown.
final class ConsentPending extends ConsentState {
  const ConsentPending();
}

/// User has accepted the consent terms — functional access is allowed.
final class ConsentAccepted extends ConsentState {
  const ConsentAccepted();
}

/// User has rejected the consent terms — the app should exit.
final class ConsentRejected extends ConsentState {
  const ConsentRejected();
}
