import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_filter_controls.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_icon_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// WCAG 1.4.11 / 1.4.1 / 2.4.7: todos los controles de Inicio, Gestión y la
/// barra inferior muestran el anillo de foco común al recibir el foco.
void main() {
  Finder findFocusRing() => find.byWidgetPredicate(
    (final widget) => widget is CustomPaint && widget.foregroundPainter is AppFocusRingPainter,
  );

  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  Future<void> expectRingOnFocus(final WidgetTester tester, final Finder textInsideControl) async {
    expect(findFocusRing(), findsNothing);
    Focus.of(tester.element(textInsideControl)).requestFocus();
    await tester.pumpAndSettle();
    expect(findFocusRing(), findsOneWidget);
  }

  testWidgets('tarjeta simple de Inicio (Mis novedades)', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppSimpleNavCard(label: 'Notificaciones', description: 'Tienes 3 pendientes', onTap: () {})),
    );
    await expectRingOnFocus(tester, find.text('Notificaciones'));
  });

  testWidgets('tarjeta de acceso rápido (Mis datos)', (final tester) async {
    // La tarjeta rellena el alto de su celda: necesita un alto acotado.
    await tester.pumpWidget(
      buildApp(
        SizedBox(
          width: 109,
          height: 150,
          child: AppQuickAccessCard(label: 'Salud', icon: Icons.favorite_outline, onTap: () {}),
        ),
      ),
    );
    await expectRingOnFocus(tester, find.text('Salud'));
  });

  testWidgets('tarjeta de navegación de Gestión (Mis expedientes)', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppNavigationCard(title: 'Mis expedientes', onTap: () {})),
    );
    await expectRingOnFocus(tester, find.text('Mis expedientes'));
  });

  testWidgets('tarjeta de trámite recomendado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppRecommendationCard(
          title: 'Ayudas para rehabilitación',
          categoryLabels: const [],
          detailLabel: 'Hechos vitales asociados',
          detailText: 'Quiero mejorar mi vivienda',
          onTap: () {},
        ),
      ),
    );
    await expectRingOnFocus(tester, find.text('Ayudas para rehabilitación'));
  });

  testWidgets('botón flotante Carnets', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppFab(icon: Icons.badge_outlined, label: 'Carnets', onPressed: () {})),
    );
    await expectRingOnFocus(tester, find.text('Carnets'));
  });

  testWidgets('destino de la barra de navegación inferior', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: AppBottomTabBar(
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
    await expectRingOnFocus(tester, find.text('Gestión'));
  });

  testWidgets('pestaña de la navegación flotante', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppFloatingNavigation(tabs: const ['Todos', 'Pendientes'], selectedIndex: 0, onTabSelected: (_) {})),
    );
    await expectRingOnFocus(tester, find.text('Pendientes'));
  });

  testWidgets('tarjeta de Mis datos (Salud, Bienestar social…)', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppIconNavigationCard(title: 'Bienestar social', description: 'Servicios disponibles', icon: Icons.people_outline, onTap: () {})),
    );
    await expectRingOnFocus(tester, find.text('Bienestar social'));
  });

  testWidgets('chip de filtro seleccionable', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppSelectableFilterChip(label: 'Nacimiento', isSelected: false, onTap: () {})),
    );
    await expectRingOnFocus(tester, find.text('Nacimiento'));
  });
}
