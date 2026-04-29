/// Compile-time constants for the notification-contact sub-feature
/// (STORY-42).
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

/// Whether the live backend wiring for notification contact registration
/// is enabled.
///
/// Per the discovery in
/// `documentation/discovery/TASK-47-notifications-contract-strategy.md`,
/// no backend endpoint exists yet for citizen-contact registration.
/// STORY-42 ships UI + domain + a mock data layer; real Dio wiring is
/// deferred to a future sprint once the backend contract is confirmed.
const bool kNotificationContactLiveBackendEnabled = false;
