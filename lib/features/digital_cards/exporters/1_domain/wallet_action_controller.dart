/// Digital cards exporters (EPIC-7 / STORY-52) — domain.
library;

import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/wallet_capability.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/binary_artifact_resolver.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_action_result.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_runtime_platform.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/3_data/digital_cards_exporter_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_action_controller.g.dart';

/// Owns the cross-cutting wallet pipeline (STORY-52, AC1–AC4).
///
/// `persistAndAct` validates the artifact, persists it to the
/// digital-cards temp cache and runs the platform action chain matching
/// the requested capabilities.
///
/// Kept alive on purpose: the controller holds the last
/// [WalletActionResult] so the presentation layer can react via
/// `ref.listen` after the awaited future resolves, and so async work
/// started from a transiently-listened page does not get torn down
/// mid-flight.
@Riverpod(keepAlive: true)
class WalletActionController extends _$WalletActionController {
  @override
  WalletActionResult? build() => null;

  /// Validates and persists [artifact], then runs the action chain
  /// derived from [requested]. The chain is:
  ///
  /// 1. `appleWallet` for `.pkpass` on iOS — falls through on failure.
  /// 2. `openExternal` for PDF / PNG.
  /// 3. `shareFallback` as the last resort (always available).
  ///
  /// `googleWallet` is reserved for future Sprint 6 work and currently
  /// degrades to `shareFallback` (see TASK-53 / Google Wallet section).
  ///
  /// Returns the [WalletActionResult] and stores it in `state` so the
  /// presentation layer can react via `ref.listen`.
  Future<WalletActionResult> persistAndAct({
    required final BinaryArtifact artifact,
    required final String dniHashSeed,
    required final Set<WalletCapability> requested,
    final DateTime? clock,
  }) async {
    final validation = validateBinaryArtifact(artifact);
    if (validation != null) {
      final result = WalletActionResult.validation(validation);
      state = result;
      return result;
    }

    final repo = ref.read(digitalCardsExporterRepositoryProvider);
    final fileName = deterministicFileName(
      cardKind: artifact.suggestedFileNameBase,
      format: artifact.sourceKind,
      endpoint: artifact.originEndpoint,
      dniHashSeed: dniHashSeed,
      now: clock ?? DateTime.now(),
    );

    final List<int> bytes;
    if (artifact.sourceKind == BinaryArtifactKind.qrText) {
      final text = artifact.tryDecodeText() ?? '';
      bytes = Uint8List.fromList(text.codeUnits);
    } else {
      bytes = artifact.tryDecodeBytes() ?? Uint8List(0);
    }

    WalletActionResult result;
    try {
      final file = await repo.writeToTemp(bytes: bytes, fileName: fileName);

      // Ordered capability chain.
      if (artifact.sourceKind == BinaryArtifactKind.pkpass && requested.contains(WalletCapability.appleWallet) && ref.read(walletRuntimePlatformProvider) == WalletRuntimePlatform.ios) {
        final ok = await repo.addToAppleWallet(file);
        if (ok) {
          final r = WalletActionResult.success(
            capability: WalletCapability.appleWallet,
            persistedPath: file.path,
          );
          state = r;
          return r;
        }
      }

      if (artifact.sourceKind != BinaryArtifactKind.pkpass && requested.contains(WalletCapability.openExternal)) {
        final ok = await repo.openExternal(file, kind: artifact.sourceKind);
        if (ok) {
          final r = WalletActionResult.success(
            capability: WalletCapability.openExternal,
            persistedPath: file.path,
          );
          state = r;
          return r;
        }
      }

      if (requested.contains(WalletCapability.shareFallback) || requested.contains(WalletCapability.googleWallet)) {
        final ok = await repo.share(file);
        if (ok) {
          final r = WalletActionResult.success(
            capability: WalletCapability.shareFallback,
            persistedPath: file.path,
          );
          state = r;
          return r;
        }
      }

      result = const WalletActionResult.failure('walletErrorNoCapability');
    } on Object catch (_) {
      result = const WalletActionResult.failure('walletErrorSystem');
    }
    state = result;
    return result;
  }
}
