import 'dart:ui' show SemanticsAction, SemanticsValidationResult, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone un campo multilínea obligatorio y editable', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInputArea(
          label: 'Observaciones',
          isRequired: true,
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();

    final semantics = find.semantics.byLabel('Observaciones').evaluate().single;
    expect(semantics.flagsCollection.isTextField, isTrue);
    expect(semantics.flagsCollection.isMultiline, isTrue);
    expect(semantics.flagsCollection.isRequired, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.setText), isTrue);
  });

  testWidgets('el boton anuncia y actualiza el estado expandido', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppInputArea(label: 'Observaciones')),
    );

    var button = find.semantics.byLabel('Ampliar Observaciones').evaluate().single;
    expect(button.flagsCollection.isButton, isTrue);
    expect(button.flagsCollection.isExpanded, Tristate.isFalse);
    expect(button.flagsCollection.isEnabled, Tristate.isTrue);
    expect(tester.getSize(find.byType(IconButton)), const Size(48, 48));

    tester.semantics.tap(find.semantics.byLabel('Ampliar Observaciones'));
    await tester.pumpAndSettle();

    button = find.semantics.byLabel('Contraer Observaciones').evaluate().single;
    expect(button.flagsCollection.isExpanded, Tristate.isTrue);
  });

  testWidgets('deshabilitado bloquea campo y expansion', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppInputArea(label: 'Observaciones', enabled: false)),
    );

    final field = find.semantics.byLabel('Observaciones').evaluate().single;
    final button = find.semantics.byLabel('Ampliar Observaciones').evaluate().single;
    expect(field.flagsCollection.isEnabled, Tristate.isFalse);
    expect(button.flagsCollection.isEnabled, Tristate.isFalse);
    expect(button.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('asocia el error sin duplicar su descripcion visual', (final tester) async {
    const combinedLabel = 'Observaciones, Escribe al menos diez caracteres';

    await tester.pumpWidget(
      buildApp(
        const AppInputArea(
          label: 'Observaciones',
          state: AppInputState.error,
          description: 'Escribe al menos diez caracteres',
          descriptionState: AppDescriptionTextState.error,
        ),
      ),
    );

    final semantics = find.semantics.byLabel(combinedLabel).evaluate().single;
    expect(semantics.getSemanticsData().validationResult, SemanticsValidationResult.invalid);
    expect(find.semantics.byLabel('Escribe al menos diez caracteres'), findsNothing);
  });

  testWidgets('propaga la configuracion de entrada multilínea', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInputArea(
          label: 'Observaciones',
          autofillHints: [AutofillHints.fullStreetAddress],
          autocorrect: false,
          enableSuggestions: false,
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.keyboardType, TextInputType.multiline);
    expect(field.textInputAction, TextInputAction.newline);
    expect(field.autofillHints, [AutofillHints.fullStreetAddress]);
    expect(field.autocorrect, isFalse);
    expect(field.enableSuggestions, isFalse);
  });

  testWidgets('admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppInputArea(
            label: 'Explica detalladamente el motivo de tu solicitud',
            description: 'Incluye toda la informacion que consideres necesaria',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
