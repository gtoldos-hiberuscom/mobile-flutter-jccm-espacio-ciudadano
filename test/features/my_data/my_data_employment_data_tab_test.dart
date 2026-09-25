import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_data_tab.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('sin autorizacion AGE mantiene la tarjeta pero no afirma que la inscripcion este inactiva', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ageDataAuthorizationProvider.overrideWith((final ref) async => false),
          jccmDataAuthorizationProvider.overrideWith((final ref) async => true),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: [Locale('es')],
          home: Scaffold(body: MyDataEmploymentDataTab()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Debes autorizar la consulta de los datos que la Administración General del Estado tiene sobre ti desde tus preferencias.'),
      findsOneWidget,
    );
    expect(find.text('INSCRIPCIÓN NO ACTIVA'), findsNothing);
    expect(find.text('FECHA DE INSCRIPCIÓN SIN INTERRUPCIONES'), findsNothing);
    expect(find.text('-'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
    expect(find.text('Mi demanda de empleo'), findsOneWidget);
  });
}
