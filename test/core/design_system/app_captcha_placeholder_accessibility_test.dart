import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_captcha_placeholder.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone el estado pendiente como información no interactiva', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppCaptchaPlaceholder(label: 'Esperando verificación captcha')),
    );

    final status = find.semantics.byLabel('Esperando verificación captcha').evaluate().single.getSemanticsData();
    expect(status.hasAction(SemanticsAction.tap), isFalse);
    expect(find.semantics.byLabel('Captcha verificado'), findsNothing);
  });

  testWidgets('anuncia el estado verificado con texto localizado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppCaptchaPlaceholder(
          label: 'Esperando verificación captcha',
          isVerified: true,
        ),
      ),
    );

    final status = find.semantics.byLabel('Captcha verificado').evaluate().single;
    expect(status.flagsCollection.isLiveRegion, isTrue);
    expect(find.text('Captcha verificado'), findsOneWidget);
  });

  testWidgets('localiza el estado verificado en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppCaptchaPlaceholder(label: 'Waiting', isVerified: true),
        locale: const Locale('en'),
      ),
    );

    expect(find.semantics.byLabel('Captcha verified'), findsOneWidget);
    expect(find.text('Captcha verified'), findsOneWidget);
  });

  testWidgets('asocia el error y evita anunciar dos veces su texto visual', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppCaptchaPlaceholder(
          label: 'Captcha',
          errorText: 'No se ha podido completar la verificación',
        ),
      ),
    );

    final error = find.semantics.byLabel('Error, Captcha: No se ha podido completar la verificación').evaluate().single;
    expect(error.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('No se ha podido completar la verificación'), findsNothing);
  });

  testWidgets('permite personalizar etiqueta y desactivar el anuncio', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppCaptchaPlaceholder(
          label: 'Captcha',
          isVerified: true,
          semanticsLabel: 'Verificación humana completada',
          announceChanges: false,
        ),
      ),
    );

    final status = find.semantics.byLabel('Verificación humana completada').evaluate().single;
    expect(status.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('crece verticalmente con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppCaptchaPlaceholder(
            label: 'El sistema está esperando que finalice la verificación de seguridad',
            isVerified: true,
            verifiedLabel: 'La verificación de seguridad se ha completado correctamente',
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(DecoratedBox).first).height, greaterThanOrEqualTo(104));
    expect(tester.takeException(), isNull);
  });
}
