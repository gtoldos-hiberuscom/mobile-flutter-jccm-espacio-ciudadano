import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/app/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/data_consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/data_consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/data_consent_repository_provider.dart';

class _FakeDataConsentRepository implements DataConsentRepository {
  _FakeDataConsentRepository({required this.items})
      : _state = <String, bool>{
          for (final c in items) c.id: c.accepted,
        };

  final List<DataConsent> items;
  Map<String, bool> _state;
  int saveCalls = 0;
  int revokeCalls = 0;

  @override
  Future<DataConsentLoadResult> loadClausulas(
    final String idAgente,
  ) async =>
      DataConsentLoadResult(
        items: <DataConsent>[
          for (final c in items)
            DataConsent(
              id: c.id,
              type: c.type,
              accepted: _state[c.id] ?? false,
            ),
        ],
      );

  @override
  Future<void> saveClausulas(
    final String idAgente,
    final Map<DataConsentType, bool> acceptance,
  ) async {
    saveCalls += 1;
    _state = <String, bool>{
      for (final c in items) c.id: acceptance[c.type] ?? false,
    };
  }

  @override
  Future<void> revokeAll(final String idAgente) async {
    revokeCalls += 1;
    _state = <String, bool>{
      for (final c in items) c.id: false,
    };
  }
}

const _catalog = <DataConsent>[
  DataConsent(
    id: 'consent-jccm',
    type: DataConsentType.jccm,
    accepted: true,
  ),
  DataConsent(
    id: 'consent-otras-admin',
    type: DataConsentType.otrasAdmin,
    accepted: false,
  ),
  DataConsent(
    id: 'consent-perfilado',
    type: DataConsentType.perfilado,
    accepted: false,
  ),
];

Widget _harness(final _FakeDataConsentRepository repo) {
  return ProviderScope(
    overrides: [
      dataConsentRepositoryProvider.overrideWith((final _) => repo),
    ],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalization.delegates,
      supportedLocales: AppLocalization.supportedLocales,
      home: DataConsentPage(idAgente: 'agent-1'),
    ),
  );
}

void main() {
  testWidgets(
      'renders three switch tiles reflecting the persisted acceptance',
      (final tester) async {
    final repo = _FakeDataConsentRepository(items: _catalog);

    await tester.pumpWidget(_harness(repo));
    await tester.pumpAndSettle();

    expect(find.text('Mis autorizaciones'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('data-consent-tile-consent-jccm')),
      findsOneWidget,
    );

    final jccmTile = tester.widget<SwitchListTile>(
      find.byKey(const ValueKey<String>('data-consent-tile-consent-jccm')),
    );
    expect(jccmTile.value, isTrue);

    final otrasTile = tester.widget<SwitchListTile>(
      find.byKey(
        const ValueKey<String>('data-consent-tile-consent-otras-admin'),
      ),
    );
    expect(otrasTile.value, isFalse);

    // Save action is disabled when draft matches the persisted baseline.
    final saveButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Guardar'),
    );
    expect(saveButton.onPressed, isNull);

    // Toggle -> save becomes enabled.
    await tester.tap(
      find.byKey(
        const ValueKey<String>('data-consent-tile-consent-perfilado'),
      ),
    );
    await tester.pump();
    final saveAfterToggle = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Guardar'),
    );
    expect(saveAfterToggle.onPressed, isNotNull);
  });

  testWidgets('revoke action requires explicit confirmation before clearing',
      (final tester) async {
    final repo = _FakeDataConsentRepository(items: _catalog);

    await tester.pumpWidget(_harness(repo));
    await tester.pumpAndSettle();

    // Cancel path — repository must NOT be called.
    await tester.tap(
      find.byKey(const ValueKey<String>('data-consent-revoke-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Revocar tus autorizaciones'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
    await tester.pumpAndSettle();
    expect(repo.revokeCalls, 0);

    // Confirm path — repository.revokeAll is invoked once.
    await tester.tap(
      find.byKey(const ValueKey<String>('data-consent-revoke-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Revocar'));
    await tester.pumpAndSettle();
    expect(repo.revokeCalls, 1);
  });
}
