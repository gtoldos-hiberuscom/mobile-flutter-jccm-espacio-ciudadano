import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_validation_error.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Maps domain-level [SupportValidationError] values to localized copy.
///
/// Living in the presentation layer keeps `0_entity/` and `1_domain/`
/// free of l10n / `BuildContext` (canon §11–§13).
String resolveSupportValidationError(
  final AppLocalizations l10n,
  final SupportValidationError error,
) {
  switch (error) {
    case SupportValidationError.nameRequired:
      return l10n.supportErrorNameRequired;
    case SupportValidationError.emailRequired:
      return l10n.supportErrorEmailRequired;
    case SupportValidationError.emailInvalid:
      return l10n.supportErrorEmailInvalid;
    case SupportValidationError.emailConfirmRequired:
      return l10n.supportErrorEmailConfirmRequired;
    case SupportValidationError.emailMismatch:
      return l10n.supportErrorEmailMismatch;
    case SupportValidationError.subjectRequired:
      return l10n.supportErrorSubjectRequired;
    case SupportValidationError.subjectTooLong:
      return l10n.supportErrorSubjectTooLong;
    case SupportValidationError.descriptionRequired:
      return l10n.supportErrorDescriptionRequired;
    case SupportValidationError.descriptionTooLong:
      return l10n.supportErrorDescriptionTooLong;
    case SupportValidationError.consentRequired:
      return l10n.supportErrorConsentRequired;
    case SupportValidationError.captchaRequired:
      return l10n.supportErrorCaptchaRequired;
  }
}

/// Maps the locale-independent submission error key emitted by the
/// notifier to a localized string.
String resolveSupportSubmissionError(
  final AppLocalizations l10n,
  final String key,
) {
  switch (key) {
    case 'supportSubmissionGenericError':
      return l10n.supportSubmissionError;
    default:
      return l10n.supportSubmissionError;
  }
}
