import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_demand_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_disabled_demand_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('muestra título, estado, separador y fecha en el orden de diseño', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('es')],
        home: Scaffold(
          body: MyDataEmploymentDemandCard(
            demand: EmploymentDemand(
              status: 'Activa',
              uninterruptedRegistrationDate: DateTime(2000, 7),
            ),
          ),
        ),
      ),
    );

    final title = find.text('Mi demanda de empleo');
    final status = find.text('ACTIVA');
    final dateLabel = find.text('FECHA DE INSCRIPCIÓN SIN INTERRUPCIONES');
    final date = find.text('1 jul 2000');

    expect(title, findsOneWidget);
    expect(status, findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
    expect(dateLabel, findsOneWidget);
    expect(date, findsOneWidget);
    expect(tester.getTopLeft(title).dy, lessThan(tester.getTopLeft(status).dy));
    expect(tester.getTopLeft(status).dy, lessThan(tester.getTopLeft(dateLabel).dy));
    expect(tester.getTopLeft(dateLabel).dy, lessThan(tester.getTopLeft(date).dy));
  });

  testWidgets('muestra INSCRIPCIÓN NO ACTIVA cuando no existe una demanda activa', (final tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [Locale('es')],
        home: Scaffold(body: MyDataEmploymentDisabledDemandCard()),
      ),
    );

    expect(find.text('Mi demanda de empleo'), findsOneWidget);
    expect(find.text('INSCRIPCIÓN NO ACTIVA'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
  });
}
