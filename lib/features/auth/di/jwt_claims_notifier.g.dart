// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_claims_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JwtClaimsNotifier)
const jwtClaimsProvider = JwtClaimsNotifierProvider._();

final class JwtClaimsNotifierProvider extends $NotifierProvider<JwtClaimsNotifier, JwtClaims?> {
  const JwtClaimsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jwtClaimsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jwtClaimsNotifierHash();

  @$internal
  @override
  JwtClaimsNotifier create() => JwtClaimsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JwtClaims? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JwtClaims?>(value),
    );
  }
}

String _$jwtClaimsNotifierHash() => r'fefc0a5f53f40c92d691edfe143768fd77c02b55';

abstract class _$JwtClaimsNotifier extends $Notifier<JwtClaims?> {
  JwtClaims? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JwtClaims?, JwtClaims?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<JwtClaims?, JwtClaims?>, JwtClaims?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
