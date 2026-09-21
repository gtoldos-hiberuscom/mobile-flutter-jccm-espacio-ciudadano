import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_real_estate_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_real_estate_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_housing_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  for (final testCase in const [
    (label: 'Urbano', selectedIndex: 1, reference: 'URBAN-1'),
    (label: 'Rústico', selectedIndex: 2, reference: 'RUSTIC-1'),
  ]) {
    testWidgets('al volver del detalle conserva el filtro ${testCase.label}', (final tester) async {
      final router = GoRouter(
        initialLocation: Routes.myDataHousingRealEstate,
        routes: [
          GoRoute(
            path: Routes.myDataHousingRealEstate,
            builder: (final context, final state) => const MyDataHousingRealEstatePage(),
          ),
          GoRoute(
            path: Routes.myDataHousingRealEstateDetail,
            builder: (final context, final state) => MyDataHousingRealEstateDetailPage(
              reference: state.pathParameters['reference'] ?? '',
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            housingRealEstatePropertiesProvider.overrideWith(
              (final ref) async => const [
                RealEstateProperty(cadastralReference: 'URBAN-1', kind: RealEstatePropertyKind.urban),
                RealEstateProperty(cadastralReference: 'RUSTIC-1', kind: RealEstatePropertyKind.rustic),
              ],
            ),
          ],
          child: MaterialApp.router(
            locale: const Locale('es'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(testCase.label));
      await tester.pumpAndSettle();
      expect(tester.widget<AppSegmentedControl>(find.byType(AppSegmentedControl)).selectedIndex, testCase.selectedIndex);

      await tester.tap(find.textContaining(testCase.reference));
      await tester.pumpAndSettle();
      expect(find.byType(MyDataHousingRealEstateDetailPage), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();

      expect(find.byType(MyDataHousingRealEstatePage), findsOneWidget);
      expect(tester.widget<AppSegmentedControl>(find.byType(AppSegmentedControl)).selectedIndex, testCase.selectedIndex);
    });
  }
}
