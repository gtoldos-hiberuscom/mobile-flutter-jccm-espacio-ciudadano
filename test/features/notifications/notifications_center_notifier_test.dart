import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_center_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_provider.dart';

void main() {
  group('NotificationsCenterNotifier', () {
    ProviderContainer makeContainer({
      final int? forceErrorOnPage,
      final bool forceEmpty = false,
    }) => ProviderContainer(
      overrides: [
        notificationsRepositoryProvider.overrideWith(
          (final ref) => NotificationsRepositoryImpl(
            forceErrorOnPage: forceErrorOnPage,
            forceEmpty: forceEmpty,
          ),
        ),
      ],
    );

    test('initial build loads page 0 with no filters and hasMore=true', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = await container.read(notificationsCenterProvider.future);
      expect(state.currentPage, 0);
      expect(state.items, hasLength(6));
      expect(state.totalItems, 18);
      expect(state.hasMore, isTrue);
      expect(state.filters, isEmpty);
    });

    test('setFilters resets paging to page 0 with the new filter set', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(notificationsCenterProvider.future);

      await container.read(notificationsCenterProvider.notifier).setFilters(const <NotificationStatus>{NotificationStatus.pendiente});

      final state = container.read(notificationsCenterProvider).requireValue;
      expect(state.currentPage, 0);
      expect(state.filters, equals(<NotificationStatus>{NotificationStatus.pendiente}));
      expect(
        state.items.every((final i) => i.status == NotificationStatus.pendiente),
        isTrue,
      );
    });

    test('loadMore appends the next page and eventually clears hasMore', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(notificationsCenterProvider.future);
      final notifier = container.read(notificationsCenterProvider.notifier);

      await notifier.loadMore();
      var state = container.read(notificationsCenterProvider).requireValue;
      expect(state.items, hasLength(12));
      expect(state.currentPage, 1);
      expect(state.hasMore, isTrue);

      await notifier.loadMore();
      state = container.read(notificationsCenterProvider).requireValue;
      expect(state.items, hasLength(18));
      expect(state.currentPage, 2);
      expect(state.hasMore, isFalse);

      // Subsequent loadMore is a no-op once hasMore is false.
      await notifier.loadMore();
      state = container.read(notificationsCenterProvider).requireValue;
      expect(state.items, hasLength(18));
    });

    test('loadMore failure surfaces hasError without losing previous items', () async {
      final container = makeContainer(forceErrorOnPage: 1);
      addTearDown(container.dispose);

      await container.read(notificationsCenterProvider.future);
      await container.read(notificationsCenterProvider.notifier).loadMore();

      final state = container.read(notificationsCenterProvider).requireValue;
      expect(state.hasError, isTrue);
      expect(state.isLoadingMore, isFalse);
      // Items from page 0 remain visible.
      expect(state.items, hasLength(6));
    });

    test('initial build error path bubbles up through AsyncValue', () async {
      final container = makeContainer(forceErrorOnPage: 0);
      addTearDown(container.dispose);

      final result = await container
          .read(notificationsCenterProvider.future)
          .then<Object?>(
            (final v) => v,
            onError: (final Object e, final _) => e,
          );
      expect(result, isA<StateError>());
    });
  });
}
