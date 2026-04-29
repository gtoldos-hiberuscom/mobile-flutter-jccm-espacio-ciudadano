import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document_download_result.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_repository.dart';

/// Mock implementation of [NotificationDetailRepository] for STORY-43
/// and the document variants introduced in STORY-44.
///
/// Returns deterministic data so widget / notifier tests can exercise
/// every variant (pending / aceptada / rechazada / caducada) plus the
/// download outcomes without monkey-patching anything.
///
/// The variant returned by [loadDetail] is selected from the
/// `notificationId` prefix:
///
/// * `acc-` → STORY-44 aceptada variant with two documents (one PDF
///   available, one zip unavailable).
/// * `rej-` → STORY-44 rechazada variant with a single available PDF.
/// * `exp-` → STORY-44 caducada variant with no documents (empty
///   state).
/// * anything else → STORY-43 pendiente baseline (no documents,
///   `readAt` null).
///
/// A real Dio-backed adapter against `/notifications/*` and
/// `/publicacion/midocfirmados` is deferred — see
/// `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
// TODO(future-sprint): replace mock with Dio-backed datasource bound
// to the confirmed notifications + `/publicacion/midocfirmados`
// contract once TASK-47 is finalised.
final class NotificationDetailRepositoryImpl implements NotificationDetailRepository {
  NotificationDetailRepositoryImpl({
    this.simulatedNetworkDelay = const Duration(milliseconds: 200),
    this.conflictOnDecision = false,
    this.conflictCurrentStatus = NotificationStatus.aceptada,
    this.failOnLoad = false,
    this.failOnDownload = false,
  });

  /// Simulates a tiny network round-trip for [submitDecision] and
  /// [downloadDocument]. Tests can lower it to [Duration.zero] to
  /// keep widget pumps cheap.
  final Duration simulatedNetworkDelay;

  /// When `true`, [submitDecision] throws [NotificationDecisionConflict]
  /// instead of returning an outcome. Used by widget tests to exercise
  /// the conflict snackbar surface.
  final bool conflictOnDecision;
  final NotificationStatus conflictCurrentStatus;

  /// When `true`, [loadDetail] throws so the page can render its error
  /// state.
  final bool failOnLoad;

  /// When `true`, [downloadDocument] returns
  /// [NotificationDocumentDownloadResult.error] for any document id —
  /// used to exercise the generic download error toast.
  final bool failOnDownload;

  static const String _accPrefix = 'acc-';
  static const String _rejPrefix = 'rej-';
  static const String _expPrefix = 'exp-';

  // Document ids exposed by the mock — referenced by the page tests
  // and the [downloadDocument] dispatch below.
  static const String _docPdfAvailableId = 'doc-pdf-available';
  static const String _docZipUnavailableId = 'doc-zip-unavailable';

  @override
  Future<NotificationDetail> loadDetail(final String id) async {
    if (failOnLoad) {
      throw StateError('mock: forced loadDetail failure for $id');
    }
    final reference = DateTime(2026, 5, 4, 10);
    final status = _statusFor(id);
    return NotificationDetail(
      id: id,
      asunto: 'Notificación administrativa $id',
      organismoEmisor: 'Consejería de Educación',
      fechaEmision: reference,
      status: status,
      descripcion: _dummyDescription,
      expedienteRef: 'EXP-2025-00451',
      procedimiento: 'Subvenciones — convocatoria 2025',
      decisionDeadline: reference.add(const Duration(days: 14)),
      documents: _documentsFor(status),
      readAt: _readAtFor(status, reference),
    );
  }

  @override
  Future<NotificationDecisionOutcome> submitDecision({
    required final String notificationId,
    required final NotificationDecisionAction action,
  }) async {
    if (simulatedNetworkDelay > Duration.zero) {
      await Future<void>.delayed(simulatedNetworkDelay);
    }
    if (conflictOnDecision) {
      throw NotificationDecisionConflict(
        currentStatus: conflictCurrentStatus,
        message: 'mock: notification $notificationId already decided',
      );
    }
    final resultStatus = switch (action) {
      NotificationDecisionAction.accept => NotificationStatus.aceptada,
      NotificationDecisionAction.reject => NotificationStatus.rechazada,
    };
    return NotificationDecisionOutcome(
      resultStatus: resultStatus,
      message: 'mock: decision applied to $notificationId',
    );
  }

