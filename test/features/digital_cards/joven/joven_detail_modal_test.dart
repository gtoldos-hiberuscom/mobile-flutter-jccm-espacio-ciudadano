import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/0_entity/joven_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/1_domain/joven_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/2_presentation/joven_detail_modal.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/3_data/joven_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _FakeRepository implements JovenRepository {
  _FakeRepository(this._card);

  final JovenCard _card;

  @override
  Future<JovenCard> loadCard() async => _card;

  @override
  Future<BinaryArtifact> requestQr() async => const BinaryArtifact(
    sourceKind: BinaryArtifactKind.qrText,
    source: BinaryArtifactSource.text('x'),
    suggestedFileNameBase: 'joven',
    originEndpoint: '/carnet-digital/qr/{dni}',
  );

  @override
  Future<BinaryArtifact> requestPdf() async => requestQr();

  @override
  Future<BinaryArtifact> requestPkpass() async => requestQr();
}

void main() {
  testWidgets('JovenDetailModal.show opens a sheet that renders the codigo and action bars', (final tester) async {
    final card = JovenCard(
      id: 'card-1',
      holderName: 'Lucía Fernández Ruiz',
      codigo: 'CJ-2025-088771',
      status: DigitalCardStatus.available,
      expiryDate: DateTime(2027, 10, 22),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          jovenRepositoryProvider.overrideWithValue(_FakeRepository(card)),
        ],
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<Object>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (final BuildContext context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  key: const ValueKey('openJovenModalButton'),
                  onPressed: () => JovenDetailModal.show(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Sheet not visible yet.
    expect(find.byType(JovenDetailModal), findsNothing);

    // Tap to open.
    await tester.tap(find.byKey(const ValueKey('openJovenModalButton')));
    await tester.pumpAndSettle();

    // Modal is visible with the codigo + action bar.
    expect(find.byType(JovenDetailModal), findsOneWidget);
    expect(find.textContaining('CJ-2025-088771'), findsOneWidget);
    expect(find.byKey(const ValueKey('jovenActionBar-qr')), findsOneWidget);
    expect(find.byKey(const ValueKey('jovenActionBar-pdf')), findsOneWidget);
    expect(find.byKey(const ValueKey('jovenActionBar-pkpass')), findsOneWidget);
    // Modal chrome — drag handle + close button.
    expect(find.byKey(const ValueKey('jovenDetailModalDragHandle')), findsOneWidget);
    expect(find.byKey(const ValueKey('jovenDetailModalCloseButton')), findsOneWidget);
  });
}
