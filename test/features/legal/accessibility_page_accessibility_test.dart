import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
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

    // El símbolo «⇲» es sólo visual: el lector anuncia el nombre y la pista.
    for (final label in _accessibilityLinks) {
      // Flutter sólo genera nodos para lo que está en pantalla.
      await tester.ensureVisible(find.text('$label${AppInlineLink.externalMark}'));
      await tester.pumpAndSettle();
      final matches = find.semantics.byLabel(label);
      expect(matches, findsOneWidget);

      final data = matches.evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isLink, isTrue, reason: label);
      expect(data.flagsCollection.isButton, isFalse, reason: label);
      expect(data.hint, 'Abre en navegador externo', reason: label);
      expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
    }
    expect(find.semantics.byLabel(RegExp('⇲')), findsNothing);
    // El texto que rodea al enlace no hereda su rol.
    final surrounding = find.semantics.byLabel(RegExp('de manera presencial')).evaluate().single.getSemanticsData();
    expect(surrounding.flagsCollection.isLink, isFalse);
  });

  testWidgets('WCAG 2.1.1 y 2.4.7: el tabulador llega a los cuatro enlaces, los muestra y los marca', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

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
    await tester.pumpAndSettle();

    final reached = <String>[];
    for (var i = 0; i < 20 && reached.length < _accessibilityLinks.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      final link = find.ancestor(of: find.byWidget(focused.widget), matching: find.byType(AppInlineLink));
      if (link.evaluate().isEmpty) {
        continue;
      }
      final widget = tester.widget<AppInlineLink>(link);
      reached.add(widget.text);
      final rect = tester.getRect(link);
      expect(rect.top, greaterThanOrEqualTo(0), reason: widget.text);
      expect(rect.bottom, lessThanOrEqualTo(667), reason: widget.text);
      expect(
        find.descendant(
          of: link,
          matching: find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter),
        ),
        findsOneWidget,
        reason: widget.text,
      );
    }
    expect(reached, _accessibilityLinks);
  });

  testWidgets('el botón de búsqueda muestra el anillo de foco', (final tester) async {
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
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(AccessibilityPage)));

    Focus.of(tester.element(find.descendant(of: find.byTooltip(l10n.legalSearchTooltip), matching: find.byType(AppIcon)))).requestFocus();
    await tester.pumpAndSettle();

    expect(
      find.ancestor(
        of: find.byTooltip(l10n.legalSearchTooltip),
        matching: find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter),
      ),
      findsOneWidget,
    );
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

    for (final label in _legalNoticeLinks) {
      final matches = find.semantics.byLabel(label);
      expect(matches, findsOneWidget);

      final data = matches.evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isLink, isTrue, reason: label);
      expect(data.flagsCollection.isButton, isFalse, reason: label);
      expect(data.hint, 'Abre en navegador externo', reason: label);
      expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
    }
    expect(find.semantics.byLabel(RegExp('⇲')), findsNothing);
  });

  testWidgets('aviso legal: el tabulador llega a los dos enlaces con anillo y sin velo de foco', (final tester) async {
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
    await tester.pumpAndSettle();

    final reached = <String>[];
    for (var i = 0; i < 10 && reached.length < _legalNoticeLinks.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      final link = find.ancestor(of: find.byWidget(focused.widget), matching: find.byType(AppInlineLink));
      if (link.evaluate().isEmpty) {
        continue;
      }
      reached.add(tester.widget<AppInlineLink>(link).text);
      expect(
        find.descendant(
          of: link,
          matching: find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter),
        ),
        findsOneWidget,
      );
      // WCAG 1.4.3: el foco no pinta un velo que baje el contraste del texto.
      expect(tester.widget<InkWell>(find.descendant(of: link, matching: find.byType(InkWell))).focusColor, Colors.transparent);
    }
    expect(reached, _legalNoticeLinks);
  });
}

const _accessibilityLinks = [
  'Real Decreto 1112/2018, de 7 de septiembre',
  'https://espaciociudadano.jccm.es/',
  'formulario de contacto',
  'las oficinas del 012 y OIRES',
];

const _legalNoticeLinks = [
  'Real Decreto 1112/2018, de 7 de septiembre',
  'https://espaciociudadano.jccm.es/',
];
