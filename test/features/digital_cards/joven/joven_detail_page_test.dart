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
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/2_presentation/joven_detail_page.dart';
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

class _UnavailableRepository implements JovenRepository {
  @override
  Future<JovenCard> loadCard() async => throw const JovenUnavailable('no_card');

  @override
  Future<BinaryArtifact> requestQr() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPdf() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPkpass() async => throw UnimplementedError();
}

Widget _wrap(final Widget child, {required final JovenRepository repo}) => ProviderScope(
  overrides: [
    jovenRepositoryProvider.overrideWithValue(repo),
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
  testWidgets('JovenDetailPage renders title, codigo and action bars', (final tester) async {
    final card = JovenCard(
      id: 'card-1',
      holderName: 'Lucía Fernández Ruiz',
      codigo: 'CJ-2025-088771',
      status: DigitalCardStatus.available,
      expiryDate: DateTime(2027, 10, 22),
    );

    await tester.pumpWidget(_wrap(const JovenDetailPage(), repo: _FakeRepository(card)));
    await tester.pumpAndSettle();

    // AppBar title (Spanish).
    expect(find.text('Carnet Joven'), findsWidgets);
    // Codigo row rendered.
    expect(find.textContaining('CJ-2025-088771'), findsOneWidget);
    // Three format action bars present.
    expect(find.byKey(const ValueKey('jovenActionBar-qr')), findsOneWidget);
    expect(find.byKey(const ValueKey('jovenActionBar-pdf')), findsOneWidget);
    expect(find.byKey(const ValueKey('jovenActionBar-pkpass')), findsOneWidget);
  });

  testWidgets('JovenDetailPage renders the unavailable surface on JovenUnavailable', (final tester) async {
    await tester.pumpWidget(_wrap(const JovenDetailPage(), repo: _UnavailableRepository()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('jovenUnavailableBody')), findsOneWidget);
    // No action bars rendered when unavailable.
    expect(find.byKey(const ValueKey('jovenActionBar-qr')), findsNothing);
  });
}
