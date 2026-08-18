import 'dart:ui' show SemanticsAction, SemanticsValidationResult, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone nombre, rol, obligatoriedad y acciones de edicion', (final tester) async {
    final controller = TextEditingController(text: 'usuario@ejemplo.es');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildApp(
        AppInputCase(
          label: 'Correo electronico',
          controller: controller,
          isRequired: true,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();

    final semantics = find.semantics.byLabel('Correo electronico').evaluate().single;
    expect(semantics.flagsCollection.isTextField, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.flagsCollection.isRequired, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.setText), isTrue);
  });

  testWidgets('readOnly permanece habilitado y anuncia solo lectura', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInputCase(
          label: 'Numero de expediente',
          readOnly: true,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Numero de expediente').evaluate().single;
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.flagsCollection.isReadOnly, isTrue);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  });

  testWidgets('asocia el error y evita un segundo anuncio visual', (final tester) async {
    const combinedLabel = 'Correo electronico, Introduce un correo valido';

    await tester.pumpWidget(
      buildApp(
        const AppInputCase(
          label: 'Correo electronico',
          state: AppInputState.error,
          errorText: 'Introduce un correo valido',
        ),
      ),
    );

    final semantics = find.semantics.byLabel(combinedLabel).evaluate().single;
    expect(semantics.getSemanticsData().validationResult, SemanticsValidationResult.invalid);
    expect(find.semantics.byLabel('Introduce un correo valido'), findsNothing);
  });

  testWidgets('no expone el valor de una contrasena', (final tester) async {
    final controller = TextEditingController(text: 'secreto');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildApp(
        AppInputCase(
          label: 'Contrasena',
          controller: controller,
          obscureText: true,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Contrasena').evaluate().single;
    expect(semantics.flagsCollection.isObscured, isTrue);
    expect(semantics.value, isNot(contains('secreto')));
  });

  testWidgets('propaga la configuracion de entrada', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInputCase(
          label: 'Correo electronico',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: [AutofillHints.email],
          autocorrect: false,
          enableSuggestions: false,
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.keyboardType, TextInputType.emailAddress);
    expect(field.textInputAction, TextInputAction.next);
    expect(field.autofillHints, [AutofillHints.email]);
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
          const AppInputCase(
            label: 'Direccion de correo electronico para notificaciones',
            hint: 'nombre.apellidos@ejemplo.es',
            helperText: 'Utilizaremos esta direccion para mantenerte informado',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
