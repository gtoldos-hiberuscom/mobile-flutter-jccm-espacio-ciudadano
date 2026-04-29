import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_repository.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_impl.dart';

/// DI composition for [NotificationDetailRepository] (STORY-43).
///
/// Kept alive so the deterministic mock catalog is built once per
/// session. The real Dio-backed adapter (deferred to TASK-47) will
/// benefit from the same lifetime when wired against
/// `/notifications/*`.
///
/// Hand-written (no `@riverpod` codegen) on purpose — STORY-45 already
/// documents why we avoid the generator for self-contained slices.
final notificationDetailRepositoryProvider = Provider<NotificationDetailRepository>(
  (final ref) => NotificationDetailRepositoryImpl(),
  name: 'notificationDetailRepositoryProvider',
);
