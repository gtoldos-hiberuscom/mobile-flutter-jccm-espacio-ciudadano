import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_list.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone estructura de lista y elementos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppList(
          semanticsLabel: 'Datos de contacto',
          children: [Text('Teléfono'), Text('Correo electrónico')],
        ),
      ),
    );

    final list = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .firstWhere(
          (final widget) => widget.properties.role == SemanticsRole.list,
        );
    expect(list.properties.label, 'Datos de contacto');
    final items = tester.widgetList<Semantics>(find.byType(Semantics)).where((final widget) => widget.properties.role == SemanticsRole.listItem);
    expect(items, hasLength(2));
  });

  testWidgets('marca el título como encabezado configurable', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppList(
          title: 'Búsquedas recientes',
          headingLevel: 3,
          children: [Text('Primera búsqueda')],
        ),
      ),
    );

    final heading = find.semantics.byLabel('Búsquedas recientes').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 3);
  });

  testWidgets('conserva las acciones propias de cada elemento', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppList(
          children: [
            TextButton(onPressed: () => taps++, child: const Text('Abrir detalle')),
          ],
        ),
      ),
    );

    final action = find.semantics.byLabel('Abrir detalle');
    expect(action.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(action);
    expect(taps, 1);
  });

  testWidgets('los divisores quedan excluidos del árbol semántico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppList(children: [Text('Uno'), Text('Dos')]),
      ),
    );

    expect(find.byType(Divider), findsOneWidget);
    expect(
      find.ancestor(of: find.byType(Divider), matching: find.byType(ExcludeSemantics)),
      findsOneWidget,
    );
  });

  testWidgets('no trunca a 320 dp con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Opciones disponibles para recibir comunicaciones';
    const item = 'Notificaciones administrativas por correo electrónico';
    await tester.pumpWidget(
      buildApp(
        const AppList(title: title, children: [Text(item)]),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(item)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
