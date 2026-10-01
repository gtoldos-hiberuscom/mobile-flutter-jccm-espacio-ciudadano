import 'dart:ui' show SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// «Mis datos > Bienestar social» y el detalle de balneario.
void main() {
  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  Widget buildPage({final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [jccmDataAuthorizationProvider.overrideWith((final ref) async => true)],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const MyDataSocialWelfarePage(),
    ),
  );

  testWidgets('WCAG 1.4.11 / 2.4.7: pestañas, volver y tarjetas muestran el anillo al tabular', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 900);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final cards = tester.widgetList<AppNavigationCard>(find.byType(AppNavigationCard)).map((final card) => card.title).toList();
    expect(cards, isNotEmpty);

    var stops = 0;
    final reachedCards = <String>{};
    for (var i = 0; i < 20; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      stops++;
      // Cada parada es visible: hay un anillo que envuelve al control.
      expect(find.ancestor(of: find.byWidget(focused.widget), matching: ring()), findsOneWidget);
      for (final title in cards) {
        if (find.descendant(of: find.byWidget(focused.widget), matching: find.text(title)).evaluate().isNotEmpty) {
          reachedCards.add(title);
        }
      }
    }
    expect(stops, greaterThan(cards.length));
    expect(reachedCards, cards.toSet());
  });

  testWidgets('WCAG 4.1.2: las pestañas anuncian rol, estado y posición', (final tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataSocialWelfarePage)));

    final data = find.semantics.byLabel(l10n.socialWelfareDataTab).evaluate().single.getSemanticsData();
    expect(data.role, SemanticsRole.tab);
    expect(data.flagsCollection.isSelected, Tristate.isTrue);
    expect(data.value, 'Pestaña 1 de 2');
  });

  testWidgets('WCAG 1.4.4: al 200 por ciento las pestañas se desplazan con el contenido', (final tester) async {
    await tester.pumpWidget(buildPage(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();
    expect(find.byType(NestedScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detalle de balneario: «Volver» e «Información» muestran el anillo', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppDetailScaffold(title: 'Balneario', onBack: () {}, onInfo: () {}, body: const SizedBox.shrink()),
      ),
    );
    await tester.pumpAndSettle();

    for (final tooltip in ['Atrás', 'Información']) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(
        find.ancestor(of: find.byTooltip(tooltip), matching: ring()),
        findsOneWidget,
        reason: tooltip,
      );
    }
  });
}
