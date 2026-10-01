import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_address_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_housing_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hoja «Vivienda > Domicilio en Castilla-La Mancha»: WCAG 2.4.7 / 1.4.11.
void main() {
  testWidgets('«Volver» e «Información» muestran el anillo de foco', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [housingAddressProvider.overrideWith((final ref) async => null)],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MyDataHousingAddressPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final visited = <String>{};
    for (var i = 0; i < 8 && visited.length < 2; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      for (final name in ['Atrás', 'Información']) {
        if (find.ancestor(of: find.byWidget(focused.widget), matching: find.byTooltip(name)).evaluate().isNotEmpty) {
          visited.add(name);
          expect(
            find.ancestor(
              of: find.byWidget(focused.widget),
              matching: find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter),
            ),
            findsOneWidget,
            reason: name,
          );
        }
      }
    }
    expect(visited, {'Atrás', 'Información'});
  });
}
