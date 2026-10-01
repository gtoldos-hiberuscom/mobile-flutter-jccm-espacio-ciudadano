import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets(
    'expone nombre, rol, estado y accion semantica',
    (final tester) async {
      var presses = 0;

      await tester.pumpWidget(
        buildApp(AppButton(label: 'Continuar', onPressed: () => presses++)),
      );

      final semantics = tester.getSemantics(find.byType(AppButton));
      expect(semantics.label, 'Continuar');
      expect(semantics.flagsCollection.isButton, isTrue);
      expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
      expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      tester.semantics.tap(find.semantics.byLabel('Continuar'));
      await tester.pump();

      expect(presses, 1);
    },
  );

  testWidgets('deshabilitado anuncia su estado y no ofrece accion', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppButton(label: 'Continuar', onPressed: null)),
    );

    final semantics = tester.getSemantics(find.byType(AppButton));
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('cargando anuncia el estado y bloquea la accion', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppButton(label: 'Guardar', isLoading: true, onPressed: () {})),
    );

    final semantics = tester.getSemantics(find.byType(AppButton));
    expect(semantics.label, 'Guardar, Cargando');
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('mantiene un area tactil minima de 48 por 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppButton(label: 'Aceptar', size: AppButtonSize.small, onPressed: () {})),
    );

    final size = tester.getSize(find.byType(AppButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('admite texto al 200 por ciento sin truncarlo', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppButton(
            isExpanded: true,
            label: 'Continuar con la tramitacion administrativa',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final text = tester.widget<Text>(find.text('Continuar con la tramitacion administrativa'));
    expect(text.maxLines, isNull);
    expect(text.overflow, isNull);
  });

  testWidgets('muestra el anillo de foco común sin desplazar el botón', (final tester) async {
    await tester.pumpWidget(buildApp(AppButton(label: 'Continuar', onPressed: () {})));
    final before = tester.getRect(find.byType(ElevatedButton));

    Focus.of(tester.element(find.text('Continuar'))).requestFocus();
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter),
      findsOneWidget,
    );
    expect(tester.getRect(find.byType(ElevatedButton)), before);
  });

  testWidgets('el icono deshabilitado no muestra anillo de foco', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppIconButton(icon: Icons.close, onPressed: null, semanticsLabel: 'Cerrar')),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter),
      findsNothing,
    );
  });
}
