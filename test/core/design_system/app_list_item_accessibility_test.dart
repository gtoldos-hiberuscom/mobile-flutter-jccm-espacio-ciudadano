import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone título, subtítulo, rol, estado y una única acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppListItem(
          title: 'Preguntas frecuentes',
          subtitle: 'Consulta las respuestas',
          leading: const Icon(Icons.help_outline, semanticLabel: 'Ayuda'),
          trailing: const Icon(Icons.arrow_forward, semanticLabel: 'Flecha'),
          onTap: () => taps++,
        ),
      ),
    );

    final data = find.semantics.byLabel('Preguntas frecuentes. Consulta las respuestas').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Ayuda'), findsNothing);
    expect(find.semantics.byLabel('Flecha'), findsNothing);

    await tester.tap(find.byType(ListTile));
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre y la pista accesibles', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppListItem(
          title: 'EXP-123',
          semanticsLabel: 'Abrir expediente número 123',
          semanticsHint: 'Muestra su detalle',
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Abrir expediente número 123').evaluate().single.getSemanticsData();
    expect(data.hint, 'Muestra su detalle');
  });

  testWidgets('deshabilitado mantiene el rol y elimina la acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppListItem(
          title: 'Servicio temporalmente no disponible',
          isDisabled: true,
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Servicio temporalmente no disponible').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('informativo resume título y subtítulo sin rol de botón', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppListItem(
          title: 'Horario de atención',
          subtitle: 'De lunes a viernes',
          leading: Icon(Icons.schedule, semanticLabel: 'Horario'),
        ),
      ),
    );

    final data = find.semantics.byLabel('Horario de atención. De lunes a viernes').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
    expect(find.semantics.byLabel('Horario'), findsNothing);
  });

  testWidgets('garantiza un objetivo táctil mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppListItem(title: 'Abrir', onTap: () {})),
    );

    expect(tester.getSize(find.byType(ListTile)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('admite texto al 200 por ciento en una pantalla de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppListItem(
            title: 'Información completa sobre preguntas frecuentes y guías de ayuda',
            subtitle: 'Consulta todos los detalles disponibles antes de continuar',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
