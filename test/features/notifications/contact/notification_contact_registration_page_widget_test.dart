import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/2_presentation/notification_contact_registration_page.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

GoRouter _buildRouter() => GoRouter(
  initialLocation: '/notifications/contact/registration',
  routes: <RouteBase>[
    GoRoute(
      path: '/notifications',
      builder: (final context, final state) => const Scaffold(body: Text('NOTIFICATIONS_HOME')),
    ),
    GoRoute(
      path: '/notifications/contact/registration',
      builder: (final context, final state) => const NotificationContactRegistrationPage(),
    ),
  ],
);

Widget _wrap({final GoRouter? router}) {
  final r = router ?? _buildRouter();
  return ProviderScope(
    overrides: [
      notificationContactRepositoryProvider.overrideWith(
        (final ref) => NotificationContactRepositoryImpl(),
      ),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      routerConfig: r,
    ),
  );
}

void main() {
  testWidgets('empty form submission shows the bothEmpty validation snackbar', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump();

    expect(find.text('Datos de contacto'), findsOneWidget);

    await tester.tap(find.byKey(const Key('notification_contact_submit_button')));
    await tester.pump();
    await tester.pump();

    expect(
      find.byKey(const Key('notification_contact_validation_snackbar')),
      findsOneWidget,
    );
    expect(
      find.text('Indica al menos un teléfono móvil o un correo electrónico.'),
      findsOneWidget,
    );
  });

  testWidgets('happy path shows the success snackbar', (final tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('notification_contact_email_field')),
      'user@example.com',
    );
    await tester.tap(find.byKey(const Key('notification_contact_submit_button')));
    // Allow the 300ms mock latency to elapse and the post-submit
    // reload to finish.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(
      find.byKey(const Key('notification_contact_success_snackbar')),
      findsAtLeastNWidgets(1),
    );
  });
}
