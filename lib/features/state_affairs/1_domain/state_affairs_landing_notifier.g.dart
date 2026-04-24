// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_affairs_landing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the Estado y otros temas de interés landing state (STORY-26).
///
/// Loads a [StateAffairsSnapshot] from the repository on `build()` and
/// exposes a [refresh] hook for `RefreshIndicator`. Per-section status
/// is encoded in the snapshot itself, so individual UI cards can render
/// loading / empty / error independently.

@ProviderFor(StateAffairsLandingNotifier)
const stateAffairsLandingProvider = StateAffairsLandingNotifierProvider._();

/// Owns the Estado y otros temas de interés landing state (STORY-26).
///
/// Loads a [StateAffairsSnapshot] from the repository on `build()` and
/// exposes a [refresh] hook for `RefreshIndicator`. Per-section status
/// is encoded in the snapshot itself, so individual UI cards can render
/// loading / empty / error independently.
final class StateAffairsLandingNotifierProvider extends $AsyncNotifierProvider<StateAffairsLandingNotifier, StateAffairsSnapshot> {
  /// Owns the Estado y otros temas de interés landing state (STORY-26).
  ///
  /// Loads a [StateAffairsSnapshot] from the repository on `build()` and
  /// exposes a [refresh] hook for `RefreshIndicator`. Per-section status
  /// is encoded in the snapshot itself, so individual UI cards can render
  /// loading / empty / error independently.
  const StateAffairsLandingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stateAffairsLandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stateAffairsLandingNotifierHash();

  @$internal
  @override
  StateAffairsLandingNotifier create() => StateAffairsLandingNotifier();
}

String _$stateAffairsLandingNotifierHash() => r'8aebe389e47ed106ced966fc8c4f2bcdd15dd3b2';

/// Owns the Estado y otros temas de interés landing state (STORY-26).
///
/// Loads a [StateAffairsSnapshot] from the repository on `build()` and
/// exposes a [refresh] hook for `RefreshIndicator`. Per-section status
/// is encoded in the snapshot itself, so individual UI cards can render
/// loading / empty / error independently.

abstract class _$StateAffairsLandingNotifier extends $AsyncNotifier<StateAffairsSnapshot> {
  FutureOr<StateAffairsSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<StateAffairsSnapshot>, StateAffairsSnapshot>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<StateAffairsSnapshot>, StateAffairsSnapshot>, AsyncValue<StateAffairsSnapshot>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
