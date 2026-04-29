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
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/2_presentation/widgets/familia_numerosa_member_tile.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _FakeRepository implements FamiliaNumerosaRepository {
  _FakeRepository(this._card);

  final FamiliaNumerosaCard _card;

  @override
  Future<FamiliaNumerosaCard> loadCard() async => _card;

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

Widget _wrap(final Widget child, {required final FamiliaNumerosaRepository repo}) => ProviderScope(
  overrides: [
    familiaNumerosaRepositoryProvider.overrideWithValue(repo),
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
    home: child,
  ),
);

void main() {
  testWidgets('FamiliaNumerosaDetailPage renders title, members and action bars', (final tester) async {
    final card = FamiliaNumerosaCard(
      id: 'card-1',
      holderName: 'María García López',
      cardNumber: 'FN-0451-78',
      categoria: FamiliaNumerosaCategoria.especial,
      status: DigitalCardStatus.available,
      expiryDate: DateTime(2027, 10, 22),
      members: const <FamiliaNumerosaMember>[
        FamiliaNumerosaMember(name: 'María García López', parentesco: 'titular', dni: '00000000T'),
        FamiliaNumerosaMember(name: 'Javier Martínez Ruiz', parentesco: 'conyuge', dni: '00000000R'),
        FamiliaNumerosaMember(name: 'Lucía Martínez García', parentesco: 'hija'),
        FamiliaNumerosaMember(name: 'Mateo Martínez García', parentesco: 'hijo'),
      ],
    );

    await tester.pumpWidget(_wrap(const FamiliaNumerosaDetailPage(), repo: _FakeRepository(card)));
    await tester.pumpAndSettle();

    // AppBar title (Spanish).
    expect(find.text('Carnet de familia numerosa'), findsOneWidget);
    // 4 members rendered.
    expect(find.byType(FamiliaNumerosaMemberTile), findsNWidgets(4));
    // Three format action bars present.
    expect(find.byKey(const ValueKey('familiaNumerosaActionBar-qr')), findsOneWidget);
    expect(find.byKey(const ValueKey('familiaNumerosaActionBar-pdf')), findsOneWidget);
    expect(find.byKey(const ValueKey('familiaNumerosaActionBar-pkpass')), findsOneWidget);
  });

  testWidgets('FamiliaNumerosaDetailPage renders the unavailable surface on FamiliaNumerosaUnavailable', (final tester) async {
    await tester.pumpWidget(_wrap(const FamiliaNumerosaDetailPage(), repo: _UnavailableRepository()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('familiaNumerosaUnavailableBody')), findsOneWidget);
    // No action bars rendered when unavailable.
    expect(find.byKey(const ValueKey('familiaNumerosaActionBar-qr')), findsNothing);
  });
}

class _UnavailableRepository implements FamiliaNumerosaRepository {
  @override
  Future<FamiliaNumerosaCard> loadCard() async => throw const FamiliaNumerosaUnavailable('no_card');

  @override
  Future<BinaryArtifact> requestQr() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPdf() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPkpass() async => throw UnimplementedError();
}
