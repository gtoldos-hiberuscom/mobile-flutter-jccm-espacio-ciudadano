import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_health_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// WCAG 1.3.1: la sección de citas, el año y el mes son encabezados; el mes
/// se anuncia con su año.
void main() {
  testWidgets('«Citas de atención primaria», el año y «septiembre de 2026» son encabezados', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          jccmDataAuthorizationProvider.overrideWith((final ref) async => true),
          myDataHealthCipProvider.overrideWith((final ref) async => 'CIP123'),
          myDataPrimaryCarePendingAppointmentsProvider.overrideWith(
            (final ref) async => [
              HealthAppointment(
                dateTime: DateTime(2026, 9, 23, 8, 25),
                professional: 'Dra. García',
                description: 'Medicina de familia',
                channel: 'Telefónica',
                center: 'Campo de Criptana',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MyDataHealthPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataHealthPage)));

    final section = find.semantics.byLabel(l10n.myDataHealthAppointmentsTitle).evaluate().single;
    expect(section.flagsCollection.isHeader, isTrue);
    expect(section.headingLevel, 2);

    final year = find.semantics.byLabel('2026').evaluate().single;
    expect(year.flagsCollection.isHeader, isTrue);
    expect(year.headingLevel, 3);

    final month = find.semantics.byLabel('septiembre de 2026').evaluate().single;
    expect(month.flagsCollection.isHeader, isTrue);
    expect(month.headingLevel, 4);

    // La cita se anuncia en un único nodo, con el canal incluido.
    expect(find.semantics.byLabel(RegExp('23.*Medicina de familia.*Telefónica')), findsOneWidget);
  });
}
