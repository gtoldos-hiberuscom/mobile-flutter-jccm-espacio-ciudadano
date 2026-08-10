import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_filter_controls.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_stickybar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Future<void> setLandscape(final WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 360);
    addTearDown(tester.view.reset);
  }

  Widget app(final Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('sticky actions share one row in landscape', (final tester) async {
    await setLandscape(tester);
    await tester.pumpWidget(
      app(
        Align(
          alignment: Alignment.bottomCenter,
          child: AppStickybar(
            children: [
              AppButton(label: 'Ayuda', onPressed: () {}),
              AppButton(label: 'Información', onPressed: () {}),
              AppButton(label: 'Acceder', onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getCenter(find.text('Ayuda')).dy, tester.getCenter(find.text('Acceder')).dy);
  });

  testWidgets('filter actions share one row in landscape', (final tester) async {
    await setLandscape(tester);
    await tester.pumpWidget(
      app(
        Align(
          alignment: Alignment.bottomCenter,
          child: AppFilterActionsBar(onClear: () {}, onApply: () {}),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getCenter(find.text('Desmarcar todo')).dy, tester.getCenter(find.text('Aplicar filtros')).dy);
  });

  testWidgets('main navigation uses its compact landscape height', (final tester) async {
    await setLandscape(tester);
    await tester.pumpWidget(
      app(
        Align(
          alignment: Alignment.bottomCenter,
          child: AppBottomTabBar(
            items: const [
              AppBottomTabBarItem(label: 'Inicio', icon: Icons.home_outlined),
              AppBottomTabBarItem(label: 'Gestión', icon: Icons.folder_outlined),
            ],
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(AppBottomTabBar)).height, 60);
  });
}
