import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/landing_access_step.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  const step = LandingAccessStepWidget(
    step: LandingAccessStep(
      stepNumber: 1,
      title: 'Identifícate',
      description: 'Accede mediante Cl@ve o certificado electrónico.',
    ),
  );

  testWidgets('anuncia número y título como encabezado de nivel tres', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(step));

    final data = find.semantics.byLabel('Paso 1: Identifícate').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 3);
    expect(data.flagsCollection.isButton, isFalse);
  });

  testWidgets('mantiene la descripción como información independiente', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(step));

    final data = find.semantics.byLabel('Accede mediante Cl@ve o certificado electrónico.').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isFalse);
    expect(data.flagsCollection.isButton, isFalse);
    expect(find.semantics.byLabel('1'), findsNothing);
  });

  testWidgets('localiza la etiqueta del paso en inglés', (final tester) async {
    await tester.pumpWidget(buildApp(step, locale: const Locale('en')));

    expect(find.semantics.byLabel('Step 1: Identifícate'), findsOneWidget);
    expect(find.semantics.byLabel('Paso 1: Identifícate'), findsNothing);
  });

  testWidgets('conserva el indicador numérico como decorativo', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(step));

    expect(find.text('1'), findsOneWidget);
    expect(find.semantics.byLabel('1'), findsNothing);
  });

  testWidgets('no trunca título ni descripción al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Identifícate de forma segura en el servicio';
    const description = 'Utiliza Cl@ve, certificado electrónico o cualquier otro método de identificación disponible.';
    await tester.pumpWidget(
      buildApp(
        const LandingAccessStepWidget(
          step: LandingAccessStep(
            stepNumber: 2,
            title: title,
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
}
