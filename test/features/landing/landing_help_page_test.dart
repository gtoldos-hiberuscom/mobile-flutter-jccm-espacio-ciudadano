import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_help_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/clave_login_veil.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('la pantalla de cómo acceder lleva el velo de Cl@ve', (final tester) async {
    // Era la tercera pantalla con CTA de acceso (tras la home pública y
    // "Saber más") y la única sin velo: se pulsaba "Acceder" y no ocurría
    // nada visible mientras se abría el navegador (N-20).
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LandingHelpPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ClaveLoginVeil), findsOneWidget);
  });
}
