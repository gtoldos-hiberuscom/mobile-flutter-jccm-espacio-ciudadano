// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casework_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the casework search screen state (STORY-39).
///
/// Validation lives in `0_entity/CaseworkSearchQuery` (pure Dart). The
/// notifier is a thin coordinator that:
///   - keeps the form inputs in sync,
///   - re-validates on every change,
///   - executes the right repository call when the query is valid,
///   - exposes `idle | searching | results | noResults | error` to the UI.

@ProviderFor(CaseworkSearchNotifier)
const caseworkSearchProvider = CaseworkSearchNotifierProvider._();

/// Owns the casework search screen state (STORY-39).
///
/// Validation lives in `0_entity/CaseworkSearchQuery` (pure Dart). The
/// notifier is a thin coordinator that:
///   - keeps the form inputs in sync,
///   - re-validates on every change,
///   - executes the right repository call when the query is valid,
///   - exposes `idle | searching | results | noResults | error` to the UI.
final class CaseworkSearchNotifierProvider extends $NotifierProvider<CaseworkSearchNotifier, CaseworkSearchState> {
  /// Owns the casework search screen state (STORY-39).
  ///
  /// Validation lives in `0_entity/CaseworkSearchQuery` (pure Dart). The
  /// notifier is a thin coordinator that:
  ///   - keeps the form inputs in sync,
  ///   - re-validates on every change,
  ///   - executes the right repository call when the query is valid,
  ///   - exposes `idle | searching | results | noResults | error` to the UI.
  const CaseworkSearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caseworkSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caseworkSearchNotifierHash();

  @$internal
  @override
  CaseworkSearchNotifier create() => CaseworkSearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CaseworkSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CaseworkSearchState>(value),
    );
  }
}

String _$caseworkSearchNotifierHash() => r'288616d31668fbc18a3dd37e8222eca17a3dccc1';

/// Owns the casework search screen state (STORY-39).
///
/// Validation lives in `0_entity/CaseworkSearchQuery` (pure Dart). The
/// notifier is a thin coordinator that:
///   - keeps the form inputs in sync,
///   - re-validates on every change,
///   - executes the right repository call when the query is valid,
///   - exposes `idle | searching | results | noResults | error` to the UI.

abstract class _$CaseworkSearchNotifier extends $Notifier<CaseworkSearchState> {
  CaseworkSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CaseworkSearchState, CaseworkSearchState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<CaseworkSearchState, CaseworkSearchState>, CaseworkSearchState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
