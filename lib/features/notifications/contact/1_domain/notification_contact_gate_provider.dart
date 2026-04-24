import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_contact_gate_provider.g.dart';

/// Aggregates the contact-loading state into a [NotificationContactStatus]
/// usable as a guard surface (STORY-42).
///
/// Future tickets can read this provider to drive missing-contact
/// banners or hard guards before allowing the citizen to operate
/// notifications.
@riverpod
Future<NotificationContactStatus> notificationContactGate(final Ref ref) async {
  final contact = await ref.watch(notificationContactProvider.future);
  if (contact == null || !contact.hasAnyChannel) {
    return NotificationContactStatus.missing;
  }
  return NotificationContactStatus.configured;
}
