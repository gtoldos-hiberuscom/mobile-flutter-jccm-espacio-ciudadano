import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/placeholder_controlled_card.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  const card = PlaceholderControlledCard(
    title: 'Citas previas',
    tooltip: 'Este servicio todavía no está disponible',
    badge: 'Próximamente',
    description: 'Podrá consultar sus próximas citas desde este apartado.',
  );

  testWidgets('expone el título como encabezado de nivel tres', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    final data = find.semantics.byLabel('Citas previas').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 3);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('la ayuda es un botón de 48 dp que muestra el tooltip', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    final node = find.semantics.byLabel('Este servicio todavía no está disponible').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(tester.getSize(find.byType(IconButton)), const Size(48, 48));

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(find.text('Este servicio todavía no está disponible'), findsOneWidget);
  });

  testWidgets('mantiene el estado y la descripción como información', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    for (final label in [
      'Próximamente',
      'Podrá consultar sus próximas citas desde este apartado.',
    ]) {
      final data = find.semantics.byLabel(label).evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
    }
  });

  testWidgets('permite una pronunciación alternativa del título', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const PlaceholderControlledCard(
          title: 'JCCM',
          titleSemanticLabel: 'Junta de Comunidades de Castilla-La Mancha',
          tooltip: 'Información del servicio',
          badge: 'Próximamente',
          description: 'Servicio pendiente de activación.',
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Junta de Comunidades de Castilla-La Mancha'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('JCCM'), findsNothing);
  });

  testWidgets('hace reflow al 200 por ciento sin truncar', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Consulta de prestaciones y servicios disponibles';
    const description = 'Próximamente podrá consultar toda la información asociada a este servicio.';
    await tester.pumpWidget(
      buildApp(
        const SingleChildScrollView(
          child: PlaceholderControlledCard(
            title: title,
            tooltip: 'Información adicional',
            badge: 'Próximamente',
            description: description,
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza todos los textos accesibles vacíos', (final tester) async {
    expect(
      () => PlaceholderControlledCard(
        title: '',
        tooltip: 'Ayuda',
        badge: 'Próximamente',
        description: 'Descripción',
      ),
      throwsAssertionError,
    );
    expect(
      () => PlaceholderControlledCard(
        title: 'Servicio',
        tooltip: '',
        badge: 'Próximamente',
        description: 'Descripción',
      ),
      throwsAssertionError,
    );
    expect(
      () => PlaceholderControlledCard(
        title: 'Servicio',
        tooltip: 'Ayuda',
        badge: '',
        description: 'Descripción',
      ),
      throwsAssertionError,
    );
    expect(
      () => PlaceholderControlledCard(
        title: 'Servicio',
        tooltip: 'Ayuda',
        badge: 'Próximamente',
        description: '',
      ),
      throwsAssertionError,
    );
  });
}
