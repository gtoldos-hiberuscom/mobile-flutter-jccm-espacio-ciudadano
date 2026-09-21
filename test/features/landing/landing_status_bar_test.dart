import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('la home pública define iconos oscuros desde la primera apertura', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [landingProvider.overrideWith(_StaticLandingNotifier.new)],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LandingPage(),
        ),
      ),
    );
    await tester.pump();
    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
    );
    expect(region.value.statusBarIconBrightness, Brightness.dark);
    expect(region.value.statusBarBrightness, Brightness.light);
    expect(tester.takeException(), isNull);
  });
}

class _StaticLandingNotifier extends LandingNotifier {
  @override
  void consumeLoginSuccess() {}

  /// Neutralizado: la landing intenta reanudar la sesión guardada al montarse,
  /// lo que arrastraría el almacén seguro y `AppConfig` a un test que sólo
  /// mira la barra de estado.
  @override
  Future<void> tryRestoreSession({
    required final String localizedTitle,
    required final String localizedReason,
    required final String localizedCancel,
  }) async {}
}
