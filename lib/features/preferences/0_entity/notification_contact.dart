import 'package:meta/meta.dart';

@immutable
final class NotificationContact {
  const NotificationContact({
    this.phone,
    this.email,
  });

  final String? phone;
  final String? email;

  bool get hasAnyContact => (phone?.isNotEmpty ?? false) || (email?.isNotEmpty ?? false);

  NotificationContact copyWith({
    final String? phone,
    final String? email,
  }) => NotificationContact(
    phone: phone ?? this.phone,
    email: email ?? this.email,
  );
}
