import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/widgets/digital_card_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _wrap(final Widget child) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('es'),
  home: Scaffold(body: child),
);

void main() {
  group('DigitalCardTile', () {
    testWidgets('available status — QR/PKPASS/PDF actions are enabled', (final tester) async {
      DigitalCardAction? invoked;
      await tester.pumpWidget(
        _wrap(
          DigitalCardTile(
            card: const DigitalCard(
              id: 'available-1',
              type: DigitalCardType.familiaNumerosa,
              status: DigitalCardStatus.available,
            ),
            onAction: (final action) => invoked = action,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final qr = find.byKey(const ValueKey('digitalCardsAction-qr-available-1'));
      final pkpass = find.byKey(const ValueKey('digitalCardsAction-pkpass-available-1'));
      final pdf = find.byKey(const ValueKey('digitalCardsAction-pdf-available-1'));
      expect(qr, findsOneWidget);
      expect(pkpass, findsOneWidget);
      expect(pdf, findsOneWidget);

      OutlinedButton buttonOf(final Finder f) => tester.widget<OutlinedButton>(
        find.descendant(of: f, matching: find.byType(OutlinedButton)),
      );

      expect(buttonOf(qr).onPressed, isNotNull);
      expect(buttonOf(pkpass).onPressed, isNotNull);
      expect(buttonOf(pdf).onPressed, isNotNull);

      await tester.tap(qr);
      expect(invoked, DigitalCardAction.qr);
    });

    testWidgets('notValid status — actions are disabled and message shown', (final tester) async {
      await tester.pumpWidget(
        _wrap(
          DigitalCardTile(
            card: const DigitalCard(
              id: 'invalid-1',
              type: DigitalCardType.joven,
              status: DigitalCardStatus.notValid,
            ),
            onAction: (final _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final qr = find.byKey(const ValueKey('digitalCardsAction-qr-invalid-1'));
      final button = tester.widget<OutlinedButton>(
        find.descendant(of: qr, matching: find.byType(OutlinedButton)),
      );
      expect(button.onPressed, isNull);
      expect(find.textContaining('no está vigente'), findsOneWidget);
    });

    testWidgets('notDownloadable status — actions are disabled and message shown', (final tester) async {
      await tester.pumpWidget(
        _wrap(
          DigitalCardTile(
            card: const DigitalCard(
              id: 'nodl-1',
              type: DigitalCardType.discapacidad,
              status: DigitalCardStatus.notDownloadable,
            ),
            onAction: (final _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pdf = find.byKey(const ValueKey('digitalCardsAction-pdf-nodl-1'));
      final button = tester.widget<OutlinedButton>(
        find.descendant(of: pdf, matching: find.byType(OutlinedButton)),
      );
      expect(button.onPressed, isNull);
      expect(find.textContaining('no es descargable'), findsOneWidget);
    });
  });
}
