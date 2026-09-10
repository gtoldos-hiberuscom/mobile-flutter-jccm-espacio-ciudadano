import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offer_registration_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('muestra estado largo y finalización sin fecha disponible', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: MyDataEmploymentOfferRegistrationCard(
                offer: EmploymentOfferRegistration(
                  title: 'Auxiliar Administrativo',
                  applicationStatus: 'El estado de la candidatura puede ser largo',
                  publicationDate: DateTime(2026, 11, 8),
                  registrationDate: DateTime(2001, 11, 8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('FECHA DE FINALIZACIÓN DEL PROCESO DE SELECCIÓN'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
    final status = find.text('EL ESTADO DE LA CANDIDATURA PUEDE SER LARGO');
    expect(status, findsOneWidget);
    expect(tester.getTopLeft(status).dy, lessThan(tester.getTopLeft(find.byType(Divider)).dy));
    expect(find.text('8 nov 2026'), findsOneWidget);
    expect(find.text('8 nov 2001'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
