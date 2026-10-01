import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/notification_contact_page.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('un contacto no encontrado informa de que el ciudadano no está dado de alta', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ciudadanosEndpointIdProvider.overrideWithValue('PER1'),
          notificationContactProvider.overrideWith((final _, final _) async => null),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotificationContactPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(NotificationContactPage)));
    expect(find.text(l10n.notificationContactNotRegistered), findsOneWidget);
    expect(find.text(l10n.appNotificationContactFormSaveButton), findsOneWidget);
  });
}
