import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('usa un nombre localizado y conserva la edición accesible', (final tester) async {
    await tester.pumpWidget(buildApp(const AppSearchField()));
    await tester.tap(find.byType(TextField));
    await tester.pump();

    final semantics = tester.getSemantics(find.byType(TextField));
    final expectedLabel = MaterialLocalizations.of(tester.element(find.byType(TextField))).searchFieldLabel;
    expect(semantics.label, startsWith(expectedLabel));
    expect(semantics.flagsCollection.isTextField, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.setText), isTrue);
  });

  testWidgets('permite un nombre específico del contexto', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppSearchField(semanticsLabel: 'Buscar en el aviso legal'),
      ),
    );

    expect(tester.getSemantics(find.byType(TextField)).label, startsWith('Buscar en el aviso legal'));
  });

  testWidgets('la acción buscar ejecuta onSubmitted', (final tester) async {
    String? query;
    await tester.pumpWidget(
      buildApp(AppSearchField(onSubmitted: (final value) => query = value)),
    );

    await tester.enterText(find.byType(TextField), 'protección de datos');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(query, 'protección de datos');
  });

  testWidgets('deshabilitado y solo lectura anuncian su estado', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppSearchField(enabled: false)),
    );

    var semantics = tester.getSemantics(find.byType(TextField));
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);

    await tester.pumpWidget(
      buildApp(const AppSearchField(readOnly: true)),
    );
    semantics = tester.getSemantics(find.byType(TextField));
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.flagsCollection.isReadOnly, isTrue);
  });

  testWidgets('mantiene al menos 48 dp y admite texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppSearchField(
            semanticsLabel: 'Buscar dentro de la declaración de privacidad',
            hintText: 'Introduce palabras para buscar',
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppSearchField)).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });
}
