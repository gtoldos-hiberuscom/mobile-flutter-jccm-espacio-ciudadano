import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_validator.dart';

void main() {
  group('NotificationContactValidator.validatePhone', () {
    test('rejects empty value', () {
      expect(
        NotificationContactValidator.validatePhone(''),
        NotificationContactValidationFailure.phoneInvalid,
      );
    });
    test('rejects non-digit garbage', () {
      expect(
        NotificationContactValidator.validatePhone('abc'),
        NotificationContactValidationFailure.phoneInvalid,
      );
    });
    test('rejects too-short number', () {
      expect(
        NotificationContactValidator.validatePhone('12345'),
        NotificationContactValidationFailure.phoneInvalid,
      );
    });
    test('accepts plain Spanish mobile', () {
      expect(NotificationContactValidator.validatePhone('600123456'), isNull);
    });
    test('accepts E.164 with spaces and dashes', () {
      expect(
        NotificationContactValidator.validatePhone('+34 600-123-456'),
        isNull,
      );
    });
  });

  group('NotificationContactValidator.validateEmail', () {
    test('rejects empty value', () {
      expect(
        NotificationContactValidator.validateEmail(''),
        NotificationContactValidationFailure.emailInvalid,
      );
    });
    test('rejects missing domain', () {
      expect(
        NotificationContactValidator.validateEmail('bad@'),
        NotificationContactValidationFailure.emailInvalid,
      );
    });
    test('accepts valid address', () {
      expect(
        NotificationContactValidator.validateEmail('user@example.com'),
        isNull,
      );
    });
  });

  group('NotificationContactValidator.validateContact', () {
    test('rejects when both channels are empty (bothEmpty)', () {
      expect(
        NotificationContactValidator.validateContact(phone: '', email: ''),
        NotificationContactValidationFailure.bothEmpty,
      );
    });

    test('rejects when both channels are null (bothEmpty)', () {
      expect(
        NotificationContactValidator.validateContact(),
        NotificationContactValidationFailure.bothEmpty,
      );
    });

    test('phone-only happy path', () {
      expect(
        NotificationContactValidator.validateContact(phone: '+34600123456'),
        isNull,
      );
    });

    test('email-only happy path', () {
      expect(
        NotificationContactValidator.validateContact(email: 'a@b.co'),
        isNull,
      );
    });

    test('both channels happy path', () {
      expect(
        NotificationContactValidator.validateContact(
          phone: '600123456',
          email: 'a@b.co',
        ),
        isNull,
      );
    });

    test('reports phoneInvalid when phone is malformed', () {
      expect(
        NotificationContactValidator.validateContact(
          phone: '12',
          email: 'a@b.co',
        ),
        NotificationContactValidationFailure.phoneInvalid,
      );
    });

    test('reports emailInvalid when email is malformed', () {
      expect(
        NotificationContactValidator.validateContact(
          phone: '600123456',
          email: 'not-an-email',
        ),
        NotificationContactValidationFailure.emailInvalid,
      );
    });
  });
}
