// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_runtime_platform.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walletRuntimePlatform)
const walletRuntimePlatformProvider = WalletRuntimePlatformProvider._();

final class WalletRuntimePlatformProvider
    extends
        $FunctionalProvider<
          WalletRuntimePlatform,
          WalletRuntimePlatform,
          WalletRuntimePlatform
        >
    with $Provider<WalletRuntimePlatform> {
  const WalletRuntimePlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletRuntimePlatformProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletRuntimePlatformHash();

  @$internal
  @override
  $ProviderElement<WalletRuntimePlatform> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WalletRuntimePlatform create(Ref ref) {
    return walletRuntimePlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletRuntimePlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletRuntimePlatform>(value),
    );
  }
}

String _$walletRuntimePlatformHash() =>
    r'cca0736cac31bfe141b9f4c16746f0114f1e5339';
