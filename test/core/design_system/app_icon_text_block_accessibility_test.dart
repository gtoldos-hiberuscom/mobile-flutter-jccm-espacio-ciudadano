import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_contact_content.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone el texto sin anunciar el icono decorativo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppIconTextBlock(
          text: 'Tienes disponibles varias guías de ayuda',
          icon: Icons.info,
        ),
      ),
    );

    expect(find.semantics.byLabel('Tienes disponibles varias guías de ayuda'), findsOneWidget);
    expect(find.semantics.byLabel(RegExp('info|información', caseSensitive: false)), findsNothing);
  });

  testWidgets('las partes en negrita no fragmentan la lectura', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppIconTextBlock(
          text: 'Atención disponible de lunes a viernes',
          boldParts: ['lunes a viernes'],
        ),
      ),
    );

    expect(find.semantics.byLabel('Atención disponible de lunes a viernes'), findsOneWidget);
    expect(find.semantics.byLabel('lunes a viernes'), findsNothing);
  });

  testWidgets('permite proporcionar una pronunciación accesible específica', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppIconTextBlock(
          text: 'Atención en el 012',
          semanticsLabel: 'Atención en el cero doce',
        ),
      ),
    );

    expect(find.semantics.byLabel('Atención en el cero doce'), findsOneWidget);
    expect(find.semantics.byLabel('Atención en el 012'), findsNothing);
  });

  testWidgets('no crea roles ni acciones interactivas', (final tester) async {
    await tester.pumpWidget(buildApp(const AppIconTextBlock(text: 'Información importante')));

    final data = find.semantics.byLabel('Información importante').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.actions, 0);
  });

  testWidgets('respeta texto al 200 por ciento en una pantalla de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppIconTextBlock(
            text: 'Si necesitas ayuda adicional tienes a tu disposición diferentes canales de atención ciudadana.',
            icon: Icons.help_outline,
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText).last);
    expect(richText.textScaler.scale(10), 20);
    expect(tester.takeException(), isNull);
  });
}
