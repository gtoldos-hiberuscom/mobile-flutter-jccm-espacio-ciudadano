import 'package:meta/meta.dart';

/// Citizen contact data used by the electronic notifications platform
/// (STORY-42).
///
/// Pure value type — no Flutter / Dio / Riverpod (canon §11). Either
/// [phoneE164] or [email] (or both) MUST be provided; an instance with
/// neither value is considered invalid and must be rejected by the
/// domain validator.
@immutable
final class NotificationContact {
  const NotificationContact({this.phoneE164, this.email});

  /// Mobile phone number stored in E.164 format (e.g. `+34600123456`).
  final String? phoneE164;

  /// Email address used to receive electronic-notification alerts.
  final String? email;

  /// `true` when the entity holds at least one non-empty channel.
  bool get hasAnyChannel => (phoneE164 != null && phoneE164!.trim().isNotEmpty) || (email != null && email!.trim().isNotEmpty);

  @override
  bool operator ==(final Object other) => identical(this, other) || (other is NotificationContact && other.phoneE164 == phoneE164 && other.email == email);

  @override
  int get hashCode => Object.hash(phoneE164, email);

  @override
  String toString() => 'NotificationContact(phoneE164: $phoneE164, email: $email)';
}
