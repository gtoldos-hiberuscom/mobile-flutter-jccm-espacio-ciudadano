import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_content.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('no repite dentro del contenido el título que ya muestra el app bar', (final tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [Locale('es')],
        home: Scaffold(
          body: MyDataEmploymentOffersContent(
            offers: [EmploymentOfferRegistration(title: 'ATS/DUE', applicationStatus: 'Inscrita')],
          ),
        ),
      ),
    );

    expect(find.text('Inscripción en ofertas de empleo'), findsNothing);
    expect(find.text('ATS/DUE'), findsOneWidget);
  });
}
