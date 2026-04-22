// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [LegalRepository] implementation.
///
/// Content is entirely bundled — no I/O occurs on creation.
/// `keepAlive` defaults to `false`; the provider auto-disposes when no
/// legal page is open, which is the expected behaviour for static pages.

@ProviderFor(legalRepository)
const legalRepositoryProvider = LegalRepositoryProvider._();

/// Provides the singleton [LegalRepository] implementation.
///
/// Content is entirely bundled — no I/O occurs on creation.
/// `keepAlive` defaults to `false`; the provider auto-disposes when no
/// legal page is open, which is the expected behaviour for static pages.

final class LegalRepositoryProvider
    extends
        $FunctionalProvider<LegalRepository, LegalRepository, LegalRepository>
    with $Provider<LegalRepository> {
  /// Provides the singleton [LegalRepository] implementation.
  ///
  /// Content is entirely bundled — no I/O occurs on creation.
  /// `keepAlive` defaults to `false`; the provider auto-disposes when no
  /// legal page is open, which is the expected behaviour for static pages.
  const LegalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'legalRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$legalRepositoryHash();

  @$internal
  @override
  $ProviderElement<LegalRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LegalRepository create(Ref ref) {
    return legalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LegalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LegalRepository>(value),
    );
  }
}

String _$legalRepositoryHash() => r'95c3ab5daa8f3ba8ded8282058556918550e2544';
