import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_validation_error.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_form_validator.dart';

void main() {
  const validator = SupportFormValidator();

  SupportRequest base({
    final String name = 'Ana',
    final String email = 'ana@example.com',
    final String subject = 'Asunto válido',
    final String description = 'Descripción suficiente',
    final bool dataConsent = true,
    final bool captchaPassed = true,
  }) => SupportRequest(
    name: name,
    email: email,
    subject: subject,
    description: description,
    dataConsent: dataConsent,
    captchaPassed: captchaPassed,
  );

  group('SupportFormValidator', () {
    test('valid input returns empty error map', () {
      final errors = validator.validate(base(), 'ana@example.com');
      expect(errors, isEmpty);
    });

    test('all fields empty produces required errors plus consent + captcha', () {
      final errors = validator.validate(
        SupportRequest.empty,
        '',
      );
      expect(errors[SupportFormField.name], SupportValidationError.nameRequired);
      expect(errors[SupportFormField.email], SupportValidationError.emailRequired);
      expect(errors[SupportFormField.emailConfirm], SupportValidationError.emailConfirmRequired);
      expect(errors[SupportFormField.subject], SupportValidationError.subjectRequired);
      expect(errors[SupportFormField.description], SupportValidationError.descriptionRequired);
      expect(errors[SupportFormField.consent], SupportValidationError.consentRequired);
      expect(errors[SupportFormField.captcha], SupportValidationError.captchaRequired);
    });

    test('invalid email format flagged', () {
      final errors = validator.validate(
        base(email: 'no-at-sign'),
        'no-at-sign',
      );
      // emailInvalid is set; emailConfirm is allowed to be silent because
      // the source email is itself invalid.
      expect(errors[SupportFormField.email], SupportValidationError.emailInvalid);
    });

    test('mismatched email confirmation flagged', () {
      final errors = validator.validate(
        base(),
        'other@example.com',
      );
      expect(errors[SupportFormField.emailConfirm], SupportValidationError.emailMismatch);
    });

    test('email confirmation match is case-insensitive', () {
      final errors = validator.validate(
        base(email: 'Ana@Example.com'),
        'ana@example.COM',
      );
      expect(errors.containsKey(SupportFormField.emailConfirm), isFalse);
    });

    test('subject longer than 100 chars flagged as too long', () {
      final long = 'A' * 101;
      final errors = validator.validate(base(subject: long), 'ana@example.com');
      expect(errors[SupportFormField.subject], SupportValidationError.subjectTooLong);
    });

    test('description longer than 1000 chars flagged as too long', () {
      final long = 'B' * 1001;
      final errors = validator.validate(base(description: long), 'ana@example.com');
      expect(errors[SupportFormField.description], SupportValidationError.descriptionTooLong);
    });

    test('missing data consent flagged', () {
      final errors = validator.validate(
        base(dataConsent: false),
        'ana@example.com',
      );
      expect(errors[SupportFormField.consent], SupportValidationError.consentRequired);
    });

    test('missing captcha flagged', () {
      final errors = validator.validate(
        base(captchaPassed: false),
        'ana@example.com',
      );
      expect(errors[SupportFormField.captcha], SupportValidationError.captchaRequired);
    });
  });
}
