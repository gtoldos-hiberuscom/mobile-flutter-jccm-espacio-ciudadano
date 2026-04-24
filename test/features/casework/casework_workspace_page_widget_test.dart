import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_workspace_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/casework_workspace_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/widgets/casework_item_tile.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubRepo implements CaseworkRepository {
  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async =>
      <CaseworkItem>[
        CaseworkItem(
          id: '$tab-1',
          type: tab,
          number: 'NUM-${tab.name}',
          date: DateTime(2025, 6, 15),
          organism: 'Organismo X',
          subject: 'Asunto de prueba ${tab.name}',
          status: CaseworkItemStatus.enTramite,
        ),
      ];
}

Widget _wrapWithStub(final Widget child) => ProviderScope(
      overrides: [
        caseworkRepositoryProvider.overrideWith((final ref) => _StubRepo()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: child,
      ),
    );

Widget _wrap(final Widget child) => ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: child,
      ),
    );

void main() {
  testWidgets('CaseworkItemTile renders number, subject and status badge',
      (final tester) async {
    final item = CaseworkItem(
      id: 'x',
      type: CaseworkTab.expedientes,
      number: 'EXP/2025/00001',
      date: DateTime(2025, 6, 15),
      organism: 'Consejería',
      subject: 'Subvención prueba',
      status: CaseworkItemStatus.finalizado,
    );
    await tester.pumpWidget(_wrap(Scaffold(body: CaseworkItemTile(item: item))));
    await tester.pumpAndSettle();

    expect(find.text('EXP/2025/00001'), findsOneWidget);
    expect(find.text('Subvención prueba'), findsOneWidget);
    expect(find.text('Consejería'), findsOneWidget);
    expect(find.text('Finalizado'), findsOneWidget);
    expect(find.textContaining('15/06/2025'), findsOneWidget);
  });

  testWidgets(
    'CaseworkWorkspacePage renders 3 tabs and switching tabs updates the notifier',
    (final tester) async {
    await tester.pumpWidget(_wrapWithStub(const CaseworkWorkspacePage()));
    await tester.pumpAndSettle();

    // Three tab labels are present.
    expect(find.text('Mis expedientes'), findsWidgets);
    expect(find.text('Mis entradas de registro'), findsWidgets);
    expect(find.text('Mis salidas de registro'), findsWidgets);

    // Initial tab is expedientes.
    expect(find.text('NUM-expedientes'), findsOneWidget);

    // Tap the third tab (ensure scrolled into view).
    await tester.scrollUntilVisible(
      find.widgetWithText(Tab, 'Mis salidas de registro'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(
      find.widgetWithText(Tab, 'Mis salidas de registro'),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // The notifier mirrors the selection.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(CaseworkWorkspacePage)),
    );
    final state = container
        .read(caseworkWorkspaceProvider)
        .requireValue;
    expect(state.selectedTab, CaseworkTab.salidasRegistro);

    // The tile for the selected tab is now rendered.
    expect(find.text('NUM-salidasRegistro'), findsOneWidget);
  });
}
