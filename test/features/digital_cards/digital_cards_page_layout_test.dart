import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_cards_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('all phone landscape cards use the same available width', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(844, 390);
    addTearDown(tester.view.reset);

    const cards = [
      DigitalCard(
        type: DigitalCardType.largeFamily,
        title: 'Familia Numerosa',
        number: '21200361',
        validFrom: null,
        expiresAt: null,
      ),
      DigitalCard(
        type: DigitalCardType.disability,
        title: 'Discapacidad',
        number: null,
        validFrom: null,
        expiresAt: null,
        isDefinitive: true,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          digitalCardsAuthorizationProvider.overrideWith((final ref) async => true),
          digitalCardsProvider.overrideWith((final ref) async => DigitalCardsSnapshot(cards: cards, failedCount: 0)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DigitalCardsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final widths = tester
        .widgetList<AppDigitalCard>(find.byType(AppDigitalCard))
        .map(
          (final card) => tester.getSize(find.byWidget(card)).width,
        );
    expect(widths.toSet(), hasLength(1));
  });
}
