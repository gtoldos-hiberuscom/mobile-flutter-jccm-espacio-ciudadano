import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/usecases/load_notification_contact_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/usecases/save_notification_contact_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/3_data/notification_contact_repository_impl.dart';

final notificationContactRepositoryProvider = Provider<NotificationContactRepository>((final ref) {
  return NotificationContactRepositoryImpl(dio: ref.watch(dioProvider));
});

final loadNotificationContactUsecaseProvider = Provider<LoadNotificationContactUsecase>((final ref) {
  return LoadNotificationContactUsecase(ref.watch(notificationContactRepositoryProvider));
});

final saveNotificationContactUsecaseProvider = Provider<SaveNotificationContactUsecase>((final ref) {
  return SaveNotificationContactUsecase(ref.watch(notificationContactRepositoryProvider));
});

final notificationContactProvider = FutureProvider.autoDispose.family<NotificationContact?, String>((final ref, final citizenId) async {
  if (citizenId.isEmpty) {
    return null;
  }

  final result = await ref.watch(loadNotificationContactUsecaseProvider).execute(citizenId: citizenId);
  return switch (result) {
    LoadNotificationContactSuccess(:final contact) => contact,
    // AsyncError, nunca null: "no se pudo cargar" ≠ "no hay contacto". Aplanar
    // el fallo renderizaba un formulario en blanco cuyo guardado sobrescribía
    // el contacto real registrado (canal legal de notificaciones).
    LoadNotificationContactFailed(:final message) => throw StateError(message),
  };
});
