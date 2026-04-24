import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_validation_error.dart';

/// Pure-Dart validator for the support form (STORY-60).
///
/// Lives in `1_domain/` so it can be unit-tested in isolation and reused
/// by both the notifier and any future server-side validation surface
/// (canon §13). No Flutter, no `BuildContext`, no copy.
final class SupportFormValidator {
  const SupportFormValidator({
    this.subjectMaxLength = subjectDefaultMaxLength,
    this.descriptionMaxLength = descriptionDefaultMaxLength,
  });

  /// Max length for the subject line — public AC of STORY-60.
  static const int subjectDefaultMaxLength = 100;

  /// Max length for the long description — public AC of STORY-60.
  static const int descriptionDefaultMaxLength = 1000;

  final int subjectMaxLength;
  final int descriptionMaxLength;

  /// Returns a per-field error map. An empty map means "valid".
  Map<SupportFormField, SupportValidationError> validate(
    final SupportRequest request,
    final String emailConfirm,
  ) {
    final errors = <SupportFormField, SupportValidationError>{};

    if (request.name.trim().isEmpty) {
      errors[SupportFormField.name] = SupportValidationError.nameRequired;
    }

    final email = request.email.trim();
    if (email.isEmpty) {
      errors[SupportFormField.email] = SupportValidationError.emailRequired;
    } else if (!_isEmail(email)) {
      errors[SupportFormField.email] = SupportValidationError.emailInvalid;
    }

    final confirm = emailConfirm.trim();
    if (confirm.isEmpty) {
      errors[SupportFormField.emailConfirm] = SupportValidationError.emailConfirmRequired;
    } else if (!errors.containsKey(SupportFormField.email) && confirm.toLowerCase() != email.toLowerCase()) {
      errors[SupportFormField.emailConfirm] = SupportValidationError.emailMismatch;
    }

    final subject = request.subject.trim();
    if (subject.isEmpty) {
      errors[SupportFormField.subject] = SupportValidationError.subjectRequired;
    } else if (subject.length > subjectMaxLength) {
      errors[SupportFormField.subject] = SupportValidationError.subjectTooLong;
    }

    final description = request.description.trim();
    if (description.isEmpty) {
      errors[SupportFormField.description] = SupportValidationError.descriptionRequired;
    } else if (description.length > descriptionMaxLength) {
      errors[SupportFormField.description] = SupportValidationError.descriptionTooLong;
    }

    if (!request.dataConsent) {
      errors[SupportFormField.consent] = SupportValidationError.consentRequired;
    }

    if (!request.captchaPassed) {
      errors[SupportFormField.captcha] = SupportValidationError.captchaRequired;
    }

    return errors;
  }

  /// Conservative RFC-5322-ish email check. Kept intentionally simple to
  /// avoid pathological regexes (canon §26 / ReDoS) — server-side
  /// validation remains authoritative once TASK-63 lands.
  static bool _isEmail(final String value) {
    if (value.length > 254) {
      return false;
    }
    final at = value.indexOf('@');
    if (at <= 0 || at != value.lastIndexOf('@') || at == value.length - 1) {
      return false;
    }
    final local = value.substring(0, at);
    final domain = value.substring(at + 1);
    if (local.isEmpty || domain.isEmpty) {
      return false;
    }
    if (!domain.contains('.')) {
      return false;
    }
    if (domain.startsWith('.') || domain.endsWith('.')) {
      return false;
    }
    // Disallow whitespace anywhere.
    if (value.contains(' ') || value.contains('\t')) {
      return false;
    }
    return true;
  }
}
