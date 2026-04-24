/// Stable, locale-independent identifiers for support-form validation
/// errors (STORY-60).
///
/// Living in `0_entity/` keeps `1_domain/` pure Dart (no copy, no
/// `BuildContext`). The presentation layer maps each value to an ARB
/// string in `2_presentation/support_localizations.dart`.
enum SupportValidationError {
  nameRequired,
  emailRequired,
  emailInvalid,
  emailConfirmRequired,
  emailMismatch,
  subjectRequired,
  subjectTooLong,
  descriptionRequired,
  descriptionTooLong,
  consentRequired,
  captchaRequired,
}

/// Identifiers for the form fields used as keys in the validation result.
///
/// Strings are kept stable so `1_domain` stays free of Flutter / UI
/// vocabulary.
enum SupportFormField {
  name,
  email,
  emailConfirm,
  subject,
  description,
  consent,
  captcha,
}
