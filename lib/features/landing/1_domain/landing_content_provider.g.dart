// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing_content_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the static [LandingContent] for the public landing screen.
///
/// Content is hardcoded for this sprint — no network call is required.
/// `keepAlive` defaults to `false` so the provider is disposed when no longer
/// watched, which is acceptable for a screen-level provider.

@ProviderFor(landingContent)
const landingContentProvider = LandingContentProvider._();

/// Provides the static [LandingContent] for the public landing screen.
///
/// Content is hardcoded for this sprint — no network call is required.
/// `keepAlive` defaults to `false` so the provider is disposed when no longer
/// watched, which is acceptable for a screen-level provider.

final class LandingContentProvider
    extends $FunctionalProvider<LandingContent, LandingContent, LandingContent>
    with $Provider<LandingContent> {
  /// Provides the static [LandingContent] for the public landing screen.
  ///
  /// Content is hardcoded for this sprint — no network call is required.
  /// `keepAlive` defaults to `false` so the provider is disposed when no longer
  /// watched, which is acceptable for a screen-level provider.
  const LandingContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'landingContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$landingContentHash();

  @$internal
  @override
  $ProviderElement<LandingContent> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LandingContent create(Ref ref) {
    return landingContent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LandingContent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LandingContent>(value),
    );
  }
}

String _$landingContentHash() => r'3a849fc4ebebe19a1baf41d2c5a06b6e3595f279';
