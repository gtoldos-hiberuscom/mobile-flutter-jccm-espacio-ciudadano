import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/2_presentation/widgets/notification_contact_gate_banner.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _wrap({final NotificationContact? seed}) => ProviderScope(
  overrides: [
    notificationContactRepositoryProvider.overrideWith(
      (final ref) => NotificationContactRepositoryImpl(seed: seed),
    ),
  ],
  // ignore: prefer_const_constructors
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: const Scaffold(body: NotificationContactGateBanner()),
  ),
);

void main() {
  testWidgets('renders the banner when status is missing', (final tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump();

    expect(
      find.byKey(const Key('notification_contact_gate_banner')),
      findsOneWidget,
    );
    expect(
      find.text('Configura tus datos de contacto para recibir notificaciones.'),
      findsOneWidget,
    );
  });

  testWidgets('hides the banner when status is configured', (final tester) async {
    await tester.pumpWidget(
      _wrap(seed: const NotificationContact(email: 'user@example.com')),
    );
    await tester.pump();
    await tester.pump();

    expect(
      find.byKey(const Key('notification_contact_gate_banner')),
      findsNothing,
    );
  });
}
