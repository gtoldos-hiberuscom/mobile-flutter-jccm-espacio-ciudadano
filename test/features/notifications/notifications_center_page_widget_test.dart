import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_center_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/notifications_center_page.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _wrap({
  required final Widget child,
  final bool forceEmpty = false,
}) => ProviderScope(
  overrides: [
    notificationsRepositoryProvider.overrideWith(
      (final ref) => NotificationsRepositoryImpl(forceEmpty: forceEmpty),
    ),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: child,
  ),
);

void main() {
  testWidgets('renders title, filter chips and the first page of items', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap(child: const NotificationsCenterPage()));
    // Initial frame is loading; the second pump (after the mock future
    // resolves) renders the data state. We avoid pumpAndSettle because
    // the load-more footer hosts a perpetual CircularProgressIndicator.
    await tester.pump();
    await tester.pump();

    expect(find.text('Mis notificaciones'), findsOneWidget);
    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('Pendiente'), findsWidgets);
    expect(find.text('Aceptada'), findsWidgets);
    expect(find.text('Rechazada'), findsWidgets);
    expect(find.text('Caducada'), findsWidgets);
    // ListView lazy-builds tiles; assert that at least the visible ones
    // render plus the pagination footer reflects the full first page.
    expect(find.textContaining('Notificación administrativa'), findsWidgets);
    expect(find.text('Mostrando 6 de 18'), findsOneWidget);
  });

  testWidgets('tapping the Pendiente filter narrows the listing', (final tester) async {
    await tester.pumpWidget(_wrap(child: const NotificationsCenterPage()));
    await tester.pump();
    await tester.pump();

    // Use the notifier directly: the FilterChip lives in a horizontal
    // scroll view and may not be hit-testable depending on the test
    // viewport. The interaction we care about for this widget test is
    // that the page rebuilds correctly when the filter set changes.
    final notifier = ProviderScope.containerOf(
      tester.element(find.byType(NotificationsCenterPage)),
    ).read(notificationsCenterProvider.notifier);
    await notifier.setFilters(const <NotificationStatus>{NotificationStatus.pendiente});
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // The mock catalog distributes 18 items across the 4 statuses via
    // index%4 — 'pendiente' lands on indices 0, 4, 8, 12, 16 ⇒ 5 items.
    expect(find.text('Mostrando 5 de 5'), findsOneWidget);
  });

  testWidgets('shows the empty state when no notifications match', (
    final tester,
  ) async {
    await tester.pumpWidget(
      _wrap(forceEmpty: true, child: const NotificationsCenterPage()),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('No hay notificaciones'), findsOneWidget);
    expect(
      find.textContaining('No hemos encontrado notificaciones'),
      findsOneWidget,
    );
  });
}
