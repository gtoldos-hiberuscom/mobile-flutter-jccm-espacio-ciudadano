import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_expedientes_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hoja «Gestión > Mis expedientes» de la auditoría de accesibilidad.
void main() {
  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  final expedientes = [
    for (var i = 1; i <= 8; i++)
      Expediente(
        numexp: 'EXP-$i',
        titulo: 'Expediente de prueba $i',
        consejeria: 'Consejería',
        // Uno sin oficina: no debe dejar etiqueta vacía.
        oficinaTramitadora: i == 1 ? null : 'Oficina $i',
        fechaInicio: '2026-01-0${i % 9 + 1}',
        estado: 'EN TRAMITE',
      ),
  ];

  Widget buildApp() => ProviderScope(
    overrides: [expedientesProvider.overrideWith((final ref) async => expedientes)],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GestionExpedientesPage(),
    ),
  );

  testWidgets('WCAG 2.1.1 / 2.4.7 / 1.4.11: el tabulador recorre volver, buscar y todos los expedientes, los trae a la vista y los marca', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final names = ['Atrás', 'Buscar expedientes', for (var i = 1; i <= 8; i++) 'Expediente de prueba $i'];
    final visited = <String>{};
    for (var i = 0; i < 30 && visited.length < names.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      final focusedFinder = find.byWidget(focused.widget);
      for (final name in names) {
        final byText = find.descendant(of: focusedFinder, matching: find.text(name));
        final byTooltip = find.ancestor(of: focusedFinder, matching: find.byTooltip(name));
        if (byText.evaluate().isNotEmpty || byTooltip.evaluate().isNotEmpty) {
          visited.add(name);
          expect(
            find.ancestor(of: focusedFinder, matching: ring()),
            findsOneWidget,
            reason: name,
          );
          if (byText.evaluate().isNotEmpty) {
            final rect = tester.getRect(byText);
            expect(rect.top, greaterThanOrEqualTo(0), reason: name);
            expect(rect.bottom, lessThanOrEqualTo(667), reason: name);
          }
        }
      }
    }
    expect(visited, names.toSet());
  });

  testWidgets('WCAG 2.4.3: cada expediente es un único nodo y no hay nodos vacíos enfocables', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final card = find.semantics.byLabel(RegExp('Expediente de prueba 1')).evaluate().single;
    final data = card.getSemanticsData();
    expect(data.label, startsWith('Expediente de prueba 1'));
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isFocused, isNot(Tristate.none));
    expect(card.childrenCount, 0);

    final emptyInteractive = find.semantics.byPredicate((final node) {
      final d = node.getSemanticsData();
      return d.label.isEmpty && d.tooltip.isEmpty && (d.flagsCollection.isFocused != Tristate.none || d.hasAction(SemanticsAction.tap));
    });
    expect(emptyInteractive, findsNothing);
  });

  testWidgets('sin oficina tramitadora no se pinta una etiqueta vacía', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.text(''), findsNothing);
  });
}
