import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('expone nombre, rol, estado y accion semantica', (final tester) async {
    var presses = 0;

    await tester.pumpWidget(
      buildApp(
        AppIconButton(
          icon: Icons.close,
          semanticsLabel: 'Cerrar',
          onPressed: () => presses++,
        ),
      ),
    );

    final semantics = tester.getSemantics(find.byType(AppIconButton));
    expect(semantics.label, 'Cerrar');
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    tester.semantics.tap(find.semantics.byLabel('Cerrar'));
    await tester.pump();

    expect(presses, 1);
  });

  testWidgets('deshabilitado no ofrece accion semantica', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppIconButton(
          icon: Icons.close,
          semanticsLabel: 'Cerrar',
          onPressed: null,
        ),
      ),
    );

    final semantics = tester.getSemantics(find.byType(AppIconButton));
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('cargando anuncia el estado y bloquea la accion', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppIconButton(
          icon: Icons.save,
          semanticsLabel: 'Guardar',
          isLoading: true,
          onPressed: () {},
        ),
      ),
    );

    final semantics = tester.getSemantics(find.byType(AppIconButton));
    expect(semantics.label, 'Guardar, Cargando');
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('mantiene un area tactil de 48 por 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppIconButton(
          icon: Icons.close,
          semanticsLabel: 'Cerrar',
          size: AppButtonSize.small,
          onPressed: () {},
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppIconButton)), const Size(48, 48));
  });

  test('rechaza una etiqueta semantica vacia', () {
    expect(
      () => AppIconButton(
        icon: Icons.close,
        semanticsLabel: '',
        onPressed: () {},
      ),
      throwsAssertionError,
    );
  });
}