  @override
  Future<List<NotificationDocument>> loadDocuments(
    final String notificationId,
  ) async {
    if (simulatedNetworkDelay > Duration.zero) {
      await Future<void>.delayed(simulatedNetworkDelay);
    }
    return _documentsFor(_statusFor(notificationId));
  }

  @override
  Future<NotificationDocumentDownloadResult> downloadDocument({
    required final String notificationId,
    required final String documentId,
  }) async {
    if (simulatedNetworkDelay > Duration.zero) {
      await Future<void>.delayed(simulatedNetworkDelay);
    }
    if (failOnDownload) {
      return NotificationDocumentDownloadResult.error(
        message: 'mock: forced download error for $documentId',
      );
    }
    if (documentId == _docZipUnavailableId) {
      return NotificationDocumentDownloadResult.unavailable(
        message: 'mock: $documentId acknowledged but not downloadable',
      );
    }
    // Synthetic non-empty payload — enough to be observable in tests
    // without bundling a real PDF asset.
    final payload = Uint8List.fromList(
      'mock-pdf-payload:$notificationId:$documentId'.codeUnits,
    );
    return NotificationDocumentDownloadResult.success(
      bytes: payload,
      mimeType: 'application/pdf',
      message: 'mock: $documentId downloaded',
    );
  }

  NotificationStatus _statusFor(final String id) {
    if (id.startsWith(_accPrefix)) {
      return NotificationStatus.aceptada;
    }
    if (id.startsWith(_rejPrefix)) {
      return NotificationStatus.rechazada;
    }
    if (id.startsWith(_expPrefix)) {
      return NotificationStatus.caducada;
    }
    return NotificationStatus.pendiente;
  }

  List<NotificationDocument> _documentsFor(final NotificationStatus status) {
    switch (status) {
      case NotificationStatus.aceptada:
        return const <NotificationDocument>[
          NotificationDocument(
            id: _docPdfAvailableId,
            name: 'Resolucion-firmada.pdf',
            mimeType: 'application/pdf',
            sizeBytes: 248_320,
            availability: NotificationDocumentAvailability.available,
            // TODO(future-sprint): replace with the real signed
            // download locator returned by `/publicacion/midocfirmados`.
            downloadHint: 'midocfirmados/acc-resolucion',
          ),
          NotificationDocument(
            id: _docZipUnavailableId,
            name: 'Anexos-tecnicos.zip',
            mimeType: 'application/zip',
            sizeBytes: 1_572_864,
            availability: NotificationDocumentAvailability.unavailable,
            downloadHint: 'midocfirmados/acc-anexos',
          ),
        ];
      case NotificationStatus.rechazada:
        return const <NotificationDocument>[
          NotificationDocument(
            id: _docPdfAvailableId,
            name: 'Acuse-rechazo.pdf',
            mimeType: 'application/pdf',
            sizeBytes: 122_880,
            availability: NotificationDocumentAvailability.available,
            // TODO(future-sprint): replace with the real signed
            // download locator returned by `/publicacion/midocfirmados`.
            downloadHint: 'midocfirmados/rej-acuse',
          ),
        ];
      case NotificationStatus.caducada:
      case NotificationStatus.pendiente:
      case NotificationStatus.unknown:
        return const <NotificationDocument>[];
    }
  }

  DateTime? _readAtFor(final NotificationStatus status, final DateTime reference) {
    switch (status) {
      case NotificationStatus.aceptada:
        return reference.add(const Duration(days: 2));
      case NotificationStatus.rechazada:
        return reference.add(const Duration(days: 1));
      case NotificationStatus.caducada:
      case NotificationStatus.pendiente:
      case NotificationStatus.unknown:
        return null;
    }
  }

  // Roughly ~600 chars of dummy lorem-style copy in Spanish, deterministic.
  static const String _dummyDescription =
      'Le comunicamos que se ha emitido una notificación administrativa relativa al expediente '
      'identificado en esta misma pantalla. Dispone de un plazo legal para aceptar o rechazar la '
      'notificación a través de los canales electrónicos habilitados. Si acepta la notificación '
      'podrá consultar el contenido íntegro y los documentos anexos asociados al expediente. Si '
      'la rechaza, la administración tendrá constancia formal de su rechazo y se considerará '
      'efectuada la práctica de la notificación a todos los efectos legales. Esta acción es '
      'irreversible. Para cualquier duda puede contactar con el organismo emisor a través de los '
      'canales habituales de atención al ciudadano.';
}
