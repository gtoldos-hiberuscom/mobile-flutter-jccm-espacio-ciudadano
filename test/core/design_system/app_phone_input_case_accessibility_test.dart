import 'dart:ui' show SemanticsAction, SemanticsValidationResult, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_phone_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone el campo telefónico con nombre y configuración', (final tester) async {
    final controller = TextEditingController(text: '600000000');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildApp(
        AppPhoneInputCase(
          label: 'Telefono movil',
          controller: controller,
          isRequired: true,
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();

    final semantics = find.semantics.byLabel('Telefono movil').evaluate().single;
    expect(semantics.flagsCollection.isTextField, isTrue);
    expect(semantics.flagsCollection.isRequired, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.setText), isTrue);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.keyboardType, TextInputType.phone);
    expect(field.textInputAction, TextInputAction.next);
    expect(field.autofillHints, [AutofillHints.telephoneNumber]);
  });

  testWidgets('selector de país tiene nombre, rol, acción y 48 dp', (final tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var taps = 0;

    await tester.pumpWidget(
      buildApp(
        AppPhoneInputCase(
          label: 'Telefono',
          controller: controller,
          onSelectorTap: () => taps++,
        ),
      ),
    );

    final selector = find.semantics.byLabel('Seleccionar prefijo telefónico, actual (ES)');
    final semantics = selector.evaluate().single;
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));

    tester.semantics.tap(selector);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('deshabilitado bloquea campo y selector', (final tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildApp(
        AppPhoneInputCase(
          label: 'Telefono',
          controller: controller,
          enabled: false,
          onSelectorTap: () {},
        ),
      ),
    );

    final field = tester.getSemantics(find.byType(TextField));
    final selector = find.semantics.byLabel('Seleccionar prefijo telefónico, actual (ES)').evaluate().single;
    expect(field.flagsCollection.isEnabled, Tristate.isFalse);
    expect(selector.flagsCollection.isEnabled, Tristate.isFalse);
    expect(selector.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('asocia el error sin duplicar el texto visual', (final tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    const combinedLabel = 'Telefono, Introduce nueve dígitos';

    await tester.pumpWidget(
      buildApp(
        AppPhoneInputCase(
          label: 'Telefono',
          controller: controller,
          errorText: 'Introduce nueve dígitos',
        ),
      ),
    );

    final semantics = tester.getSemantics(find.byType(TextField));
    expect(semantics.label, startsWith(combinedLabel));
    expect(semantics.getSemanticsData().validationResult, SemanticsValidationResult.invalid);
    expect(find.semantics.byLabel('Introduce nueve dígitos'), findsNothing);
  });

  testWidgets('solo lectura permanece habilitado', (final tester) async {
    final controller = TextEditingController(text: '600000000');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildApp(
        AppPhoneInputCase(
          label: 'Telefono',
          controller: controller,
          readOnly: true,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Telefono').evaluate().single;
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.flagsCollection.isReadOnly, isTrue);
  });

  testWidgets('admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppPhoneInputCase(
            label: 'Numero de telefono para recibir notificaciones',
            controller: controller,
            helperText: 'Incluye un numero en el que podamos localizarte',
            onSelectorTap: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
