import 'package:meta/meta.dart';

@immutable
final class NotificationContact {
  const NotificationContact({
    this.idTercero,
    this.phone,
    this.email,
  });

  final int? idTercero;
  final String? phone;
  final String? email;

  bool get hasAnyContact => (phone?.isNotEmpty ?? false) || (email?.isNotEmpty ?? false);

  NotificationContact copyWith({
    final int? idTercero,
    final String? phone,
    final String? email,
  }) => NotificationContact(
    idTercero: idTercero ?? this.idTercero,
    phone: phone ?? this.phone,
    email: email ?? this.email,
  );
}
