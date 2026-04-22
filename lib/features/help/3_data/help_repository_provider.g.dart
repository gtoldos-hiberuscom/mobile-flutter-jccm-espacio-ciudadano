// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [HelpRepository] implementation.
///
/// Content is entirely bundled — no I/O occurs on creation.
/// Auto-disposes when no help page is open.

@ProviderFor(helpRepository)
const helpRepositoryProvider = HelpRepositoryProvider._();

/// Provides the singleton [HelpRepository] implementation.
///
/// Content is entirely bundled — no I/O occurs on creation.
/// Auto-disposes when no help page is open.

final class HelpRepositoryProvider
    extends
        $FunctionalProvider<HelpRepository, HelpRepository, HelpRepository>
    with $Provider<HelpRepository> {
  /// Provides the singleton [HelpRepository] implementation.
  ///
  /// Content is entirely bundled — no I/O occurs on creation.
  /// Auto-disposes when no help page is open.
  const HelpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helpRepositoryProvider',
        isAutoDispose: true,
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

String _$helpRepositoryHash() => r'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0';
