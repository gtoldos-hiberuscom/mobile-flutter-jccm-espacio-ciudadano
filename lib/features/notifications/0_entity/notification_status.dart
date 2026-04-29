/// Lifecycle status assigned to a citizen notification (STORY-41).
///
/// The real backend value-set for `ZCSSTPUBPORTAL.estado` is not yet
/// confirmed (see `documentation/discovery/TASK-47-notifications-contract-strategy.md`),
/// so the enum follows the tolerant-parser strategy: any unmapped raw
/// value falls into [unknown] and is rendered with a neutral chip.
///
/// Pure Dart — no Flutter / Riverpod / l10n imports (canon §11). The
/// human-readable label is resolved by the presentation layer through
/// the [labelKey] slot.
enum NotificationStatus {
  pendiente('notificationStatusPendiente'),
  aceptada('notificationStatusAceptada'),
  rechazada('notificationStatusRechazada'),
  caducada('notificationStatusCaducada'),
  unknown('notificationStatusUnknown')
  ;

  const NotificationStatus(this.labelKey);

  /// Stable key used by the presentation layer to look up the localised
  /// label in `AppLocalizations` (no l10n dependency in this layer).
  final String labelKey;
}
