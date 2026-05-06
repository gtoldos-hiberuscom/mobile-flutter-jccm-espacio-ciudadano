// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_links_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the application-wide [ExternalLinkCatalog] (allow-list of
/// outbound destinations).
///
/// `keepAlive: true` because the catalog is immutable and reused from
/// many places (home dashboard, landings, sitemap). The DI composition
/// happens here — presentation widgets must not import the
/// `3_data/` implementation directly (canon §13).

@ProviderFor(externalLinkCatalog)
const externalLinkCatalogProvider = ExternalLinkCatalogProvider._();

/// Provides the application-wide [ExternalLinkCatalog] (allow-list of
/// outbound destinations).
///
/// `keepAlive: true` because the catalog is immutable and reused from
/// many places (home dashboard, landings, sitemap). The DI composition
/// happens here — presentation widgets must not import the
/// `3_data/` implementation directly (canon §13).

final class ExternalLinkCatalogProvider extends $FunctionalProvider<ExternalLinkCatalog, ExternalLinkCatalog, ExternalLinkCatalog> with $Provider<ExternalLinkCatalog> {
  /// Provides the application-wide [ExternalLinkCatalog] (allow-list of
  /// outbound destinations).
  ///
  /// `keepAlive: true` because the catalog is immutable and reused from
  /// many places (home dashboard, landings, sitemap). The DI composition
  /// happens here — presentation widgets must not import the
  /// `3_data/` implementation directly (canon §13).
  const ExternalLinkCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'externalLinkCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$externalLinkCatalogHash();

  @$internal
  @override
  $ProviderElement<ExternalLinkCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExternalLinkCatalog create(Ref ref) {
    return externalLinkCatalog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExternalLinkCatalog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExternalLinkCatalog>(value),
    );
  }
}

String _$externalLinkCatalogHash() => r'6e5a0b1c86ef059450ac3fa544c5929d5dc6dcf5';

/// Provides the application-wide [ExternalLinkLauncher].
///
/// Tests can override this provider with a fake implementation that does
/// not touch the real `url_launcher` plugin.

@ProviderFor(externalLinkLauncher)
const externalLinkLauncherProvider = ExternalLinkLauncherProvider._();

/// Provides the application-wide [ExternalLinkLauncher].
///
/// Tests can override this provider with a fake implementation that does
/// not touch the real `url_launcher` plugin.

final class ExternalLinkLauncherProvider extends $FunctionalProvider<ExternalLinkLauncher, ExternalLinkLauncher, ExternalLinkLauncher> with $Provider<ExternalLinkLauncher> {
  /// Provides the application-wide [ExternalLinkLauncher].
  ///
  /// Tests can override this provider with a fake implementation that does
  /// not touch the real `url_launcher` plugin.
  const ExternalLinkLauncherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'externalLinkLauncherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$externalLinkLauncherHash();

  @$internal
  @override
  $ProviderElement<ExternalLinkLauncher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExternalLinkLauncher create(Ref ref) {
    return externalLinkLauncher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExternalLinkLauncher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExternalLinkLauncher>(value),
    );
  }
}

String _$externalLinkLauncherHash() => r'add363f02f948bc32da43f49a21fedaa96845711';
