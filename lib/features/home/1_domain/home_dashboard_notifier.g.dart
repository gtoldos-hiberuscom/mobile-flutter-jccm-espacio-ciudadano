// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod [AsyncNotifier] that owns the authenticated home dashboard state.
///
/// ## Lifecycle
/// - On `build()`, asks the home dashboard repository for a snapshot and
///   exposes it as `AsyncValue.data`.
/// - The repository encodes per-block load outcomes inside the snapshot so
///   one failing block never causes the whole notifier to enter
///   `AsyncValue.error` (canon §16, partial-error tolerance).
///
/// ## Why not keepAlive?
/// The home dashboard should rebuild on each navigation back to it so
/// timestamps and counters stay fresh — `keepAlive: false` (the default
/// from `@riverpod`) is exactly the right semantic here.

@ProviderFor(HomeDashboardNotifier)
const homeDashboardProvider = HomeDashboardNotifierProvider._();

/// Riverpod [AsyncNotifier] that owns the authenticated home dashboard state.
///
/// ## Lifecycle
/// - On `build()`, asks the home dashboard repository for a snapshot and
///   exposes it as `AsyncValue.data`.
/// - The repository encodes per-block load outcomes inside the snapshot so
///   one failing block never causes the whole notifier to enter
///   `AsyncValue.error` (canon §16, partial-error tolerance).
///
/// ## Why not keepAlive?
/// The home dashboard should rebuild on each navigation back to it so
/// timestamps and counters stay fresh — `keepAlive: false` (the default
/// from `@riverpod`) is exactly the right semantic here.
final class HomeDashboardNotifierProvider
    extends
        $AsyncNotifierProvider<HomeDashboardNotifier, HomeDashboardSnapshot> {
  /// Riverpod [AsyncNotifier] that owns the authenticated home dashboard state.
  ///
  /// ## Lifecycle
  /// - On `build()`, asks the home dashboard repository for a snapshot and
  ///   exposes it as `AsyncValue.data`.
  /// - The repository encodes per-block load outcomes inside the snapshot so
  ///   one failing block never causes the whole notifier to enter
  ///   `AsyncValue.error` (canon §16, partial-error tolerance).
  ///
  /// ## Why not keepAlive?
  /// The home dashboard should rebuild on each navigation back to it so
  /// timestamps and counters stay fresh — `keepAlive: false` (the default
  /// from `@riverpod`) is exactly the right semantic here.
  const HomeDashboardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDashboardNotifierHash();

  @$internal
  @override
  HomeDashboardNotifier create() => HomeDashboardNotifier();
}

String _$homeDashboardNotifierHash() =>
    r'a5373a501633e3b3f9d1df45a6e14bc843e80440';

/// Riverpod [AsyncNotifier] that owns the authenticated home dashboard state.
///
/// ## Lifecycle
/// - On `build()`, asks the home dashboard repository for a snapshot and
///   exposes it as `AsyncValue.data`.
/// - The repository encodes per-block load outcomes inside the snapshot so
///   one failing block never causes the whole notifier to enter
///   `AsyncValue.error` (canon §16, partial-error tolerance).
///
/// ## Why not keepAlive?
/// The home dashboard should rebuild on each navigation back to it so
/// timestamps and counters stay fresh — `keepAlive: false` (the default
/// from `@riverpod`) is exactly the right semantic here.

abstract class _$HomeDashboardNotifier
    extends $AsyncNotifier<HomeDashboardSnapshot> {
  FutureOr<HomeDashboardSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<HomeDashboardSnapshot>, HomeDashboardSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<HomeDashboardSnapshot>,
                HomeDashboardSnapshot
              >,
              AsyncValue<HomeDashboardSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
