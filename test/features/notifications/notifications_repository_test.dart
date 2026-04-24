import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_page_request.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_impl.dart';

void main() {
  group('NotificationsRepositoryImpl', () {
    test('paginates the catalog in 6-item pages by default', () async {
      final repo = NotificationsRepositoryImpl();
      final page0 = await repo.fetchPage(
        const NotificationPageRequest(page: 0, pageSize: 6),
      );
      expect(page0.items, hasLength(6));
      expect(page0.totalItems, 18);
      expect(page0.hasMore, isTrue);

      final page1 = await repo.fetchPage(
        const NotificationPageRequest(page: 1, pageSize: 6),
      );
      expect(page1.items, hasLength(6));
      expect(page1.hasMore, isTrue);

      final page2 = await repo.fetchPage(
        const NotificationPageRequest(page: 2, pageSize: 6),
      );
      expect(page2.items, hasLength(6));
      expect(page2.hasMore, isFalse);

      final page3 = await repo.fetchPage(
        const NotificationPageRequest(page: 3, pageSize: 6),
      );
      expect(page3.items, isEmpty);
      expect(page3.hasMore, isFalse);
    });

    test('intersects results with the requested status filter', () async {
      final repo = NotificationsRepositoryImpl();
      final result = await repo.fetchPage(
        const NotificationPageRequest(
          page: 0,
          pageSize: 100,
          statusFilter: <NotificationStatus>{NotificationStatus.pendiente},
        ),
      );
      expect(result.items, isNotEmpty);
      expect(
        result.items.every((final i) => i.status == NotificationStatus.pendiente),
        isTrue,
      );
      expect(result.totalItems, result.items.length);
      expect(result.hasMore, isFalse);
    });

    test('an empty filter set means "all statuses"', () async {
      final repo = NotificationsRepositoryImpl();
      final result = await repo.fetchPage(
        const NotificationPageRequest(page: 0, pageSize: 100),
      );
      expect(result.totalItems, 18);
    });

    test('intersection of multiple statuses returns the union of items', () async {
      final repo = NotificationsRepositoryImpl();
      final result = await repo.fetchPage(
        const NotificationPageRequest(
          page: 0,
          pageSize: 100,
          statusFilter: <NotificationStatus>{
            NotificationStatus.aceptada,
            NotificationStatus.rechazada,
          },
        ),
      );
      final hasOther = result.items.any(
        (final i) =>
            i.status != NotificationStatus.aceptada && i.status != NotificationStatus.rechazada,
      );
      expect(hasOther, isFalse);
      expect(result.items, isNotEmpty);
    });

    test('forceErrorOnPage throws on the matching page', () async {
      final repo = NotificationsRepositoryImpl(forceErrorOnPage: 1);
      await repo.fetchPage(const NotificationPageRequest(page: 0, pageSize: 6));
      expect(
        () => repo.fetchPage(const NotificationPageRequest(page: 1, pageSize: 6)),
        throwsA(isA<StateError>()),
      );
    });

    test('forceEmpty returns an empty page with hasMore=false', () async {
      final repo = NotificationsRepositoryImpl(forceEmpty: true);
      final result = await repo.fetchPage(
        const NotificationPageRequest(page: 0, pageSize: 6),
      );
      expect(result.items, isEmpty);
      expect(result.hasMore, isFalse);
    });
  });
}
