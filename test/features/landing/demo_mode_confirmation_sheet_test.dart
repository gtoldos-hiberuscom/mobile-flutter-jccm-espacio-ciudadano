import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/demo_mode_confirmation_sheet.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  late bool? result;

  Future<void> pumpAndOpen(final WidgetTester tester, {final bool hasPersistedSession = false}) async {
    result = null;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (final context) => TextButton(
              onPressed: () async => result = await DemoModeConfirmationSheet.show(context, hasPersistedSession: hasPersistedSession),
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  Future<void> typeCode(final WidgetTester tester, final String code) async {
    await tester.enterText(find.byType(TextField), code);
    await tester.pump();
  }

  /// La hoja desplaza su contenido: con el campo de código, los botones pueden
  /// quedar fuera del viewport del test.
  Future<void> tapButton(final WidgetTester tester, final String label) async {
    final button = find.text(label);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('explica qué es la demo, pide el código y ofrece entrar o volver', (final tester) async {
    await pumpAndOpen(tester);

    expect(find.text('Modo demostración'), findsOneWidget);
    expect(find.textContaining('datos ficticios'), findsOneWidget);
    expect(find.textContaining(RegExp('código de acceso', caseSensitive: false)), findsOneWidget);
    expect(find.text('Entrar en la demostración'), findsOneWidget);
    expect(find.text('Volver'), findsOneWidget);
  });

  testWidgets('con un código incorrecto no entra y marca el error en el campo', (final tester) async {
    await pumpAndOpen(tester);

    await typeCode(tester, '0000');
    await tapButton(tester, 'Entrar en la demostración');

    expect(result, isNull, reason: 'la hoja sigue abierta');
    expect(find.text('Modo demostración'), findsOneWidget);
    expect(find.textContaining('Código incorrecto'), findsOneWidget);
  });

  testWidgets('corregir el código retira el error', (final tester) async {
    await pumpAndOpen(tester);
    await typeCode(tester, '0000');
    await tapButton(tester, 'Entrar en la demostración');

    await typeCode(tester, '12');

    expect(find.textContaining('Código incorrecto'), findsNothing);
  });

  testWidgets('con el código correcto devuelve true', (final tester) async {
    await pumpAndOpen(tester);

    await typeCode(tester, DemoSession.accessCode);
    await tapButton(tester, 'Entrar en la demostración');

    expect(result, isTrue);
    expect(find.text('Modo demostración'), findsNothing);
  });

  testWidgets('el teclado también confirma (acción «hecho»)', (final tester) async {
    await pumpAndOpen(tester);

    await typeCode(tester, DemoSession.accessCode);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('«Volver» devuelve false sin pedir código', (final tester) async {
    await pumpAndOpen(tester);

    await tapButton(tester, 'Volver');

    expect(result, isFalse);
    expect(find.text('Modo demostración'), findsNothing);
  });

  testWidgets('con sesión guardada avisa de que se cerrará y el botón lo dice', (final tester) async {
    await pumpAndOpen(tester, hasPersistedSession: true);

    expect(find.textContaining('sesión guardada con acceso rápido'), findsOneWidget);
    expect(find.text('Cerrar la sesión guardada y entrar'), findsOneWidget);
    expect(find.text('Entrar en la demostración'), findsNothing);
  });
}
