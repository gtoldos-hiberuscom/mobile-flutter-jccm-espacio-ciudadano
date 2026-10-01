import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/support_fake_captcha.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget wrap(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: const [Locale('es')],
    home: Scaffold(body: child),
  );

  testWidgets('sin marcar muestra el texto y no avisa hasta que se pulsa', (final tester) async {
    var verified = 0;
    await tester.pumpWidget(
      wrap(SupportFakeCaptcha(verified: false, onVerified: () => verified++, verificationDelay: Duration.zero)),
    );

    expect(find.text('No soy un robot'), findsOneWidget);
    expect(verified, 0);
  });

  testWidgets('al pulsar muestra la comprobación y luego avisa una sola vez', (final tester) async {
    var verified = 0;
    await tester.pumpWidget(
      wrap(
        SupportFakeCaptcha(
          verified: false,
          onVerified: () => verified++,
          verificationDelay: const Duration(milliseconds: 500),
        ),
      ),
    );

    await tester.tap(find.text('No soy un robot'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(verified, 0);

    // Un segundo toque durante la comprobación no lanza otra verificación.
    await tester.tap(find.text('No soy un robot'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(verified, 1);
  });

  testWidgets('una vez verificado no vuelve a avisar al pulsar', (final tester) async {
    var verified = 0;
    await tester.pumpWidget(
      wrap(SupportFakeCaptcha(verified: true, onVerified: () => verified++, verificationDelay: Duration.zero)),
    );

    await tester.tap(find.text('No soy un robot'));
    await tester.pump();

    expect(verified, 0);
    expect(find.byIcon(Icons.check_circle_outlined), findsOneWidget);
  });

  testWidgets('expone el estado por semántica', (final tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(SupportFakeCaptcha(verified: false, onVerified: () {}, verificationDelay: Duration.zero)),
    );

    expect(
      tester.getSemantics(find.bySemanticsLabel(RegExp('No soy un robot, pendiente de verificar'))),
      matchesSemantics(
        label: 'No soy un robot, pendiente de verificar, pulsa para verificar',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasCheckedState: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });
}
