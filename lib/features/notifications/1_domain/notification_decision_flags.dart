/// Build-time feature flag controlling whether the notification
/// decision flow (STORY-43) talks to the live backend or the
/// deterministic mock.
///
/// Defaults to `false` until the contract is confirmed.
// TODO(future-sprint): wire to /notifications/* endpoints once
// contract confirmed (TASK-47 strategy doc).
const bool notificationDecisionLiveBackendEnabled = false;
