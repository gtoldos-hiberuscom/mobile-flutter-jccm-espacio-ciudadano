import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final AppNavBar appBar, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(appBar: appBar, body: const Text('Contenido')),
  );

  testWidgets('expone el título como H1 y localiza atrás', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavBar(
          type: AppNavBarType.level2,
          title: 'Property details',
          onBack: () {},
        ),
        locale: const Locale('en'),
      ),
    );

    final heading = find.semantics.byLabel('Property details').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('usa el mismo nombre de retroceso que Material en español', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavBar(
          type: AppNavBarType.level2,
          title: 'Información y ayuda',
          onBack: () {},
        ),
      ),
    );

    expect(find.byTooltip('Atrás'), findsOneWidget);
    expect(find.byTooltip('Volver'), findsNothing);
  });

  testWidgets('permite sobrescribir el color de fondo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavBar(
          type: AppNavBarType.level2,
          title: 'Mis registros',
          backgroundColor: Colors.white,
          onBack: () {},
        ),
      ),
    );

    expect(tester.widget<AppBar>(find.byType(AppBar)).backgroundColor, Colors.white);
  });

  testWidgets('localiza cerrar en la variante de detalle', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavBar(
          type: AppNavBarType.detail,
          title: 'Detalle',
          onClose: () {},
        ),
      ),
    );

    expect(find.byTooltip('Cerrar'), findsOneWidget);
  });

  testWidgets('notificaciones y perfil mantienen 48 por 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavBar(
          title: 'Inicio',
          isLoggedIn: true,
          onNotificationsTap: () {},
          onAvatarTap: () {},
          profileInitials: 'ML',
        ),
      ),
    );

    for (final tooltip in ['Notificaciones', 'Mi perfil']) {
      final control = find.ancestor(of: find.byTooltip(tooltip), matching: find.byType(IconButton));
      expect(tester.getSize(control).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(control).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('Inicio expone el nombre de aplicación y no inventa acción de ayuda', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(const AppNavBar(type: AppNavBarType.inicio)),
    );

    final heading = find.semantics.byLabel('Espacio Ciudadano').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);

    final help = tester.getSemantics(find.byTooltip('Ayuda')).getSemanticsData();
    expect(help.flagsCollection.isEnabled, Tristate.isFalse);
    expect(help.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('Inicio habilita ayuda cuando recibe una acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppNavBar(type: AppNavBarType.inicio, onHelpTap: () => taps++),
      ),
    );

    await tester.tap(find.byTooltip('Ayuda'));
    expect(taps, 1);
    expect(tester.getSize(find.byTooltip('Ayuda')).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(find.byTooltip('Ayuda')).height, greaterThanOrEqualTo(48));
  });

  testWidgets('un título breve admite texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        AppNavBar(type: AppNavBarType.level2, title: 'Datos', onBack: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text('Datos')).maxLines, 2);
    expect(tester.takeException(), isNull);
  });
}
