/// Digital cards exporters (EPIC-7 / STORY-52) — domain.
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/wallet_capability.dart';

/// Pure value object describing the outcome of a wallet action chain.
///
/// `success` is `true` when at least one capability handled the artifact
/// (open, share or add-to-wallet). `capabilityUsed` records which one;
/// `errorMessage` is a stable slug suitable for presentation lookup, or
/// `null` on success. `validationFailure` is set when the pipeline aborted
/// before reaching the platform layer.
final class WalletActionResult {
  const WalletActionResult({
    required this.success,
    this.capabilityUsed,
    this.errorMessage,
    this.persistedPath,
    this.validationFailure,
  });

  /// Convenience constructor for successful operations.
  const WalletActionResult.success({
    required final WalletCapability capability,
    required final String persistedPath,
  }) : this(
         success: true,
         capabilityUsed: capability,
         persistedPath: persistedPath,
       );

  /// Convenience constructor for validation rejections.
  const WalletActionResult.validation(
    final BinaryArtifactValidationFailure failure,
  ) : this(
         success: false,
         validationFailure: failure,
         errorMessage: 'walletErrorInvalidArtifact',
       );

  /// Convenience constructor for runtime failures (IO, no capability matched).
  const WalletActionResult.failure(final String message)
    : this(success: false, errorMessage: message);

  final bool success;
  final WalletCapability? capabilityUsed;
  final String? errorMessage;
  final String? persistedPath;
  final BinaryArtifactValidationFailure? validationFailure;
}
