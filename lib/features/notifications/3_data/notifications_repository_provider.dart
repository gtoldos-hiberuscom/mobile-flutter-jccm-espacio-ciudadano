import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_repository.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_repository_provider.g.dart';

/// DI composition for [NotificationsRepository].
///
/// Kept alive so the catalog is built once per session — the mock
/// implementation is stateless but the real Dio adapter (deferred)
/// will benefit from this lifetime when wired against
/// `ServicioApi.miDetalleOperation`.
@Riverpod(keepAlive: true)
NotificationsRepository notificationsRepository(final Ref ref) => NotificationsRepositoryImpl();
