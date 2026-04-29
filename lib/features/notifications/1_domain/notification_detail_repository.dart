import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document_download_result.dart';

/// Repository abstraction for the notification detail surface, the
/// pending decision flow (STORY-43) and the document operations
/// (STORY-44).
///
/// Implementations live under `3_data/`. The domain layer must depend
/// only on this abstraction (canon §12).
abstract interface class NotificationDetailRepository {
  /// Loads the detail for the notification identified by [id].
  Future<NotificationDetail> loadDetail(final String id);

  /// Submits a pending-state [action] (accept/reject) against
  /// [notificationId].
  ///
  /// Throws [NotificationDecisionConflict] when the notification was
  /// already decided or its decision window expired.
  Future<NotificationDecisionOutcome> submitDecision({
    required final String notificationId,
    required final NotificationDecisionAction action,
  });

  /// Loads the documents associated with [notificationId] (STORY-44).
  ///
  /// In the current mock the documents are also embedded in
  /// [loadDetail], but the explicit accessor is kept so future Dio
  /// adapters can lazy-load them through `/publicacion/midocfirmados`
  /// without re-fetching the whole detail.
  Future<List<NotificationDocument>> loadDocuments(final String notificationId);

  /// Triggers the download of [documentId] attached to
  /// [notificationId] (STORY-44).
  ///
  /// Returns a [NotificationDocumentDownloadResult] describing whether
  /// the payload was retrieved, the document is acknowledged-but-
  /// unavailable, or the operation errored. Implementations should not
  /// throw for the success / unavailable branches.
  Future<NotificationDocumentDownloadResult> downloadDocument({
    required final String notificationId,
    required final String documentId,
  });
}
