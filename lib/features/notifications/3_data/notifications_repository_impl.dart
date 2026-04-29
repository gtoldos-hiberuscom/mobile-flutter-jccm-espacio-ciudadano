import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_item.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_page_request.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_repository.dart';

/// Mock implementation of [NotificationsRepository] for STORY-41.
///
/// Returns a deterministic catalog of 18 notifications spread across
/// the four lifecycle states (pendiente / aceptada / rechazada /
/// caducada). Pagination uses the requested `pageSize` (default 6 from
/// the notifier ⇒ 3 pages); filtering intersects against
/// `request.statusFilter` (an empty set means "all statuses").
///
/// Real Dio wiring against `POST /servicio/midetalle` is deferred —
/// see `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
/// The constructor flags ([forceErrorOnPage] / [forceEmpty]) exist so
/// widget and notifier tests can exercise the error and empty surfaces
/// without monkey-patching the catalog.
// TODO(future-sprint): replace mock with Dio-backed datasource bound to
// `ServicioApi.miDetalleOperation` once the value-set for `estado` is
// confirmed by backend.
final class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({
    this.forceErrorOnPage,
    this.forceEmpty = false,
  });

  /// When set, the repository throws on the matching page index. Used by
  /// notifier tests to drive the `loadMore` error branch.
  final int? forceErrorOnPage;

  /// When `true`, every fetch returns an empty page regardless of
  /// filters or pagination. Used by widget tests to exercise the empty
  /// state.
  final bool forceEmpty;

  static final List<NotificationItem> _catalog = _buildCatalog();

  @override
  Future<NotificationPageResult> fetchPage(
    final NotificationPageRequest request,
  ) async {
    if (forceErrorOnPage != null && forceErrorOnPage == request.page) {
      throw StateError('mock: forced error on page ${request.page}');
    }
    if (forceEmpty) {
      return NotificationPageResult(
        items: const <NotificationItem>[],
        totalItems: 0,
        page: request.page,
        pageSize: request.pageSize,
        hasMore: false,
      );
    }
    final filtered = request.statusFilter.isEmpty ? _catalog : _catalog.where((final item) => request.statusFilter.contains(item.status)).toList(growable: false);
    final start = request.page * request.pageSize;
    if (start >= filtered.length) {
      return NotificationPageResult(
        items: const <NotificationItem>[],
        totalItems: filtered.length,
        page: request.page,
        pageSize: request.pageSize,
        hasMore: false,
      );
    }
    final end = (start + request.pageSize).clamp(0, filtered.length);
    final pageItems = filtered.sublist(start, end);
    final hasMore = end < filtered.length;
    return NotificationPageResult(
      items: List<NotificationItem>.unmodifiable(pageItems),
      totalItems: filtered.length,
      page: request.page,
      pageSize: request.pageSize,
      hasMore: hasMore,
    );
  }

  static List<NotificationItem> _buildCatalog() {
    // Anchor on a fixed reference date so the mock is fully
    // deterministic in tests and snapshots.
    final reference = DateTime(2026, 5, 4, 10);
    const statuses = <NotificationStatus>[
      NotificationStatus.pendiente,
      NotificationStatus.aceptada,
      NotificationStatus.rechazada,
      NotificationStatus.caducada,
    ];
    const organismos = <String>[
      'Consejería de Educación',
      'Consejería de Sanidad',
      'Consejería de Hacienda',
      'Servicio Público de Empleo',
    ];
    final items = <NotificationItem>[];
    for (var index = 0; index < 18; index++) {
      final status = statuses[index % statuses.length];
      final fechaEmision = reference.subtract(Duration(days: index));
      final fechaCaducidad = status == NotificationStatus.caducada ? fechaEmision.add(const Duration(days: 7)) : fechaEmision.add(const Duration(days: 30));
      items.add(
        NotificationItem(
          id: 'NOT-${(index + 1).toString().padLeft(4, '0')}',
          asunto: 'Notificación administrativa #${index + 1}',
          organismoEmisor: organismos[index % organismos.length],
          fechaEmision: fechaEmision,
          fechaCaducidad: fechaCaducidad,
          status: status,
          hasDocuments: index.isEven,
        ),
      );
    }
    return List<NotificationItem>.unmodifiable(items);
  }
}
