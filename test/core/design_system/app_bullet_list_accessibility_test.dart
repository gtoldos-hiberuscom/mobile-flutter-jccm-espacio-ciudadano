import 'dart:ui' show SemanticsAction, SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bullet_list.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('expone un rol de lista y un nodo por elemento', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppBulletList(
          items: [
            'Consulta tus notificaciones',
            'Revisa tus próximas citas',
            'Comprueba tus acreditaciones',
          ],
        ),
      ),
    );

    final list = find.byWidgetPredicate(
      (final widget) => widget is Semantics && widget.properties.role == SemanticsRole.list,
    );
    expect(list, findsOneWidget);

    for (final label in [
      'Consulta tus notificaciones',
      'Revisa tus próximas citas',
      'Comprueba tus acreditaciones',
    ]) {
      final item = find.semantics.byLabel(label).evaluate().single.getSemanticsData();
      expect(item.role, SemanticsRole.listItem);
      expect(item.hasAction(SemanticsAction.tap), isFalse);
    }
  });

  testWidgets('admite un nombre para contextualizar la lista', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppBulletList(
          semanticsLabel: 'Servicios disponibles',
          items: ['Notificaciones', 'Agenda'],
        ),
      ),
    );

    final list = find.semantics.byLabel('Servicios disponibles').evaluate().single.getSemanticsData();
    expect(list.role, SemanticsRole.list);
  });

  testWidgets('permite una etiqueta accesible distinta en un elemento suelto', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppBulletItem(
          text: 'RGPD',
          semanticsLabel: 'Reglamento General de Protección de Datos',
        ),
      ),
    );

    final item = find.semantics.byLabel('Reglamento General de Protección de Datos').evaluate().single.getSemanticsData();
    expect(item.role, SemanticsRole.none);
    expect(find.semantics.byLabel('RGPD'), findsNothing);
  });

  testWidgets('no expone las dos viñetas decorativas', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppBulletList(items: ['Información personal'])),
    );

    expect(find.semantics.byLabel('Información personal'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppBulletItem),
        matching: find.byType(Semantics),
      ),
      findsOneWidget,
    );
  });

  testWidgets('admite textos largos al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const SingleChildScrollView(
            child: AppBulletList(
              items: [
                'Consulta toda tu información personal y administrativa disponible.',
                'Revisa las próximas citas y los avisos importantes de tu agenda.',
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
