import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/wallet_capability.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/digital_cards_exporter_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_action_controller.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_runtime_platform.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/3_data/digital_cards_exporter_repository_provider.dart';

class _FakeRepo implements DigitalCardsExporterRepository {
  _FakeRepo({this.appleOk = false});

  bool appleOk;
  bool openOk = true;
  bool shareOk = true;

  int writeCount = 0;
  int appleCount = 0;
  int openCount = 0;
  int shareCount = 0;
  int sweepCount = 0;
  String? lastFileName;

  @override
  Future<File> writeToTemp({
    required final List<int> bytes,
    required final String fileName,
  }) async {
    writeCount++;
    lastFileName = fileName;
    final dir = await Directory.systemTemp.createTemp('walletctrl_');
    final f = File('${dir.path}${Platform.pathSeparator}$fileName');
    await f.writeAsBytes(bytes, flush: true);
    return f;
  }

  @override
  Future<bool> openExternal(
    final File file, {
    final BinaryArtifactKind? kind,
  }) async {
    openCount++;
    return openOk;
  }

  @override
  Future<bool> share(final File file, {final String? subject}) async {
    shareCount++;
    return shareOk;
  }

  @override
  Future<bool> addToAppleWallet(final File pkpass) async {
    appleCount++;
    return appleOk;
  }

  @override
  Future<int> sweepTempCacheOlderThan(final Duration age) async {
    sweepCount++;
    return 0;
  }
}

Uint8List _validPdfBytes() {
  final out = Uint8List(2048);
  const head = <int>[0x25, 0x50, 0x44, 0x46, 0x2D];
  for (var i = 0; i < head.length; i++) {
    out[i] = head[i];
  }
  return out;
}

Uint8List _validPkpassBytes() {
  final builder = BytesBuilder()
    ..add(<int>[0x50, 0x4B, 0x03, 0x04])
    ..add(List<int>.filled(2048, 0x20))
    ..add('pass.json'.codeUnits)
    ..add(List<int>.filled(2048, 0x20));
  return builder.toBytes();
}

ProviderContainer _container({
  required final _FakeRepo repo,
  required final WalletRuntimePlatform platform,
}) => ProviderContainer(
  overrides: [
    digitalCardsExporterRepositoryProvider.overrideWithValue(repo),
    walletRuntimePlatformProvider.overrideWith((final _) => platform),
  ],
);

