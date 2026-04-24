import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_repository.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_contact_repository_provider.g.dart';

/// DI composition for [NotificationContactRepository] (STORY-42).
///
/// Kept alive so the in-memory mock survives the lifetime of the
/// session. When the real Dio adapter lands, the keepAlive lifetime
/// will mirror the rest of the notifications data layer.
@Riverpod(keepAlive: true)
NotificationContactRepository notificationContactRepository(final Ref ref) =>
    NotificationContactRepositoryImpl();
