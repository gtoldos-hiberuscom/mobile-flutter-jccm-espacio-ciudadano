import 'package:jccm_espacio_ciudadano/features/help/0_entity/picked_attachment.dart';
import 'package:meta/meta.dart';

/// Immutable payload submitted by the citizen through the support form
/// (STORY-60). Pure value object — no Flutter, no IO, no copy strings
/// (canon §11, 0_entity layer).
///
/// Validation is implemented in `1_domain/support_form_validator.dart`
/// so this entity stays a passive carrier of values.
@immutable
final class SupportRequest {
  const SupportRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.description,
    required this.dataConsent,
    required this.captchaPassed,
    this.attachment,
  });

  /// Citizen's display name.
  final String name;

  /// Citizen's e-mail (the canonical one — confirmation field is only
  /// used during validation in the presentation layer).
  final String email;

  /// Short subject line. Hard-capped at 100 chars in the validator.
  final String subject;

  /// Long-form description of the incident. Counter / max length is
  /// enforced by the validator and surfaced by the UI.
  final String description;

  /// Optional file picked by the user.
  final PickedAttachment? attachment;

  /// Whether the user actively accepted the data-treatment notice.
  final bool dataConsent;

  /// Whether the antibot challenge was completed.
  ///
  /// MVP uses a mock checkbox (`captcha_placeholder.dart`).
  // TODO(TASK-63): replace by a real captcha SDK signal.
  final bool captchaPassed;

  SupportRequest copyWith({
    final String? name,
    final String? email,
    final String? subject,
    final String? description,
    final PickedAttachment? attachment,
    final bool clearAttachment = false,
    final bool? dataConsent,
    final bool? captchaPassed,
  }) =>
      SupportRequest(
        name: name ?? this.name,
        email: email ?? this.email,
        subject: subject ?? this.subject,
        description: description ?? this.description,
        attachment:
            clearAttachment ? null : (attachment ?? this.attachment),
        dataConsent: dataConsent ?? this.dataConsent,
        captchaPassed: captchaPassed ?? this.captchaPassed,
      );

  static const SupportRequest empty = SupportRequest(
    name: '',
    email: '',
    subject: '',
    description: '',
    dataConsent: false,
    captchaPassed: false,
  );
}