void main() {
  group('WalletActionController.persistAndAct', () {
    test('PDF happy path → openExternal capability used', () async {
      final repo = _FakeRepo();
      final container = _container(
        repo: repo,
        platform: WalletRuntimePlatform.android,
      );
      addTearDown(container.dispose);

      final result = await container
          .read(walletActionControllerProvider.notifier)
          .persistAndAct(
            artifact: BinaryArtifact(
              sourceKind: BinaryArtifactKind.pdf,
              source: BinaryArtifactSource.bytes(_validPdfBytes()),
              suggestedFileNameBase: 'familia-numerosa',
              originEndpoint: '/carnet-digital/pdf/x',
            ),
            dniHashSeed: '12345678Z',
            requested: <WalletCapability>{
              WalletCapability.openExternal,
              WalletCapability.shareFallback,
            },
            clock: DateTime.utc(2026, 4, 21),
          );

      expect(result.success, isTrue);
      expect(result.capabilityUsed, WalletCapability.openExternal);
      expect(repo.writeCount, 1);
      expect(repo.openCount, 1);
      expect(repo.shareCount, 0);
      expect(repo.lastFileName, startsWith('familia-numerosa-pdf-'));
    });

    test(
      'PKPass on iOS with successful Apple Wallet → appleWallet capability',
      () async {
        final repo = _FakeRepo(appleOk: true);
        final container = _container(
          repo: repo,
          platform: WalletRuntimePlatform.ios,
        );
        addTearDown(container.dispose);

        final result = await container
            .read(walletActionControllerProvider.notifier)
            .persistAndAct(
              artifact: BinaryArtifact(
                sourceKind: BinaryArtifactKind.pkpass,
                source: BinaryArtifactSource.bytes(_validPkpassBytes()),
                suggestedFileNameBase: 'familia-numerosa',
                originEndpoint: '/carnet-digital/familia-numerosa-pkpass/x',
              ),
              dniHashSeed: '12345678Z',
              requested: <WalletCapability>{
                WalletCapability.appleWallet,
                WalletCapability.shareFallback,
              },
              clock: DateTime.utc(2026, 4, 21),
            );

        expect(result.success, isTrue);
        expect(result.capabilityUsed, WalletCapability.appleWallet);
        expect(repo.appleCount, 1);
        expect(repo.shareCount, 0);
      },
    );

    test('PKPass on Android falls back to share', () async {
      final repo = _FakeRepo();
      final container = _container(
        repo: repo,
        platform: WalletRuntimePlatform.android,
      );
      addTearDown(container.dispose);

      final result = await container
          .read(walletActionControllerProvider.notifier)
          .persistAndAct(
            artifact: BinaryArtifact(
              sourceKind: BinaryArtifactKind.pkpass,
              source: BinaryArtifactSource.bytes(_validPkpassBytes()),
              suggestedFileNameBase: 'familia-numerosa',
              originEndpoint: '/carnet-digital/familia-numerosa-pkpass/x',
            ),
            dniHashSeed: '12345678Z',
            requested: <WalletCapability>{
              WalletCapability.appleWallet,
              WalletCapability.shareFallback,
            },
            clock: DateTime.utc(2026, 4, 21),
          );

      expect(result.success, isTrue);
      expect(result.capabilityUsed, WalletCapability.shareFallback);
      expect(repo.appleCount, 0); // not invoked: not iOS
      expect(repo.shareCount, 1);
    });

    test(
      'PKPass on iOS where Apple Wallet refuses → falls back to share',
      () async {
        final repo = _FakeRepo();
        final container = _container(
          repo: repo,
          platform: WalletRuntimePlatform.ios,
        );
        addTearDown(container.dispose);

        final result = await container
            .read(walletActionControllerProvider.notifier)
            .persistAndAct(
              artifact: BinaryArtifact(
                sourceKind: BinaryArtifactKind.pkpass,
                source: BinaryArtifactSource.bytes(_validPkpassBytes()),
                suggestedFileNameBase: 'familia-numerosa',
                originEndpoint: '/carnet-digital/familia-numerosa-pkpass/x',
              ),
              dniHashSeed: '12345678Z',
              requested: <WalletCapability>{
                WalletCapability.appleWallet,
                WalletCapability.shareFallback,
              },
              clock: DateTime.utc(2026, 4, 21),
            );

        expect(result.success, isTrue);
        expect(result.capabilityUsed, WalletCapability.shareFallback);
        expect(repo.appleCount, 1);
        expect(repo.shareCount, 1);
      },
    );

    test(
      'invalid magic short-circuits with errorMessage and persistedPath null',
      () async {
        final repo = _FakeRepo();
        final container = _container(
          repo: repo,
          platform: WalletRuntimePlatform.android,
        );
        addTearDown(container.dispose);

        final result = await container
            .read(walletActionControllerProvider.notifier)
            .persistAndAct(
              artifact: BinaryArtifact(
                sourceKind: BinaryArtifactKind.pdf,
                source: BinaryArtifactSource.bytes(
                  Uint8List.fromList(<int>[0, 0, 0, 0, 0]),
                ),
                suggestedFileNameBase: 'joven',
                originEndpoint: '/carnet-digital/pdf/x',
              ),
              dniHashSeed: '12345678Z',
              requested: <WalletCapability>{WalletCapability.openExternal},
              clock: DateTime.utc(2026, 4, 21),
            );

        expect(result.success, isFalse);
        expect(
          result.validationFailure,
          BinaryArtifactValidationFailure.invalidMagic,
        );
        expect(result.errorMessage, isNotNull);
        expect(result.persistedPath, isNull);
        expect(repo.writeCount, 0);
        expect(repo.openCount, 0);
      },
    );

    test('no capability matches → walletErrorNoCapability', () async {
      final repo = _FakeRepo();
      final container = _container(
        repo: repo,
        platform: WalletRuntimePlatform.android,
      );
      addTearDown(container.dispose);

      final result = await container
          .read(walletActionControllerProvider.notifier)
          .persistAndAct(
            artifact: BinaryArtifact(
              sourceKind: BinaryArtifactKind.pkpass,
              source: BinaryArtifactSource.bytes(_validPkpassBytes()),
              suggestedFileNameBase: 'familia-numerosa',
              originEndpoint: '/carnet-digital/familia-numerosa-pkpass/x',
            ),
            dniHashSeed: '12345678Z',
            requested: const <WalletCapability>{}, // intentionally empty
            clock: DateTime.utc(2026, 4, 21),
          );

      expect(result.success, isFalse);
      expect(result.errorMessage, 'walletErrorNoCapability');
    });
  });
}
