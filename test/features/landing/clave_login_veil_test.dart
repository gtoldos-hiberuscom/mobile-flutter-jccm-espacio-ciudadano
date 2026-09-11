import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_screen.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/clave_login_veil.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp({required final bool isAuthenticating}) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ClaveLoginVeil(
      isAuthenticating: isAuthenticating,
      child: const Scaffold(body: Text('contenido')),
    ),
  );

  testWidgets('sin autenticación en curso no se interpone nada', (final tester) async {
    await tester.pumpWidget(buildApp(isAuthenticating: false));

    expect(find.text('contenido'), findsOneWidget);
    expect(find.byType(AppLoadingScreen), findsNothing);
  });

  testWidgets('avisa de que se está accediendo con Cl@ve', (final tester) async {
    await tester.pumpWidget(buildApp(isAuthenticating: true));

    expect(find.byType(AppLoadingScreen), findsOneWidget);
    expect(find.text('Accediendo con Cl@ve'), findsOneWidget);
  });

  testWidgets('pide iconos claros en la barra de estado, que el velo cubre', (final tester) async {
    await tester.pumpWidget(buildApp(isAuthenticating: true));

    // El velo es azul oscuro y llega hasta arriba: con los iconos oscuros del
    // resto de la app la barra de estado parecía tapada.
    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first);
    expect(region.value.statusBarIconBrightness, Brightness.light);
  });
}
