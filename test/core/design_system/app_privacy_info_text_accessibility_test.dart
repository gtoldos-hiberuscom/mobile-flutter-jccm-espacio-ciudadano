import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_captcha_placeholder.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone nombre, rol de enlace, pista y una única acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppPrivacyInfoText(
          description: 'Más información en',
          linkText: 'Política de privacidad',
          onTap: () => taps++,
        ),
      ),
    );

    final data = find.semantics.byLabel('Más información en Política de privacidad').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('anuncia el enlace deshabilitado sin ofrecer una acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPrivacyInfoText(
          description: 'Más información en',
          linkText: 'Política de privacidad',
        ),
      ),
    );

    final data = find.semantics.byLabel('Más información en Política de privacidad').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('permite proporcionar un nombre accesible específico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppPrivacyInfoText(
          description: 'Consulta',
          linkText: 'https://example.org/privacy',
          semanticsLabel: 'Consulta la política de privacidad de la Junta',
          onTap: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Consulta la política de privacidad de la Junta'), findsOneWidget);
  });

  testWidgets('localiza la pista y el aviso visual en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppPrivacyInfoText(description: 'Read', linkText: 'Privacy policy', onTap: () {}),
        locale: const Locale('en'),
      ),
    );

    final data = find.semantics.byLabel('Read Privacy policy').evaluate().single.getSemanticsData();
    expect(data.hint, 'Opens in external browser');
    expect(find.text('External link · Opens outside the application'), findsOneWidget);
  });

  testWidgets('garantiza un área táctil mínima de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppPrivacyInfoText(description: 'Ver', linkText: 'Privacidad', onTap: () {})),
    );

    expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('admite texto al 200 por ciento en una pantalla de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppPrivacyInfoText(
            description: 'La información relativa a protección de datos está publicada en',
            linkText: 'la política de privacidad de Castilla-La Mancha',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.byWidgetPredicate(
        (final widget) => widget is RichText && widget.text.toPlainText().contains('la política de privacidad de Castilla-La Mancha'),
      ),
      findsOneWidget,
    );
  });
}
