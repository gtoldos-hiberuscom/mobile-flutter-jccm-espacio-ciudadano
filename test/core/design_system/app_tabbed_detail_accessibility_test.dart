import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Pantallas de detalle de Mis datos (Salud, Empleo, Educación…): cabecera,
/// pestañas superiores, control segmentado y enlaces externos.
void main() {
  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  Widget buildApp({final TextScaler textScaler = TextScaler.noScaling}) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: AppTabbedDetailScaffold(
      title: 'Salud',
      onBack: () {},
      onInfo: () {},
      tabs: const ['Mis datos de salud', 'Información y servicios'],
      selectedIndex: 0,
      onTabSelected: (_) {},
      tabViews: [
        SingleChildScrollView(
          child: Column(
            children: [
              AppSegmentedControl(segments: const ['Pendientes', 'Pasadas'], selectedIndex: 0, onSelected: (_) {}),
              AppExternalLinkSection(
                title: 'Enlaces de interés',
                links: [AppExternalLinkItem(label: 'Servicio de Salud', onTap: () {})],
              ),
              const SizedBox(height: 2000),
            ],
          ),
        ),
        const SizedBox.shrink(),
      ],
    ),
  );

  testWidgets('WCAG 1.4.11 / 2.4.7: volver, información, pestaña, segmento y enlace muestran el anillo', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Recorrido con el tabulador: cada parada muestra un anillo, y el
    // recorrido pasa por los cinco controles de la pantalla.
    const expected = ['Atrás', 'Información', 'Mis datos de salud', 'Información y servicios', 'Pendientes', 'Pasadas', 'Servicio de Salud'];
    final visited = <String>{};
    for (var i = 0; i < 15 && visited.length < expected.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      final focusedFinder = find.byWidget(focused.widget);
      for (final name in expected) {
        final byText = find.descendant(of: focusedFinder, matching: find.text(name));
        final byTooltip = find.ancestor(of: focusedFinder, matching: find.byTooltip(name));
        if (byText.evaluate().isNotEmpty || byTooltip.evaluate().isNotEmpty) {
          visited.add(name);
          expect(
            find.ancestor(of: focusedFinder, matching: ring()),
            findsOneWidget,
            reason: name,
          );
        }
      }
    }
    expect(visited, expected.toSet());
  });

  testWidgets('WCAG 1.4.4: al 200 por ciento la cabecera crece y las pestañas se desplazan con el contenido', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();

    // La barra crece lo justo para el título entero.
    final barRect = tester.getRect(find.byType(AppBar));
    final titleRect = tester.getRect(find.descendant(of: find.byType(AppBar), matching: find.text('Salud')));
    expect(barRect.height, greaterThan(64));
    expect(titleRect.bottom, lessThanOrEqualTo(barRect.bottom));
    expect(find.byType(NestedScrollView), findsOneWidget);
    final tabTop = tester.getTopLeft(find.byType(AppTopTabBar)).dy;

    await tester.drag(find.text('Pendientes'), const Offset(0, -40));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(AppTopTabBar)).dy, lessThan(tabTop));
    expect(tester.takeException(), isNull);
  });

  testWidgets('WCAG 1.4.4: al 200 por ciento la cabecera también se desplaza y reaparece al volver', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();

    final barTop = tester.getTopLeft(find.byType(AppBar)).dy;
    final barHeight = tester.getSize(find.byType(AppBar)).height;
    await tester.drag(find.text('Pendientes'), Offset(0, -(barHeight + 200)));
    await tester.pumpAndSettle();
    // Fuera de la vista: todo el alto queda para el contenido.
    expect(find.byType(AppBar).hitTestable(), findsNothing);

    // Arrastre con fotogramas intermedios, como el de un dedo real: la
    // cabecera flotante decide aparecer según el sentido del desplazamiento.
    await tester.timedDrag(find.text('Servicio de Salud'), const Offset(0, 120), const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    // Vuelve al desplazar hacia arriba, con el botón de volver a mano.
    expect(find.byTooltip('Atrás').hitTestable(), findsOneWidget);
    expect(tester.getTopLeft(find.byType(AppBar)).dy, barTop);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sin ampliación las pestañas siguen fijas', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.byType(NestedScrollView), findsNothing);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).appBar, isA<AppHeaderBar>());
  });

  testWidgets('WCAG 1.4.4: un título largo al 200 por ciento ocupa las líneas que necesite sin recortarse', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 740);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    const title = 'Atención a la dependencia';
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (final context, final child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: AppDetailScaffold(title: title, onBack: () {}, onInfo: () {}, body: const SizedBox.shrink()),
      ),
    );
    await tester.pumpAndSettle();

    final titleText = find.descendant(of: find.byType(AppBar), matching: find.text(title));
    final titleRect = tester.getRect(titleText);
    final barRect = tester.getRect(find.byType(AppBar));
    const lineHeight = 20 * (28 / 20) * 2;
    // Necesita más de dos líneas y todas quedan dentro de la barra.
    expect(titleRect.height, greaterThan(lineHeight * 2));
    expect(titleRect.top, greaterThanOrEqualTo(barRect.top));
    expect(titleRect.bottom, lessThanOrEqualTo(barRect.bottom));
    expect(tester.widget<Text>(titleText).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  test('sin ampliación la cabecera conserva los 64 dp de diseño', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    expect(AppHeaderBar(title: 'Atención a la dependencia', onBack: () {}, onInfo: () {}).preferredSize.height, 64);
  });
}
