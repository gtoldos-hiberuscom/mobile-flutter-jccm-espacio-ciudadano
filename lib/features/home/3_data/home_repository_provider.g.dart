// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [HomeDashboardRepository] implementation.
///
/// Not kept alive on purpose: the repository (and any cached state inside
/// it) is dropped when the home view is no longer in scope — the dashboard
/// is expected to refresh whenever the user navigates back.

@ProviderFor(homeDashboardRepository)
const homeDashboardRepositoryProvider = HomeDashboardRepositoryProvider._();

/// Provides the [HomeDashboardRepository] implementation.
///
/// Not kept alive on purpose: the repository (and any cached state inside
/// it) is dropped when the home view is no longer in scope — the dashboard
/// is expected to refresh whenever the user navigates back.

final class HomeDashboardRepositoryProvider extends $FunctionalProvider<HomeDashboardRepository, HomeDashboardRepository, HomeDashboardRepository> with $Provider<HomeDashboardRepository> {
  /// Provides the [HomeDashboardRepository] implementation.
  ///
  /// Not kept alive on purpose: the repository (and any cached state inside
  /// it) is dropped when the home view is no longer in scope — the dashboard
  /// is expected to refresh whenever the user navigates back.
  const HomeDashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeDashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeDashboardRepository create(Ref ref) {
    return homeDashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeDashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeDashboardRepository>(value),
    );
  }
}

String _$homeDashboardRepositoryHash() => r'4bfed7d80dfafc0bc5dd946162f118499792ec68';
