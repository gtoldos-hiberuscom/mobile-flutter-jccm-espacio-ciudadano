import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_drawer_menu.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
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

  AppDrawerMenu fullMenu() => AppDrawerMenu(
    userName: 'María López',
    nif: '12345678Z',
    primaryItems: [
      AppDrawerMenuItem(label: 'Preferencias', icon: Icons.settings, onTap: () {}),
      AppDrawerMenuItem(label: 'Mis carnets digitales', icon: Icons.badge, onTap: () {}),
    ],
    secondaryLinks: [
      AppDrawerLinkItem(label: 'Ayuda y contacto', icon: Icons.help_outline, onTap: () {}),
      AppDrawerLinkItem(label: 'Accesibilidad', icon: Icons.accessibility_new, onTap: () {}),
      AppDrawerLinkItem(label: 'Aviso legal', onTap: () {}),
      AppDrawerLinkItem(label: 'Protección de datos', onTap: () {}),
    ],
    onLogout: () {},
    onClose: () {},
    actionButtonLabel: 'Ir a Sede Electrónica',
    onActionButton: () {},
  );

  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  testWidgets('WCAG 2.4.3: el tabulador recorre cada control una sola vez y sin paradas vacías', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildApp(fullMenu()));
    await tester.pumpAndSettle();

    const expected = [
      'Cerrar menú',
      'Preferencias',
      'Mis carnets digitales',
      'Cerrar sesión',
      'Ayuda y contacto',
      'Accesibilidad',
      'Aviso legal',
      'Protección de datos',
      'Ir a Sede Electrónica',
    ];
    final visited = <String>[];
    // «Cerrar» recibe el foco inicial; desde ahí se avanza con el tabulador.
    for (var i = 0; i < expected.length; i++) {
      if (i > 0) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
      }
      final focused = primaryFocus!.context!;
      final label = expected.firstWhere(
        (final text) => find.descendant(of: find.byWidget(focused.widget), matching: find.textContaining(text)).evaluate().isNotEmpty,
        orElse: () => '<sin nombre>',
      );
      visited.add(label);
      // WCAG 2.4.7 / 1.4.11: cada parada muestra el anillo de foco.
      expect(
        find.ancestor(of: find.byWidget(focused.widget), matching: ring()),
        findsOneWidget,
        reason: label,
      );
    }
    expect(visited, expected);
  });

  testWidgets('WCAG 1.4.3: el texto blanco no pierde contraste al recibir el foco', (final tester) async {
    await tester.pumpWidget(buildApp(fullMenu()));
    await tester.pumpAndSettle();

    for (final inkWell in tester.widgetList<InkWell>(find.byType(InkWell))) {
      expect(inkWell.focusColor, Colors.transparent);
      expect(inkWell.hoverColor, Colors.transparent);
    }
    // Blanco sobre el fondo del menú: 4,5:1 como mínimo.
    final white = AppColors.textWhite.computeLuminance();
    final background = AppColors.secondary.computeLuminance();
    expect((white + 0.05) / (background + 0.05), greaterThanOrEqualTo(4.5));
  });

  testWidgets('la sede electrónica se anuncia como enlace externo', (final tester) async {
    await tester.pumpWidget(buildApp(fullMenu()));
    await tester.pumpAndSettle();

    final data = find.semantics.byLabel('Ir a Sede Electrónica').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('con pantalla táctil el foco inicial en «Cerrar» no pinta el anillo', (final tester) async {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTouch;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional);
    await tester.pumpWidget(buildApp(fullMenu()));
    await tester.pumpAndSettle();

    expect(primaryFocus?.context, isNotNull);
    expect(ring(), findsNothing);
  });
}
