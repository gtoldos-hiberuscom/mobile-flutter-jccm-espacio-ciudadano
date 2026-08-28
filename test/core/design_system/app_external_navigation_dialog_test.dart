import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('requires confirmation before leaving the application', (
    final tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (final context) => TextButton(
            onPressed: () async {
              result = await AppExternalNavigationDialog.show(context);
            },
            child: const Text('Abrir enlace'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir enlace'));
    await tester.pumpAndSettle();

    expect(find.text('Vas a salir de la aplicación'), findsOneWidget);
    expect(
      find.text('El contenido se abrirá en una ventana de tu navegador'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('returns true when the user continues', (final tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (final context) => TextButton(
            onPressed: () async {
              result = await AppExternalNavigationDialog.show(context);
            },
            child: const Text('Abrir enlace'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir enlace'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });
}
