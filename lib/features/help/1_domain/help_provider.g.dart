// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for the help-center repository.
///
/// `keepAlive: true` because the content is immutable and reused by both
/// the help page and (potentially) the sitemap entry.

@ProviderFor(helpRepository)
const helpRepositoryProvider = HelpRepositoryProvider._();

/// DI composition for the help-center repository.
///
/// `keepAlive: true` because the content is immutable and reused by both
/// the help page and (potentially) the sitemap entry.

final class HelpRepositoryProvider
    extends $FunctionalProvider<HelpRepository, HelpRepository, HelpRepository>
    with $Provider<HelpRepository> {
  /// DI composition for the help-center repository.
  ///
  /// `keepAlive: true` because the content is immutable and reused by both
  /// the help page and (potentially) the sitemap entry.
  const HelpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helpRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$helpRepositoryHash();

  @$internal
  @override
  $ProviderElement<HelpRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HelpRepository create(Ref ref) {
    return helpRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HelpRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HelpRepository>(value),
    );
  }
}

String _$helpRepositoryHash() => r'ff8007fe1c1c6c5811cf61394abc67b769a2e20c';

/// Synchronous provider exposing the help-center [HelpContent].

@ProviderFor(helpContent)
const helpContentProvider = HelpContentProvider._();

/// Synchronous provider exposing the help-center [HelpContent].

final class HelpContentProvider
    extends $FunctionalProvider<HelpContent, HelpContent, HelpContent>
    with $Provider<HelpContent> {
  /// Synchronous provider exposing the help-center [HelpContent].
  const HelpContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helpContentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$helpContentHash();

  @$internal
  @override
  $ProviderElement<HelpContent> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HelpContent create(Ref ref) {
    return helpContent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HelpContent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HelpContent>(value),
    );
  }
}

String _$helpContentHash() => r'e218ae02e3c2432704ad345b237c9439d916c10a';
