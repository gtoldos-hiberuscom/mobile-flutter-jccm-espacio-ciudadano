// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MaintenanceNotifier)
const maintenanceNotifierProvider = MaintenanceNotifierProvider._();

final class MaintenanceNotifierProvider
    extends $NotifierProvider<MaintenanceNotifier, MaintenanceState> {
  const MaintenanceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceNotifierHash();

  @$internal
  @override
  MaintenanceNotifier create() => MaintenanceNotifier();
}

String _$maintenanceNotifierHash() => r'f1e2d3c4b5a6978869504132231415161718192021';

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
