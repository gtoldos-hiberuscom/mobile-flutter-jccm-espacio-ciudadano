/// Reasons why a contact-registration submission can be rejected by
/// the domain validator (STORY-42).
///
/// Pure Dart — no Flutter / Riverpod (canon §11). The presentation
/// layer maps each value to a localised message via [labelKey].
enum NotificationContactValidationFailure {
  phoneInvalid('notificationContactErrorPhoneInvalid'),
  emailInvalid('notificationContactErrorEmailInvalid'),
  bothEmpty('notificationContactErrorBothEmpty')
  ;

  const NotificationContactValidationFailure(this.labelKey);

  /// Stable key used by the presentation layer to look up the localised
  /// label in `AppLocalizations`.
  final String labelKey;
}
