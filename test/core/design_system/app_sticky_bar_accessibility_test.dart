import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final AppStickyBar bar, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
    final double bottomPadding = 0,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: textScaler,
        padding: EdgeInsets.only(bottom: bottomPadding),
      ),
      child: child!,
    ),
    home: Scaffold(body: const Text('Contenido'), bottomNavigationBar: bar),
  );

  testWidgets('agrupa las acciones y localiza cancelar en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppStickyBar(
          type: AppStickyBarType.dicotomy,
          primaryLabel: 'Continue',
          onPrimary: () {},
          onSecondary: () {},
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.semantics.byLabel('Main actions'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('mantiene acciones independientes y en orden visual', (final tester) async {
    var primaryTaps = 0;
    var secondaryTaps = 0;
    await tester.pumpWidget(
      buildApp(
        AppStickyBar(
          primaryLabel: 'Guardar cambios',
          onPrimary: () => primaryTaps++,
          secondaryLabel: 'Descartar',
          onSecondary: () => secondaryTaps++,
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Descartar')).dx,
      lessThan(tester.getCenter(find.text('Guardar cambios')).dx),
    );
    await tester.tap(find.text('Descartar'));
    await tester.tap(find.text('Guardar cambios'));
    expect(secondaryTaps, 1);
    expect(primaryTaps, 1);
  });

  testWidgets('anuncia y deshabilita la acción principal durante la carga', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        AppStickyBar(
          primaryLabel: 'Guardar',
          onPrimary: () {},
          isPrimaryLoading: true,
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(AppButton)).getSemanticsData();
    expect(data.label, contains('Guardar'));
    expect(data.label, contains('Cargando'));
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('apila las acciones al 200 por ciento sin truncar', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const secondary = 'Volver y revisar la información';
    const primary = 'Confirmar y enviar la solicitud';
    await tester.pumpWidget(
      buildApp(
        AppStickyBar(
          primaryLabel: primary,
          onPrimary: () {},
          secondaryLabel: secondary,
          onSecondary: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(
      tester.getCenter(find.text(secondary)).dy,
      lessThan(tester.getCenter(find.text(primary)).dy),
    );
    expect(tester.widget<Text>(find.text(primary)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('respeta el área segura inferior', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppStickyBar(primaryLabel: 'Continuar', onPrimary: () {}),
        bottomPadding: 24,
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(of: find.byType(AppStickyBar), matching: find.byType(Container)).first,
    );
    expect(container.padding, const EdgeInsets.fromLTRB(16, 16, 16, 40));
  });
}
