import 'dart:ui' show CheckedState, SemanticsAction, SemanticsValidationResult;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_captcha_check.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone nombre, estado y una única acción', (final tester) async {
    bool? changed;
    await tester.pumpWidget(
      buildApp(
        AppCaptchaCheck(
          label: 'No soy un robot',
          badgeLabel: 'Mock',
          value: false,
          onChanged: (final value) => changed = value,
        ),
      ),
    );

    final captcha = find.semantics.byLabel('No soy un robot, verificación Mock');
    final data = captcha.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isChecked, CheckedState.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Mock'), findsNothing);
    tester.semantics.tap(captcha);
    expect(changed, isTrue);
  });

  testWidgets('anuncia el estado marcado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCaptchaCheck(
          label: 'No soy un robot',
          badgeLabel: 'Mock',
          value: true,
          onChanged: (_) {},
        ),
      ),
    );

    final data = find.semantics.byLabel('No soy un robot, verificación Mock').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isChecked, CheckedState.isTrue);
  });

  testWidgets('asocia y anuncia el error dinámico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCaptchaCheck(
          label: 'No soy un robot',
          badgeLabel: 'Mock',
          value: false,
          errorText: 'Confirma que no eres un robot',
          onChanged: (_) {},
        ),
      ),
    );

    final control = find.semantics.byLabel('No soy un robot, verificación Mock, Confirma que no eres un robot').evaluate().single.getSemanticsData();
    expect(control.validationResult, SemanticsValidationResult.invalid);
    final error = find.semantics.byLabel('Error, No soy un robot: Confirma que no eres un robot').evaluate().single;
    expect(error.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('permite una etiqueta accesible específica', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCaptchaCheck(
          label: 'No soy un robot',
          badgeLabel: 'Mock',
          semanticsLabel: 'Verificación humana de prueba',
          value: false,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Verificación humana de prueba'), findsOneWidget);
  });

  testWidgets('localiza la composición accesible en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCaptchaCheck(
          label: 'I am not a robot',
          badgeLabel: 'Mock',
          value: false,
          onChanged: (_) {},
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.semantics.byLabel('I am not a robot, Mock verification'), findsOneWidget);
  });

  testWidgets('apila la insignia con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppCaptchaCheck(
            label: 'Confirmo que soy una persona y no un sistema automatizado',
            badgeLabel: 'Mock',
            value: false,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Confirmo que soy una persona y no un sistema automatizado')).dy,
      lessThan(tester.getCenter(find.text('MOCK')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
