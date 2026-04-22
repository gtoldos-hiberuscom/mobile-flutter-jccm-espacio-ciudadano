import 'package:jccm_espacio_ciudadano/features/maintenance/0_entity/maintenance_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'maintenance_notifier.g.dart';

/// Manages the application maintenance state.
///
/// Starts as [MaintenanceInactive]. Use [setMaintenance] to activate a
/// maintenance window and [clearMaintenance] to deactivate it.
///
/// Real check deferred to a later sprint.
@Riverpod(keepAlive: true)
class MaintenanceNotifier extends _$MaintenanceNotifier {
  @override
  MaintenanceState build() => const MaintenanceInactive();

  /// Activates a maintenance window with the given [message].
  void setMaintenance(final String message, {final DateTime? expectedEnd}) {
    state = MaintenanceActive(message: message, expectedEnd: expectedEnd);
  }

  /// Deactivates the maintenance window.
  void clearMaintenance() {
    state = const MaintenanceInactive();
  }
}
