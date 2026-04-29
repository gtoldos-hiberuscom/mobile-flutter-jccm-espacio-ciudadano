import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document_download_result.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_impl.dart';

void main() {
  group('NotificationDetailRepositoryImpl', () {
    test('loadDetail returns a deterministic pending detail', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final detail = await repo.loadDetail('NOT-0001');

      expect(detail.id, 'NOT-0001');
      expect(detail.status, NotificationStatus.pendiente);
      expect(detail.expedienteRef, 'EXP-2025-00451');
      expect(detail.procedimiento, 'Subvenciones — convocatoria 2025');
      expect(detail.decisionDeadline, isNotNull);
      expect(detail.descripcion.length, greaterThan(400));
      // Deadline = emisión + 14 días.
      expect(
        detail.decisionDeadline!.difference(detail.fechaEmision).inDays,
        14,
      );
      // STORY-44 — pending baseline preserves zero documents and no readAt.
      expect(detail.documents, isEmpty);
      expect(detail.readAt, isNull);
    });

    test('submitDecision(accept) returns aceptada outcome', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final outcome = await repo.submitDecision(
        notificationId: 'NOT-0001',
        action: NotificationDecisionAction.accept,
      );

      expect(outcome.resultStatus, NotificationStatus.aceptada);
    });

    test('submitDecision(reject) returns rechazada outcome', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final outcome = await repo.submitDecision(
        notificationId: 'NOT-0001',
        action: NotificationDecisionAction.reject,
      );

      expect(outcome.resultStatus, NotificationStatus.rechazada);
    });

    test('conflictOnDecision throws NotificationDecisionConflict', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
        conflictOnDecision: true,
        conflictCurrentStatus: NotificationStatus.caducada,
      );

      await expectLater(
        () => repo.submitDecision(
          notificationId: 'NOT-0001',
          action: NotificationDecisionAction.accept,
        ),
        throwsA(
          isA<NotificationDecisionConflict>().having(
            (final e) => e.currentStatus,
            'currentStatus',
            NotificationStatus.caducada,
          ),
        ),
      );
    });

    test('failOnLoad throws on loadDetail', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
        failOnLoad: true,
      );

      expect(
        () => repo.loadDetail('NOT-0001'),
        throwsA(isA<StateError>()),
      );
    });

    // ── STORY-44 — variant dispatch + document download ──────────────────

    test('id starting with "acc-" returns aceptada variant with two documents', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final detail = await repo.loadDetail('acc-1');

      expect(detail.status, NotificationStatus.aceptada);
      expect(detail.readAt, isNotNull);
      expect(
        detail.readAt!.difference(detail.fechaEmision).inDays,
        2,
      );
      expect(detail.documents, hasLength(2));
      expect(
        detail.documents.first.availability,
        NotificationDocumentAvailability.available,
      );
      expect(
        detail.documents.last.availability,
        NotificationDocumentAvailability.unavailable,
      );
    });

    test('id starting with "rej-" returns rechazada variant with one document', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final detail = await repo.loadDetail('rej-1');

      expect(detail.status, NotificationStatus.rechazada);
      expect(detail.readAt, isNotNull);
      expect(
        detail.readAt!.difference(detail.fechaEmision).inDays,
        1,
      );
      expect(detail.documents, hasLength(1));
      expect(
        detail.documents.single.availability,
        NotificationDocumentAvailability.available,
      );
    });

    test('id starting with "exp-" returns caducada variant with no documents and null readAt', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final detail = await repo.loadDetail('exp-1');

      expect(detail.status, NotificationStatus.caducada);
      expect(detail.readAt, isNull);
      expect(detail.documents, isEmpty);
    });

    test('loadDocuments mirrors the documents embedded in loadDetail', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final docs = await repo.loadDocuments('acc-1');

      expect(docs, hasLength(2));
      expect(docs.first.id, isNotEmpty);
    });

    test('downloadDocument returns success with bytes for available documents', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );
      final detail = await repo.loadDetail('acc-1');
      final available = detail.documents.firstWhere(
        (final d) => d.availability == NotificationDocumentAvailability.available,
      );

      final result = await repo.downloadDocument(
        notificationId: 'acc-1',
        documentId: available.id,
      );

      expect(result.status, NotificationDocumentDownloadStatus.success);
      expect(result.bytes, isNotNull);
      expect(result.bytes!.isNotEmpty, isTrue);
      expect(result.mimeType, 'application/pdf');
    });

    test('downloadDocument returns unavailable for unavailable documents', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );
      final detail = await repo.loadDetail('acc-1');
      final unavailable = detail.documents.firstWhere(
        (final d) => d.availability == NotificationDocumentAvailability.unavailable,
      );

      final result = await repo.downloadDocument(
        notificationId: 'acc-1',
        documentId: unavailable.id,
      );

      expect(result.status, NotificationDocumentDownloadStatus.unavailable);
      expect(result.bytes, isNull);
    });

    test('failOnDownload returns an error outcome without throwing', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
        failOnDownload: true,
      );

      final result = await repo.downloadDocument(
        notificationId: 'acc-1',
        documentId: 'doc-pdf-available',
      );

      expect(result.status, NotificationDocumentDownloadStatus.error);
    });
  });
}
