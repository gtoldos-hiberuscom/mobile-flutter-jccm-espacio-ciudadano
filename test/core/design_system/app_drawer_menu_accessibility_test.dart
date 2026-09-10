import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_drawer_menu.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
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
    home: Scaffold(body: child),
  );

  AppDrawerMenu menu({
    final VoidCallback? onPrimary,
    final VoidCallback? onSecondary,
    final VoidCallback? onLogout,
  }) => AppDrawerMenu(
    userName: 'María López',
    nif: '12345678Z',
    primaryItems: [
      AppDrawerMenuItem(
        label: 'Mis preferencias personales',
        icon: Icons.settings,
        onTap: onPrimary,
      ),
    ],
    secondaryLinks: [
      AppDrawerLinkItem(label: 'Ayuda y contacto', onTap: onSecondary),
    ],
    onLogout: onLogout,
    actionButtonLabel: 'Ir a la Sede Electrónica',
  );

  for (final height in [568.0, 844.0]) {
    for (final bottomInset in [0.0, 34.0]) {
      testWidgets('fija la sede a 12 dp de la zona segura: $height / $bottomInset', (final tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(320, height);
        tester.view.viewPadding = FakeViewPadding(bottom: bottomInset);
        tester.view.padding = FakeViewPadding(bottom: bottomInset);
        addTearDown(tester.view.reset);

        await tester.pumpWidget(buildApp(menu(onLogout: () {})));
        final button = find.ancestor(
          of: find.text('Ir a la Sede Electrónica'),
          matching: find.byType(InkWell),
        );
        expect(tester.getBottomRight(button).dy, height - bottomInset - 12);
        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
        await tester.pumpAndSettle();
        expect(tester.getBottomRight(button).dy, height - bottomInset - 12);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('expone el menú como ruta semántica localizada', (final tester) async {
    await tester.pumpWidget(buildApp(menu()));

    final route = find.semantics.byLabel('Menú de navegación').evaluate().single;
    expect(route.flagsCollection.scopesRoute, isTrue);
    expect(route.flagsCollection.namesRoute, isTrue);
    expect(find.semantics.byLabel('Cerrar menú'), findsOneWidget);
  });

  testWidgets('cada opción es un único botón con su estado habilitado', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(buildApp(menu(onPrimary: () => taps++)));

    final enabled = find.semantics.byLabel('Mis preferencias personales').evaluate().single;
    expect(enabled.flagsCollection.isButton, isTrue);
    expect(enabled.flagsCollection.isEnabled, Tristate.isTrue);
    expect(enabled.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.text('Mis preferencias personales'));
    expect(taps, 1);

    final disabled = find.semantics.byLabel('Ayuda y contacto').evaluate().single;
    expect(disabled.flagsCollection.isButton, isTrue);
    expect(disabled.flagsCollection.isEnabled, Tristate.isFalse);
    expect(disabled.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('cada enlace secundario produce una sola parada de foco con nombre', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(menu(onSecondary: () => taps++)),
    );

    final matches = find.semantics.byLabel('Ayuda y contacto').evaluate();
    expect(matches, hasLength(1));
    final data = matches.single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.text('Ayuda y contacto'));
    expect(taps, 1);
  });

  testWidgets('localiza el saludo y el cierre de sesión en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(menu(onLogout: () {}), locale: const Locale('en')),
    );

    expect(find.text('Hello, María López'), findsOneWidget);
    expect(find.semantics.byLabel('Sign out'), findsOneWidget);
    expect(find.semantics.byLabel('Close menu'), findsOneWidget);
  });

  testWidgets('mantiene áreas interactivas de al menos 48 dp', (final tester) async {
    await tester.pumpWidget(buildApp(menu(onPrimary: () {})));

    expect(tester.getSize(find.text('Cerrar menú').first).height, lessThan(48));
    final closeTarget = find
        .ancestor(
          of: find.text('Cerrar menú').first,
          matching: find.byType(ConstrainedBox),
        )
        .first;
    expect(tester.getSize(closeTarget).height, greaterThanOrEqualTo(48));

    final primaryTarget = find
        .ancestor(
          of: find.text('Mis preferencias personales'),
          matching: find.byType(ConstrainedBox),
        )
        .first;
    expect(tester.getSize(primaryTarget).height, greaterThanOrEqualTo(48));
  });

  testWidgets('no trunca contenido a 320 dp con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        menu(onPrimary: () {}, onLogout: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text('Mis preferencias personales')).maxLines, isNull);
    expect(tester.widget<Text>(find.text('Ir a la Sede Electrónica')).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
