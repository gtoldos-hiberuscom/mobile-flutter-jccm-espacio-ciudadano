/// Aggregate status used by the notifications-contact gate (STORY-42).
///
/// Future tickets (e.g. STORY-43+) can guard the notifications inbox
/// behind a missing-contact banner by reading the gate provider that
/// returns one of these values. Pure Dart — no Flutter (canon §11).
enum NotificationContactStatus {
  /// Status has not been determined yet (initial / loading).
  unknown,

  /// No contact data registered — the citizen should be prompted.
  missing,

  /// At least one contact channel is registered.
  configured,
}
