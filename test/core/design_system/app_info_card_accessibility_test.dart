import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_info_card.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextDirection direction = TextDirection.ltr,
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Directionality(textDirection: direction, child: child!),
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('una tarjeta informativa no se anuncia como botón', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppInfoCard(child: Text('Información del expediente'))),
    );

    final data = find.semantics.byLabel('Información del expediente').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('permite nombrar el grupo sin ocultar controles internos', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppInfoCard(
          semanticLabel: 'Datos del vehículo',
          child: Column(
            children: [
              const Text('Matrícula 1234 ABC'),
              TextButton(onPressed: () => taps++, child: const Text('Ver detalle')),
            ],
          ),
        ),
      ),
    );

    expect(find.semantics.byLabel('Datos del vehículo'), findsOneWidget);
    expect(find.semantics.byLabel('Matrícula 1234 ABC'), findsOneWidget);
    final action = find.semantics.byLabel('Ver detalle');
    expect(action.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(action);
    expect(taps, 1);
  });

  testWidgets('sitúa el borde destacado en el inicio también en RTL', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInfoCard(child: Text('Contenido')),
        direction: TextDirection.rtl,
      ),
    );

    final decoration = tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration as BoxDecoration;
    final border = decoration.border! as BorderDirectional;
    expect(border.start.width, 8);
    expect(border.start.color, AppColors.borderBlueMutedLight);
    expect(border.end.width, 1);
  });

  testWidgets('admite texto al 200 por ciento en 320 dp sin truncarlo', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const content = 'Información detallada sobre el estado actual de la solicitud presentada.';
    await tester.pumpWidget(
      buildApp(
        const AppInfoCard(child: Text(content)),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(content)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
