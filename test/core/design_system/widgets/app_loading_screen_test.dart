import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_screen.dart';
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

  testWidgets('muestra título y descripción sobre el indicador de carga', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppLoadingScreen(
          title: 'Accediendo con Cl@ve',
          description: 'Estamos validando tu identidad.',
        ),
      ),
    );

    expect(find.text('Accediendo con Cl@ve'), findsOneWidget);
    expect(find.text('Estamos validando tu identidad.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('la descripción es opcional', (final tester) async {
    await tester.pumpWidget(buildApp(const AppLoadingScreen(title: 'Cargando')));

    expect(find.text('Cargando'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('anuncia el título y oculta el spinner al lector de pantalla', (final tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      buildApp(
        const AppLoadingScreen(
          title: 'Accediendo con Cl@ve',
          description: 'Estamos validando tu identidad.',
        ),
      ),
    );

    expect(
      tester.getSemantics(find.text('Accediendo con Cl@ve')).label,
      contains('Accediendo con Cl@ve'),
    );
    // El spinner es decorativo: lo que se anuncia es el texto, no un genérico
    // "cargando" que duplicaría la información.
    expect(find.bySemanticsLabel(RegExp('argando')), findsNothing);

    handle.dispose();
  });

  testWidgets('se pinta sin Scaffold encima, montado directamente en un Stack', (final tester) async {
    // Es como se usa en la landing: superpuesto al contenido, sin Material
    // ancestro. Sin uno propio, los textos saldrían con el subrayado de
    // depuración.
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Stack(
          children: [
            Positioned.fill(child: AppLoadingScreen(title: 'Accediendo con Cl@ve')),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Accediendo con Cl@ve'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Accediendo con Cl@ve')).style?.decoration,
      isNot(TextDecoration.underline),
    );
  });

  testWidgets('el anillo respeta el tamaño del diseño', (final tester) async {
    // Sin tamaño explícito, el indicador se queda en los 36 dp intrínsecos de
    // Material por mucho que la caja que lo rodea sea mayor.
    await tester.pumpWidget(buildApp(const AppLoadingScreen(title: 'Cargando')));

    expect(tester.getSize(find.byType(CircularProgressIndicator)), const Size(126, 126));
  });

  testWidgets('hace reflow al 200 por ciento sin desbordar', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppLoadingScreen(
          title: 'Accediendo con Cl@ve',
          description: 'Estamos validando tu identidad y preparando tus datos. Puede tardar unos segundos.',
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
