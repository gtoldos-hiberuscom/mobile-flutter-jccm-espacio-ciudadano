// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casework_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [CaseworkRepository].

@ProviderFor(caseworkRepository)
const caseworkRepositoryProvider = CaseworkRepositoryProvider._();

/// DI composition for [CaseworkRepository].

final class CaseworkRepositoryProvider
    extends
        $FunctionalProvider<
          CaseworkRepository,
          CaseworkRepository,
          CaseworkRepository
        >
    with $Provider<CaseworkRepository> {
  /// DI composition for [CaseworkRepository].
  const CaseworkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caseworkRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caseworkRepositoryHash();

  @$internal
  @override
  $ProviderElement<CaseworkRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CaseworkRepository create(Ref ref) {
    return caseworkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CaseworkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CaseworkRepository>(value),
    );
  }
}

String _$caseworkRepositoryHash() =>
    r'8938dbaaa2303ae659abf99b2d08ba9616eb6e16';
