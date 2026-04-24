import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/cip_summary.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_summary_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/cip_card.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/cip_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _FakeCipRepository implements CipRepository {
  _FakeCipRepository(this._snapshot);
  final CipSummary _snapshot;
  @override
  Future<CipSummary> loadCip() async => _snapshot;
}

Widget _wrap({required final CipSummary snapshot}) => ProviderScope(
      overrides: [
        cipRepositoryProvider
            .overrideWith((final ref) => _FakeCipRepository(snapshot)),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CipCard()),
      ),
    );

void main() {
  group('CipCard', () {
    testWidgets('renders CIP value and the read-only subtitle when loaded',
        (final tester) async {
      final loaded = CipSummary(
        id: 'cip-CLM01234567',
        cipCode: 'CLM01234567',
        titular: 'María Ejemplo',
        centroSalud: 'Centro de Salud Toledo Centro',
        region: 'Castilla-La Mancha',
        lastUpdatedAt: DateTime(2026, 5, 4, 10),
        loadState: CipLoadState.loaded,
      );

      await tester.pumpWidget(_wrap(snapshot: loaded));
      // resolve async build
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('cip-card-loaded')), findsOneWidget);
      expect(find.byKey(const ValueKey('cip-card-code')), findsOneWidget);
      expect(find.text('CLM01234567'), findsOneWidget);
      expect(find.text('María Ejemplo'), findsOneWidget);
      // The mandatory read-only caption from TASK-71 must be present.
      expect(
        find.byKey(const ValueKey('cip-card-readonly-subtitle')),
        findsOneWidget,
      );
    });

    testWidgets('renders the parse-error surface with retry CTA',
        (final tester) async {
      final parseError = CipSummary(
        id: 'cip-parse-error',
        cipCode: '',
        lastUpdatedAt: DateTime(2026, 5, 4, 10),
        loadState: CipLoadState.parseError,
        parseErrorReason: 'unknown_shape',
      );
      await tester.pumpWidget(_wrap(snapshot: parseError));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('cip-card-parseError')),
        findsOneWidget,
      );
      // No CIP code rendered for parse errors.
      expect(find.byKey(const ValueKey('cip-card-code')), findsNothing);
    });
  });

  group('cipSummaryProvider', () {
    test('hydrates the loaded snapshot returned by the repository',
        () async {
      final fixed = DateTime(2026, 5, 4, 10);
      final snapshot = CipSummary(
        id: 'cip-CLM00001',
        cipCode: 'CLM00001',
        lastUpdatedAt: fixed,
        loadState: CipLoadState.loaded,
      );
      final container = ProviderContainer(
        overrides: [
          cipRepositoryProvider
              .overrideWith((final ref) => _FakeCipRepository(snapshot)),
        ],
      );
      addTearDown(container.dispose);
      final value = await container.read(cipSummaryProvider.future);
      expect(value.loadState, CipLoadState.loaded);
      expect(value.cipCode, 'CLM00001');
    });
  });
}
