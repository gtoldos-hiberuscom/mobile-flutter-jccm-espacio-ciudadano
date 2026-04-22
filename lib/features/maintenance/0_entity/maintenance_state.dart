/// Sealed entity representing the app maintenance mode.
sealed class MaintenanceState {
  const MaintenanceState();
}

/// Maintenance window is active.
class MaintenanceActive extends MaintenanceState {
  const MaintenanceActive({required this.message, this.expectedEnd});
  final String message;
  final DateTime? expectedEnd;
}

/// No maintenance window active — normal operation.
class MaintenanceInactive extends MaintenanceState {
  const MaintenanceInactive();
}
