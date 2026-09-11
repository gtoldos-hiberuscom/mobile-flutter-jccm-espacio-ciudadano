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

  testWidgets('expone un enlace externo con nombre, pista, estado y una acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppContactActionCard(
          title: 'Guías de ayuda',
          subtitle: 'Ir al portal web JCCM',
          onTap: () => taps++,
        ),
      ),
    );

    final data = find.semantics.byLabel('Guías de ayuda. Ir al portal web JCCM').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('permite usar la tarjeta como botón sin mezclar roles', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppContactActionCard(
          title: 'Abrir formulario',
          subtitle: 'Soporte técnico',
          isExternalLink: false,
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Abrir formulario. Soporte técnico').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isLink, isFalse);
    expect(data.hint, isEmpty);
  });

  testWidgets('permite personalizar nombre y pista', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppContactActionCard(
          title: '012',
          subtitle: 'Atención ciudadana',
          semanticLabel: 'Llamar al cero doce',
          semanticHint: 'Inicia una llamada',
          isExternalLink: false,
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Llamar al cero doce').evaluate().single.getSemanticsData();
    expect(data.hint, 'Inicia una llamada');
  });

  testWidgets('localiza la pista externa en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppContactActionCard(title: 'Help guides', subtitle: 'Open JCCM website', onTap: () {}),
        locale: const Locale('en'),
      ),
    );

    final data = find.semantics.byLabel('Help guides. Open JCCM website').evaluate().single.getSemanticsData();
    expect(data.hint, 'Opens in external browser');
  });

  testWidgets('excluye el icono y los textos visuales duplicados', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppContactActionCard(title: 'Oficinas', subtitle: 'Consultar listado', onTap: () {}),
      ),
    );

    expect(find.semantics.byLabel('Oficinas'), findsNothing);
    expect(find.semantics.byLabel('Consultar listado'), findsNothing);
  });

  testWidgets('expone el listado de oficinas como enlace y no como botón', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppContactActionCard(
          title: 'Listado de oficinas de información y registro',
          subtitle: 'Ir al portal web JCCM',
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Listado de oficinas de información y registro. Ir al portal web JCCM').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('mantiene 48 dp y admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppContactActionCard(
            title: 'Listado de oficinas de información y registro',
            subtitle: 'Consultar todas las oficinas disponibles en el portal web',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });
}
