import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('unifica severidad, título y mensaje', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertContextual(
          severity: AppAlertSeverity.error,
          title: 'Dato incorrecto',
          message: 'Revisa el número de expediente',
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Dato incorrecto: Revisa el número de expediente').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isFalse);
    expect(find.byType(AppIcon), findsOneWidget);
  });

  testWidgets('usa un título localizado según la severidad', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertContextual(
          severity: AppAlertSeverity.success,
          message: 'Los datos se han guardado',
        ),
      ),
    );

    expect(find.semantics.byLabel('Operación correcta: Los datos se han guardado'), findsOneWidget);
  });

  testWidgets('permite activar live region para contenido dinámico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertContextual(
          message: 'La información se ha actualizado',
          announce: true,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Aviso del sistema: La información se ha actualizado').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('mantiene la acción como control independiente', (final tester) async {
    var presses = 0;
    await tester.pumpWidget(
      buildApp(
        AppAlertContextual(
          message: 'Faltan datos',
          action: AppButton(label: 'Completar datos', onPressed: () => presses++),
        ),
      ),
    );

    final action = find.semantics.byLabel('Completar datos');
    expect(action.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(action);
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('completa el mensaje con un enlace en línea accesible', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppAlertContextual(
          message: 'Si no puedes acceder, contacta con',
          messageLink: AppAlertMessageLink(text: 'soporte técnico', onTap: () => taps++),
        ),
      ),
    );

    expect(find.semantics.byLabel('Aviso del sistema: Si no puedes acceder, contacta con soporte técnico.'), findsOneWidget);

    final link = find.semantics.byLabel('soporte técnico');
    final data = link.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(link);
    await tester.pump();
    expect(taps, 1);

    await tester.tap(find.text('soporte técnico'));
    await tester.pump();
    expect(taps, 2);
  });

  testWidgets('permite personalizar la etiqueta accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertContextual(
          message: 'Texto visual',
          semanticsLabel: 'Ayuda para completar el formulario',
        ),
      ),
    );

    expect(find.semantics.byLabel('Ayuda para completar el formulario'), findsOneWidget);
  });

  testWidgets('cambia de fila a columna con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppAlertContextual(
            horizontal: true,
            message: 'Completa todos los campos obligatorios antes de continuar',
            action: AppButton(label: 'Completar información', onPressed: () {}),
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Completa todos los campos obligatorios antes de continuar')).dy,
      lessThan(tester.getCenter(find.text('Completar información')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
