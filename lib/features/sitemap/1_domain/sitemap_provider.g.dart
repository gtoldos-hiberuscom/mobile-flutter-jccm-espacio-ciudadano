// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitemap_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the static sitemap entries for the app.
///
/// Content is hardcoded — no network call is required.
/// Auto-disposed when no longer watched.

@ProviderFor(sitemap)
const sitemapProvider = SitemapProvider._();

/// Provides the static sitemap entries for the app.
///
/// Content is hardcoded — no network call is required.
/// Auto-disposed when no longer watched.

final class SitemapProvider
    extends $FunctionalProvider<
      List<SitemapEntry>,
      List<SitemapEntry>,
      List<SitemapEntry>
    >
    with $Provider<List<SitemapEntry>> {
  /// Provides the static sitemap entries for the app.
  ///
  /// Content is hardcoded — no network call is required.
  /// Auto-disposed when no longer watched.
  const SitemapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sitemapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sitemapHash();

  @$internal
  @override
  $ProviderElement<List<SitemapEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<SitemapEntry> create(Ref ref) {
    return sitemap(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SitemapEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SitemapEntry>>(value),
    );
  }
}

String _$sitemapHash() => r'a7c2b91f4d3e8056c149f2e7b3a84d5c10f62e3a';
