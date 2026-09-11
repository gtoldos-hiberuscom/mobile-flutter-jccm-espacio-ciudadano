import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/accessibility_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/legal_notice_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('los destinos externos se anuncian como enlaces y no como botones', (
    final tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AccessibilityPage(),
        ),
      ),
    );

    for (final label in [
      'Real Decreto 1112/2018, de 7 de septiembre⇲',
      'https://espaciociudadano.jccm.es/⇲',
      'formulario de contacto⇲',
      'las oficinas del 012 y OIRES⇲',
    ]) {
      final matches = find.semantics.byLabel(label);
      expect(matches, findsOneWidget);

      final data = matches.evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isLink, isTrue, reason: label);
      expect(data.flagsCollection.isButton, isFalse, reason: label);
      expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
    }
  });

  testWidgets('los destinos externos del aviso legal tienen rol de enlace', (
    final tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LegalNoticePage(),
        ),
      ),
    );

    for (final label in [
      'Real Decreto 1112/2018, de 7 de septiembre ⇲',
      'https://espaciociudadano.jccm.es/⇲',
    ]) {
      final matches = find.semantics.byLabel(label);
      expect(matches, findsOneWidget);

      final data = matches.evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isLink, isTrue, reason: label);
      expect(data.flagsCollection.isButton, isFalse, reason: label);
      expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
    }
  });
}
