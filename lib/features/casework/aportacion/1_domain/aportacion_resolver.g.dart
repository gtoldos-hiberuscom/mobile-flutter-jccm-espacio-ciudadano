// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aportacion_resolver.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [AportacionResolver]. Tests override this provider
/// to inject deterministic repository responses.

@ProviderFor(aportacionResolver)
const aportacionResolverProvider = AportacionResolverProvider._();

/// DI composition for [AportacionResolver]. Tests override this provider
/// to inject deterministic repository responses.

final class AportacionResolverProvider
    extends
        $FunctionalProvider<
          AportacionResolver,
          AportacionResolver,
          AportacionResolver
        >
    with $Provider<AportacionResolver> {
  /// DI composition for [AportacionResolver]. Tests override this provider
  /// to inject deterministic repository responses.
  const AportacionResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aportacionResolverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aportacionResolverHash();

  @$internal
  @override
  $ProviderElement<AportacionResolver> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AportacionResolver create(Ref ref) {
    return aportacionResolver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AportacionResolver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AportacionResolver>(value),
    );
  }
}

String _$aportacionResolverHash() =>
    r'a974ffb3c744f870dd37704345ffca1b8af7dbb6';
