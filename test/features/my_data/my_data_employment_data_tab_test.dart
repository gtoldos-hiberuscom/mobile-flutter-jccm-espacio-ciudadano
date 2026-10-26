import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_provider.dart';
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
      find.text('Autoriza el uso de tus datos desde tus preferencias para consultar el estado de tu demanda de empleo.'),
      findsOneWidget,
    );
    expect(find.text('INSCRIPCIÓN NO ACTIVA'), findsNothing);
    expect(find.text('FECHA DE INSCRIPCIÓN SIN INTERRUPCIONES'), findsNothing);
    expect(find.text('-'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
    expect(find.text('Mi demanda de empleo'), findsOneWidget);
  });

  testWidgets('el error de Demanda no duplica ni muestra errores de Inscripciones sin autorización', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ageDataAuthorizationProvider.overrideWith((final ref) async => true),
          jccmDataAuthorizationProvider.overrideWith((final ref) async => false),
          employmentDemandProvider.overrideWith((final ref) async => throw StateError('Servicio no disponible')),
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

    expect(find.text('El servicio de Demanda de empleo actualmente no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
    expect(find.text('INSCRIPCIÓN NO ACTIVA'), findsNothing);
    expect(find.text('Inscripciones en ofertas'), findsOneWidget);
    expect(find.text('Autoriza el uso de tus datos desde tus preferencias para consultar tus inscripciones en ofertas de empleo.'), findsOneWidget);
    expect(find.text('No hemos podido cargar tus inscripciones en ofertas de empleo. Vuelve a intentarlo más tarde.'), findsNothing);
  });
}
