import 'dart:ui' show SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hoja «Mis datos > Vivienda» de la auditoría de accesibilidad.
void main() {
  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  Widget buildApp({final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [ageDataAuthorizationProvider.overrideWith((final ref) async => true)],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const MyDataHousingPage(),
    ),
  );

  testWidgets('WCAG 4.1.2: las pestañas exponen rol, posición y selección', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final data = find.semantics.byLabel('Mis datos de Vivienda').evaluate().single;
    final services = find.semantics.byLabel('Información y servicios').evaluate().single;
    expect(data.getSemanticsData().role, SemanticsRole.tab);
    expect(data.parent!.getSemanticsData().role, SemanticsRole.tabBar);
    expect(data.getSemanticsData().flagsCollection.isSelected, Tristate.isTrue);
    expect(services.getSemanticsData().role, SemanticsRole.tab);
    expect(services.getSemanticsData().flagsCollection.isSelected, Tristate.isFalse);
    expect(data.getSemanticsData().value, contains('1'));
    expect(services.getSemanticsData().value, contains('2'));
  });

  testWidgets('WCAG 1.4.11 / 2.4.7: volver, pestañas y tarjetas muestran el anillo de foco', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    const expected = ['Atrás', 'Mis datos de Vivienda', 'Información y servicios', 'Bienes inmuebles', 'Domicilio en Castilla-La Mancha'];
    final visited = <String>{};
    for (var i = 0; i < 12 && visited.length < expected.length; i++) {
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

  testWidgets('WCAG 1.4.4: al 200 por ciento la cabecera y las pestañas dejan sitio al contenido', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();

    expect(find.byType(NestedScrollView), findsOneWidget);
    final outer = tester.state<NestedScrollViewState>(find.byType(NestedScrollView)).outerController;
    // Lo justo para retirar cabecera y pestañas (más el umbral del gesto).
    await tester.drag(find.text('Bienes inmuebles'), Offset(0, -(outer.position.maxScrollExtent + kDragSlopDefault)));
    await tester.pumpAndSettle();

    // Cabecera y pestañas fuera de la vista: toda la pantalla para leer.
    expect(find.byType(AppBar).hitTestable(), findsNothing);
    expect(find.byType(AppTopTabBar).hitTestable(), findsNothing);
    // El contenido empieza arriba del todo.
    expect(find.text('Bienes inmuebles').hitTestable(), findsOneWidget);
    expect(tester.getTopLeft(find.text('Bienes inmuebles')).dy, lessThan(AppDimensions.space64));
    expect(tester.takeException(), isNull);
  });
}
