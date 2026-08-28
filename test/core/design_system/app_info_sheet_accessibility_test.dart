import 'dart:async' show unawaited;
import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_info_sheet.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  Widget opener({
    final String title = 'Información de vivienda',
    final String body = 'Los datos proceden del registro correspondiente.',
    final String? footer,
    final String? actionLabel,
    final VoidCallback? onAction,
    final String? semanticsLabel,
  }) => Builder(
    builder: (final context) => TextButton(
      onPressed: () => unawaited(
        AppInfoSheet.show(
          context: context,
          title: title,
          bodyText: body,
          footerText: footer,
          actionLabel: actionLabel,
          onActionPressed: onAction,
          semanticsLabel: semanticsLabel,
        ),
      ),
      child: const Text('Abrir información'),
    ),
  );

  testWidgets('hereda ruta modal y encabezado de nivel uno', (final tester) async {
    await tester.pumpWidget(buildApp(opener()));
    await tester.tap(find.text('Abrir información'));
    await tester.pumpAndSettle();

    final nodes = find.semantics.byLabel('Información de vivienda').evaluate();
    expect(nodes.first.flagsCollection.scopesRoute, isTrue);
    expect(nodes.first.flagsCollection.namesRoute, isTrue);
    expect(nodes.last.flagsCollection.isHeader, isTrue);
    expect(nodes.last.headingLevel, 1);
  });

  testWidgets('mantiene la acción como botón independiente', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(opener(actionLabel: 'Contactar', onAction: () => taps++)),
    );
    await tester.tap(find.text('Abrir información'));
    await tester.pumpAndSettle();

    final action = find.byType(AppButton);
    final data = tester.getSemantics(action).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    await tester.tap(find.text('Contactar'));
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre de la ruta', (final tester) async {
    await tester.pumpWidget(
      buildApp(opener(semanticsLabel: 'Ayuda sobre los datos de vivienda')),
    );
    await tester.tap(find.text('Abrir información'));
    await tester.pumpAndSettle();

    final route = find.semantics.byLabel('Ayuda sobre los datos de vivienda').evaluate().single;
    expect(route.flagsCollection.scopesRoute, isTrue);
  });

  testWidgets('usa un único scroll y crece al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 400);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        opener(
          title: 'Información adicional sobre los datos disponibles',
          body: 'Esta información procede de distintos registros administrativos y puede tardar en actualizarse.',
          footer: 'Contacta con el organismo responsable si detectas algún dato incorrecto.',
          actionLabel: 'Contactar con el organismo responsable',
          onAction: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.tap(find.text('Abrir información'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBottomSheet), matching: find.byType(SingleChildScrollView)),
      findsOneWidget,
    );
    expect(tester.getSize(find.byType(AppButton)).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });
}
