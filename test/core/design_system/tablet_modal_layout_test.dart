import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  for (final size in [const Size(390, 844), const Size(800, 1100), const Size(1100, 800)]) {
    testWidgets('download sheet uses a centered phone width at $size', (final tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (final context) => TextButton(
                onPressed: () => AppBottomSheet.show<void>(
                  context: context,
                  horizontalMargin: 4,
                  body: const SizedBox(key: ValueKey('content'), width: double.infinity, height: 100),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byKey(const ValueKey('content')));
      expect(rect.width, 348);
      expect(rect.center.dx, size.width / 2);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('content')), findsNothing);
    });
  }
}
