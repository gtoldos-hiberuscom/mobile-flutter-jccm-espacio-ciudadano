import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/blocked_state_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia bloqueo, mensaje y subtítulo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const BlockedStateWidget(
          message: 'Funcionalidad en mantenimiento',
          subtitle: 'Vuelve a intentarlo más tarde',
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Acceso no disponible: Funcionalidad en mantenimiento. Vuelve a intentarlo más tarde').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('marca el mensaje como encabezado de nivel dos', (final tester) async {
    await tester.pumpWidget(
      buildApp(const BlockedStateWidget(message: 'Acceso restringido')),
    );

    final heading = tester.getSemantics(find.text('Acceso restringido'));
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
  });

  testWidgets('mantiene la acción como control independiente', (final tester) async {
    var presses = 0;
    await tester.pumpWidget(
      buildApp(
        BlockedStateWidget(
          message: 'Acceso restringido',
          action: AppButton(
            label: 'Contactar con soporte',
            onPressed: () => presses++,
          ),
        ),
      ),
    );

    final action = find.semantics.byLabel('Contactar con soporte');
    expect(action.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(action);
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('permite desactivar el anuncio para estados ya presentes', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const BlockedStateWidget(
          message: 'Acceso restringido',
          announce: false,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Acceso no disponible: Acceso restringido').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('permite personalizar la etiqueta accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const BlockedStateWidget(
          message: 'No disponible',
          semanticsLabel: 'Servicio temporalmente fuera de servicio',
        ),
      ),
    );

    expect(find.semantics.byLabel('Servicio temporalmente fuera de servicio'), findsOneWidget);
  });

  testWidgets('admite texto al 200 por ciento en pantalla estrecha', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          BlockedStateWidget(
            message: 'Esta funcionalidad no está disponible temporalmente',
            subtitle: 'Contacta con soporte si necesitas realizar la gestión de forma urgente',
            action: AppButton(label: 'Contactar con soporte', onPressed: () {}),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
