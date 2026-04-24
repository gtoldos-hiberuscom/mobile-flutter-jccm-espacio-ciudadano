// ignore_for_file: avoid_classes_with_only_static_members

import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact_validation_failure.dart';

/// Pure validation rules for citizen contact registration (STORY-42).
///
/// Lives in the domain layer — no Flutter / Riverpod / Dio (canon §12).
/// Mirrors the AC: at least one channel must be supplied, and any
/// supplied channel must look syntactically valid.
abstract final class NotificationContactValidator {
  /// Lightweight E.164 / Spanish mobile validation.
  ///
  /// Accepts an optional leading `+` followed by 9–15 digits. Whitespace
  /// and dashes are tolerated and stripped before checking. Returns
  /// `null` when the value is acceptable, otherwise
  /// [NotificationContactValidationFailure.phoneInvalid].
  static NotificationContactValidationFailure? validatePhone(final String value) {
    final normalised = value.replaceAll(RegExp(r'[\s-]'), '');
    if (normalised.isEmpty) {
      return NotificationContactValidationFailure.phoneInvalid;
    }
    final pattern = RegExp(r'^\+?\d{9,15}$');
    if (!pattern.hasMatch(normalised)) {
      return NotificationContactValidationFailure.phoneInvalid;
    }
    return null;
  }

  /// Conservative email syntax check — rejects empty values and any
  /// string lacking a single `@` with a dotted domain.
  static NotificationContactValidationFailure? validateEmail(final String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return NotificationContactValidationFailure.emailInvalid;
    }
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(trimmed)) {
      return NotificationContactValidationFailure.emailInvalid;
    }
    return null;
  }

  /// Aggregates the per-field rules and the cross-field rule
  /// "at least one channel is required".
  ///
  /// Returns `null` when the combination is valid.
  static NotificationContactValidationFailure? validateContact({
    final String? phone,
    final String? email,
  }) {
    final phoneTrimmed = (phone ?? '').trim();
    final emailTrimmed = (email ?? '').trim();
    if (phoneTrimmed.isEmpty && emailTrimmed.isEmpty) {
      return NotificationContactValidationFailure.bothEmpty;
    }
    if (phoneTrimmed.isNotEmpty) {
      final phoneError = validatePhone(phoneTrimmed);
      if (phoneError != null) {
        return phoneError;
      }
    }
    if (emailTrimmed.isNotEmpty) {
      final emailError = validateEmail(emailTrimmed);
      if (emailError != null) {
        return emailError;
      }
    }
    return null;
  }
}
