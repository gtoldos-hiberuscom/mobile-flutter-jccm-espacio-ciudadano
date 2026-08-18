import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_captcha_placeholder.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('privacy URL is visibly identified as an external link', (final tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppPrivacyInfoText(
            description: 'Información publicada en',
            linkText: 'https://rat.castillalamancha.es/info/2309',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (final widget) => widget is RichText && widget.text.toPlainText().contains('https://rat.castillalamancha.es/info/2309'),
      ),
      findsOneWidget,
    );
    expect(find.text('Enlace externo · Se abrirá fuera de la aplicación'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });
}
