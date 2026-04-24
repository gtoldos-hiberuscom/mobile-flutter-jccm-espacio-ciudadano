import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/casework_search_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubRepo implements CaseworkRepository {
  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async => <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async => <CaseworkItem>[
    CaseworkItem(
      id: 'r1',
      type: CaseworkTab.expedientes,
      number: 'EXP/2025/00123',
      date: DateTime(2025, 9, 14),
      organism: 'Org',
      subject: 'Subject',
      status: CaseworkItemStatus.enTramite,
    ),
  ];

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async => <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(
    final String number,
  ) async => throw StateError('boom');
}

Widget _wrap(final Widget child) => ProviderScope(
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

void main() {
  testWidgets(
    'submitting an empty form shows the at-least-one-required validation '
    'error',
    (final tester) async {
      await tester.pumpWidget(_wrap(const CaseworkSearchPage()));
      await tester.tap(find.text('Buscar'));
      await tester.pump();
      expect(
        find.text('Introduce al menos uno de los tres campos para buscar.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'submitting a malformed identification surfaces the format error',
    (final tester) async {
      await tester.pumpWidget(_wrap(const CaseworkSearchPage()));
      await tester.enterText(
        find.widgetWithText(TextField, 'NIF / NIE / Pasaporte'),
        '1234',
      );
      await tester.tap(find.text('Buscar'));
      await tester.pump();
      expect(
        find.textContaining('Formato no válido'),
        findsWidgets,
      );
    },
  );

  testWidgets('happy path renders the result list and the reset CTA', (final tester) async {
    await tester.pumpWidget(_wrap(const CaseworkSearchPage()));
    await tester.enterText(
      find.widgetWithText(TextField, 'NIF / NIE / Pasaporte'),
      '12345678Z',
    );
    await tester.tap(find.text('Buscar'));
    await tester.pump(); // searching
    await tester.pumpAndSettle();
    expect(find.text('1 resultado'), findsOneWidget);
    expect(find.text('EXP/2025/00123'), findsOneWidget);
    expect(find.text('Buscar otra cosa'), findsWidgets);
  });
}
