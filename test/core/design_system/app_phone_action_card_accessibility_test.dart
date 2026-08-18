import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_contact_content.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone número y subtítulo como un botón de llamada', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppPhoneActionCard(
          number: '012',
          subtitle: 'Atención a la Ciudadanía',
          onTap: () => taps++,
        ),
      ),
    );

    final data = find.semantics.byLabel('Llamar al 012. Atención a la Ciudadanía').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isLink, isFalse);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hint, 'Inicia una llamada telefónica');
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('localiza el nombre y la pista en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppPhoneActionCard(number: '+34 925 26 60 50', subtitle: 'Citizen support', onTap: () {}),
        locale: const Locale('en'),
      ),
    );

    final data = find.semantics.byLabel('Call +34 925 26 60 50. Citizen support').evaluate().single.getSemanticsData();
    expect(data.hint, 'Starts a phone call');
  });

  testWidgets('permite personalizar la pronunciación del número y la pista', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppPhoneActionCard(
          number: '012',
          subtitle: 'Atención ciudadana',
          semanticLabel: 'Llamar al cero doce. Atención ciudadana',
          semanticHint: 'Abre el marcador del teléfono',
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Llamar al cero doce. Atención ciudadana').evaluate().single.getSemanticsData();
    expect(data.hint, 'Abre el marcador del teléfono');
  });

  testWidgets('no duplica el número, el subtítulo ni el icono', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppPhoneActionCard(number: '012', subtitle: 'Atención ciudadana', onTap: () {})),
    );

    expect(find.semantics.byLabel('012'), findsNothing);
    expect(find.semantics.byLabel('Atención ciudadana'), findsNothing);
    expect(find.semantics.byLabel(RegExp('call|teléfono', caseSensitive: false)), findsNothing);
  });

  testWidgets('admite texto al 200 por ciento en una pantalla de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppPhoneActionCard(
            number: '+34 925 26 60 50',
            subtitle: 'Llamar al servicio de Atención a la Ciudadanía de Castilla-La Mancha',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
