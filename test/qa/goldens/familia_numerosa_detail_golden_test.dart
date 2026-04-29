/// Sprint 9 / STORY-67 — Familia Numerosa detail golden.
///
/// Captures the carnet detail page using a deterministic fake card
/// (no real PII). Mirrors the fake-repository pattern used by
/// `test/features/digital_cards/familia_numerosa/familia_numerosa_detail_page_test.dart`.
///
/// Update with:
///
///   flutter test --update-goldens \
///     test/qa/goldens/familia_numerosa_detail_golden_test.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_categoria.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_member.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/2_presentation/familia_numerosa_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _GoldenRepo implements FamiliaNumerosaRepository {
  const _GoldenRepo();

  @override
  Future<FamiliaNumerosaCard> loadCard() async => FamiliaNumerosaCard(
    id: 'card-golden',
    holderName: 'Sample Holder',
    cardNumber: 'FN-0000-00',
    categoria: FamiliaNumerosaCategoria.general,
    status: DigitalCardStatus.available,
    members: const <FamiliaNumerosaMember>[
      FamiliaNumerosaMember(name: 'Sample Holder', parentesco: 'titular'),
      FamiliaNumerosaMember(name: 'Sample Partner', parentesco: 'conyuge'),
      FamiliaNumerosaMember(name: 'Sample Child A', parentesco: 'hija'),
      FamiliaNumerosaMember(name: 'Sample Child B', parentesco: 'hijo'),
    ],
    expiryDate: _expiry,
  );

  static final DateTime _expiry = DateTime.utc(2030, 1, 1);

  @override
  Future<BinaryArtifact> requestQr() async => const BinaryArtifact(
    sourceKind: BinaryArtifactKind.qrText,
    source: BinaryArtifactSource.text('x'),
    suggestedFileNameBase: 'familia-numerosa',
    originEndpoint: '/carnet-digital/qr/{dni}',
  );

  @override
  Future<BinaryArtifact> requestPdf() async => requestQr();

  @override
  Future<BinaryArtifact> requestPkpass() async => requestQr();
}

Future<void> _pump(final WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        familiaNumerosaRepositoryProvider.overrideWithValue(
          const _GoldenRepo(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: const FamiliaNumerosaDetailPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('FamiliaNumerosaDetailPage golden — phone portrait', (
    final tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(tester);
    await expectLater(
      find.byType(FamiliaNumerosaDetailPage),
      matchesGoldenFile('familia_numerosa_detail_phone_portrait.png'),
    );
  });
}
