// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_events_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [LifeEventsRepository].

@ProviderFor(lifeEventsRepository)
const lifeEventsRepositoryProvider = LifeEventsRepositoryProvider._();

/// DI composition for [LifeEventsRepository].

final class LifeEventsRepositoryProvider extends $FunctionalProvider<LifeEventsRepository, LifeEventsRepository, LifeEventsRepository> with $Provider<LifeEventsRepository> {
  /// DI composition for [LifeEventsRepository].
  const LifeEventsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lifeEventsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lifeEventsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LifeEventsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LifeEventsRepository create(Ref ref) {
    return lifeEventsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LifeEventsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LifeEventsRepository>(value),
    );
  }
}

String _$lifeEventsRepositoryHash() => r'1042d64f3a5a20b71df7ae878b3e842d208a95ec';
