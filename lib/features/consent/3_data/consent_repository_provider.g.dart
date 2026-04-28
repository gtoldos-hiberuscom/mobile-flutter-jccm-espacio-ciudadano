// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [ConsentRepository] implementation.
///
/// Kept alive for the full app lifetime so the consent lifecycle is always
/// available without re-creating the notifier on navigation changes.

@ProviderFor(consentRepository)
const consentRepositoryProvider = ConsentRepositoryProvider._();

/// Provides the singleton [ConsentRepository] implementation.
///
/// Kept alive for the full app lifetime so the consent lifecycle is always
/// available without re-creating the notifier on navigation changes.

final class ConsentRepositoryProvider
    extends
        $FunctionalProvider<
          ConsentRepository,
          ConsentRepository,
          ConsentRepository
        >
    with $Provider<ConsentRepository> {
  /// Provides the singleton [ConsentRepository] implementation.
  ///
  /// Kept alive for the full app lifetime so the consent lifecycle is always
  /// available without re-creating the notifier on navigation changes.
  const ConsentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConsentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConsentRepository create(Ref ref) {
    return consentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsentRepository>(value),
    );
  }
}

String _$consentRepositoryHash() => r'bfe0683dfe26ebf40fc9f44084aa90f5806cc475';
