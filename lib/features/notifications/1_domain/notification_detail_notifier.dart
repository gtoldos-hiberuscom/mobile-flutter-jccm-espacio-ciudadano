import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_repository.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_provider.dart';

/// Owns the notification detail screen state for a given
/// `notificationId` (STORY-43).
///
/// On `build()` it loads the detail through
/// [NotificationDetailRepository.loadDetail].
/// `submitDecision(action)` calls the repository, updates state with
/// the new status (so the header chip refreshes before the page pops)
/// and returns the outcome so the page can display a snackbar.
///
/// Plain Riverpod (no codegen) per the implementation brief — see the
/// equivalent rationale in `signature_inbox_notifier.dart`.
class NotificationDetailNotifier extends AsyncNotifier<NotificationDetail> {
  NotificationDetailNotifier(this.notificationId);

  /// Identifier of the notification this notifier owns. Set by the
  /// family factory when the provider instance is created.
  final String notificationId;

  @override
  Future<NotificationDetail> build() async {
    final repo = ref.watch(notificationDetailRepositoryProvider);
    return repo.loadDetail(notificationId);
  }

  /// Submits the citizen's [action] for the current notification.
  ///
  /// Returns the resulting [NotificationDecisionOutcome] on success.
  /// Re-throws [NotificationDecisionConflict] so the page can surface
  /// a localised conflict snackbar without overwriting the detail
  /// state. The header chip is updated with `conflict.currentStatus`
  /// before the exception is rethrown.
  Future<NotificationDecisionOutcome> submitDecision(
    final NotificationDecisionAction action,
  ) async {
    final current = state.value;
    if (current == null) {
      throw StateError('NotificationDetailNotifier.submitDecision called before initial load completed');
    }
    final repo = ref.read(notificationDetailRepositoryProvider);
    try {
      final outcome = await repo.submitDecision(
        notificationId: notificationId,
        action: action,
      );
      state = AsyncValue<NotificationDetail>.data(
        current.copyWithStatus(outcome.resultStatus),
      );
      return outcome;
    } on NotificationDecisionConflict catch (conflict) {
      state = AsyncValue<NotificationDetail>.data(
        current.copyWithStatus(conflict.currentStatus),
      );
      rethrow;
    }
  }
}

/// Family provider keyed by notification id (STORY-43).
final notificationDetailProvider =
    AsyncNotifierProvider.family<NotificationDetailNotifier, NotificationDetail, String>(
      NotificationDetailNotifier.new,
      name: 'notificationDetailProvider',
    );
