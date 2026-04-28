// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the application maintenance state.
///
/// Starts as [MaintenanceInactive]. Use [setMaintenance] to activate a
/// maintenance window and [clearMaintenance] to deactivate it.
///
/// Real check deferred to a later sprint.

@ProviderFor(MaintenanceNotifier)
const maintenanceProvider = MaintenanceNotifierProvider._();

/// Manages the application maintenance state.
///
/// Starts as [MaintenanceInactive]. Use [setMaintenance] to activate a
/// maintenance window and [clearMaintenance] to deactivate it.
///
/// Real check deferred to a later sprint.
final class MaintenanceNotifierProvider
    extends $NotifierProvider<MaintenanceNotifier, MaintenanceState> {
  /// Manages the application maintenance state.
  ///
  /// Starts as [MaintenanceInactive]. Use [setMaintenance] to activate a
  /// maintenance window and [clearMaintenance] to deactivate it.
  ///
  /// Real check deferred to a later sprint.
  const MaintenanceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceNotifierHash();

  @$internal
  @override
  MaintenanceNotifier create() => MaintenanceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaintenanceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaintenanceState>(value),
    );
  }
}

String _$maintenanceNotifierHash() =>
    r'70bd3b51ada478df08bcaf09bca368bdafcb8fd4';

/// Manages the application maintenance state.
///
/// Starts as [MaintenanceInactive]. Use [setMaintenance] to activate a
/// maintenance window and [clearMaintenance] to deactivate it.
///
/// Real check deferred to a later sprint.

abstract class _$MaintenanceNotifier extends $Notifier<MaintenanceState> {
  MaintenanceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MaintenanceState, MaintenanceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MaintenanceState, MaintenanceState>,
              MaintenanceState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
