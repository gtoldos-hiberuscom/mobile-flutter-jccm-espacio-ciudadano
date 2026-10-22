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

  testWidgets('el aviso legal se muestra integrado, sin enlaces externos', (final tester) async {
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

    expect(find.text('1. Objeto y ámbito de aplicación.'), findsOneWidget);
    expect(find.text('12. Normativa aplicable.'), findsOneWidget);
    expect(find.byType(AppInlineLink), findsNothing);
  });
}

const _accessibilityLinks = [
  'Real Decreto 1112/2018, de 7 de septiembre',
  'https://espaciociudadano.jccm.es/',
  'formulario de contacto',
  'las oficinas del 012 y OIRES',
];
