// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_affairs_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [StateAffairsRepository].
///
/// Not kept alive on purpose — the snapshot is expected to refresh
/// whenever the user re-enters the landing (canon §16).

@ProviderFor(stateAffairsRepository)
const stateAffairsRepositoryProvider = StateAffairsRepositoryProvider._();

/// DI composition for [StateAffairsRepository].
///
/// Not kept alive on purpose — the snapshot is expected to refresh
/// whenever the user re-enters the landing (canon §16).

final class StateAffairsRepositoryProvider
    extends
        $FunctionalProvider<
          StateAffairsRepository,
          StateAffairsRepository,
          StateAffairsRepository
        >
    with $Provider<StateAffairsRepository> {
  /// DI composition for [StateAffairsRepository].
  ///
  /// Not kept alive on purpose — the snapshot is expected to refresh
  /// whenever the user re-enters the landing (canon §16).
  const StateAffairsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stateAffairsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stateAffairsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StateAffairsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StateAffairsRepository create(Ref ref) {
    return stateAffairsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StateAffairsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StateAffairsRepository>(value),
    );
  }
}

String _$stateAffairsRepositoryHash() =>
    r'2c2184a3dc1fe5bdf9ca7fa25ffda941a5158d55';
