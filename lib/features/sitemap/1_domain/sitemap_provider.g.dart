// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitemap_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for the sitemap repository.
///
/// Reads the external-links catalog so the tree's external nodes stay
/// authoritative — STORY-62 must not re-hard-code outbound URLs that
/// already live in `ExternalLinkCatalog` (STORY-28 contract).

@ProviderFor(sitemapRepository)
const sitemapRepositoryProvider = SitemapRepositoryProvider._();

/// DI composition for the sitemap repository.
///
/// Reads the external-links catalog so the tree's external nodes stay
/// authoritative — STORY-62 must not re-hard-code outbound URLs that
/// already live in `ExternalLinkCatalog` (STORY-28 contract).

final class SitemapRepositoryProvider extends $FunctionalProvider<SitemapRepository, SitemapRepository, SitemapRepository> with $Provider<SitemapRepository> {
  /// DI composition for the sitemap repository.
  ///
  /// Reads the external-links catalog so the tree's external nodes stay
  /// authoritative — STORY-62 must not re-hard-code outbound URLs that
  /// already live in `ExternalLinkCatalog` (STORY-28 contract).
  const SitemapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sitemapRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sitemapRepositoryHash();

  @$internal
  @override
  $ProviderElement<SitemapRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SitemapRepository create(Ref ref) {
    return sitemapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SitemapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SitemapRepository>(value),
    );
  }
}

String _$sitemapRepositoryHash() => r'6a40f63ffcfbbb59c735bd27a96fba4cecd84531';
