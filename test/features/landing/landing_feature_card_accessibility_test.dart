import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/landing_feature_card.dart';

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

  const card = LandingFeatureCard(
    item: LandingFeatureItem(
      icon: 'notifications',
      title: 'Notificaciones',
      description: 'Consulta las comunicaciones enviadas por la Administración.',
    ),
  );

  testWidgets('expone el título como encabezado de nivel tres', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    final data = find.semantics.byLabel('Notificaciones').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 3);
    expect(data.flagsCollection.isButton, isFalse);
  });

  testWidgets('mantiene la descripción como información independiente', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    final data = find.semantics.byLabel('Consulta las comunicaciones enviadas por la Administración.').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isFalse);
    expect(data.flagsCollection.isButton, isFalse);
  });

  testWidgets('el icono es decorativo y no repite el título', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    expect(find.byType(Icon), findsOneWidget);
    expect(find.semantics.byLabel('Notificaciones'), findsOneWidget);
  });

  testWidgets('permite nivel y pronunciación alternativos', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const LandingFeatureCard(
          headingLevel: 2,
          titleSemanticLabel: 'Junta de Comunidades de Castilla-La Mancha',
          item: LandingFeatureItem(
            icon: 'assignment',
            title: 'JCCM',
            description: 'Servicios de la Administración regional.',
          ),
        ),
      ),
    );

    final data = find.semantics.byLabel('Junta de Comunidades de Castilla-La Mancha').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 2);
    expect(find.semantics.byLabel('JCCM'), findsNothing);
  });

  testWidgets('no trunca título ni descripción al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Notificaciones y comunicaciones administrativas';
    const description = 'Consulta todas las comunicaciones enviadas por los organismos de la Administración regional.';
    await tester.pumpWidget(
      buildApp(
        const LandingFeatureCard(
          item: LandingFeatureItem(
            icon: 'notifications',
            title: title,
            description: description,
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final titleText = tester.widget<Text>(find.text(title));
    final descriptionText = tester.widget<Text>(find.text(description));
    expect(titleText.maxLines, isNull);
    expect(titleText.overflow, isNot(TextOverflow.ellipsis));
    expect(descriptionText.maxLines, isNull);
    expect(descriptionText.overflow, isNot(TextOverflow.ellipsis));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza nivel y pronunciación vacía', (final tester) async {
    expect(
      () => LandingFeatureCard(item: card.item, headingLevel: 0),
      throwsAssertionError,
    );
    expect(
      () => LandingFeatureCard(item: card.item, titleSemanticLabel: ''),
      throwsAssertionError,
    );
  });
}
