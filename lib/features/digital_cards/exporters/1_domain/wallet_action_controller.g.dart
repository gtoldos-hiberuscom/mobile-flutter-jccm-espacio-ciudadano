// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_action_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(WalletActionController)
const walletActionControllerProvider = WalletActionControllerProvider._();

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
final class WalletActionControllerProvider extends $NotifierProvider<WalletActionController, WalletActionResult?> {
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
  const WalletActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletActionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletActionControllerHash();

  @$internal
  @override
  WalletActionController create() => WalletActionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletActionResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletActionResult?>(value),
    );
  }
}

String _$walletActionControllerHash() => r'52db0855409b6e098546e1073c80c8e45d3d3fc6';

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

abstract class _$WalletActionController extends $Notifier<WalletActionResult?> {
  WalletActionResult? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WalletActionResult?, WalletActionResult?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<WalletActionResult?, WalletActionResult?>, WalletActionResult?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
