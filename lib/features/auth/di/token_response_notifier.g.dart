// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TokenResponseNotifier)
const tokenResponseProvider = TokenResponseNotifierProvider._();

final class TokenResponseNotifierProvider extends $NotifierProvider<TokenResponseNotifier, TokenResponse?> {
  const TokenResponseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenResponseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenResponseNotifierHash();

  @$internal
  @override
  TokenResponseNotifier create() => TokenResponseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenResponse? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenResponse?>(value),
    );
  }
}

String _$tokenResponseNotifierHash() => r'f7862b96ebce4fa34c360f849dcd629867d4e5f7';

abstract class _$TokenResponseNotifier extends $Notifier<TokenResponse?> {
  TokenResponse? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TokenResponse?, TokenResponse?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<TokenResponse?, TokenResponse?>, TokenResponse?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
