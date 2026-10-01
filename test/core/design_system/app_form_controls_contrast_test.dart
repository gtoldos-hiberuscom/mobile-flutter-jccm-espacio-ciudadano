import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// «Editar datos de contacto»: contraste de textos de campo (WCAG 1.4.3),
/// indicador de foco de los campos y borde del botón terciario (1.4.11).
void main() {
  double contrast(final Color a, final Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final (hi, lo) = la > lb ? (la, lb) : (lb, la);
    return (hi + 0.05) / (lo + 0.05);
  }

  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );

  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  test('texto de ejemplo, prefijo y ayuda alcanzan 4,5:1', () {
    expect(contrast(AppColors.textPlaceholder, AppColors.backgroundWhite), greaterThanOrEqualTo(4.5));
    // Fondo azul claro de los campos con foco.
    expect(contrast(AppColors.textPlaceholder, const Color(0xFFD6EEF4)), greaterThanOrEqualTo(4.5));
    expect(contrast(AppColors.textHelper, AppColors.backgroundWhite), greaterThanOrEqualTo(4.5));
  });

  test('el borde del botón terciario alcanza 3:1 sobre blanco y sobre su fondo', () {
    expect(contrast(tertiaryBorderColor, AppColors.backgroundWhite), greaterThanOrEqualTo(3));
    expect(contrast(tertiaryBorderColor, AppColors.secondaryLight100), greaterThanOrEqualTo(3));
  });

  testWidgets('el campo de correo usa los colores accesibles y muestra el anillo de foco', (final tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      buildApp(AppInputCase(label: 'Correo electrónico', controller: controller, hint: 'nombre@ejemplo.es', helperText: 'Para recibir las notificaciones')),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration!.hintStyle!.color, AppColors.textPlaceholder);
    expect(tester.widget<Text>(find.text('Para recibir las notificaciones')).style!.color, AppColors.textHelper);

    expect(ring(), findsNothing);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(ring(), findsOneWidget);
  });

  testWidgets('el campo de teléfono usa colores accesibles y muestra el anillo de foco', (final tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildApp(AppPhoneInputCase(label: 'Teléfono móvil', controller: controller, onSelectorTap: () {})));

    expect(tester.widget<Text>(find.text('(ES)')).style!.color, AppColors.textPlaceholder);
    expect(tester.widget<TextField>(find.byType(TextField)).decoration!.hintStyle!.color, AppColors.textPlaceholder);

    expect(ring(), findsNothing);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(ring(), findsOneWidget);
  });

  testWidgets('«Cancelar» terciario dibuja un borde identificable', (final tester) async {
    await tester.pumpWidget(buildApp(AppButton(label: 'Cancelar', hierarchy: AppButtonHierarchy.tertiary, onPressed: () {})));

    final side = tester.widget<TextButton>(find.byType(TextButton)).style!.side!.resolve(const {});
    expect(side!.color, tertiaryBorderColor);
    expect(side.width, greaterThanOrEqualTo(1));
  });
}
