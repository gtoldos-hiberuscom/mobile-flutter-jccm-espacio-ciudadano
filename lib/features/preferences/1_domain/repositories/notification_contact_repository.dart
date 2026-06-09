import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';

abstract interface class NotificationContactRepository {
  Future<NotificationContact?> loadContact({required final String citizenId});

  Future<NotificationContact> saveContact({
    required final String citizenId,
    required final String dni,
    required final NotificationContact contact,
  });
}
