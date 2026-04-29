import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document_status.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_impl.dart';

void main() {
  group('SignatureRepositoryImpl', () {
    test('loadInbox returns 3 pending + 1 expired and 2 signed documents', () async {
      final repo = SignatureRepositoryImpl();
      final result = await repo.loadInbox();

      expect(result.pending, hasLength(4));
      expect(
        result.pending.where((final d) => d.status == SignatureDocumentStatus.pendiente),
        hasLength(3),
      );
      expect(
        result.pending.where((final d) => d.status == SignatureDocumentStatus.expirado),
        hasLength(1),
      );
      expect(result.signed, hasLength(2));
      expect(
        result.signed.every((final d) => d.status == SignatureDocumentStatus.firmado),
        isTrue,
      );
    });

    test('loadSignedHistory mirrors the inbox signed list', () async {
      final repo = SignatureRepositoryImpl();
      final inbox = await repo.loadInbox();
      final history = await repo.loadSignedHistory();
      expect(history.map((final d) => d.id), inbox.signed.map((final d) => d.id));
    });

    test('validateCertificate cycles through valid → vecAvailable → expired', () async {
      final repo = SignatureRepositoryImpl();
      final first = await repo.validateCertificate();
      final second = await repo.validateCertificate();
      final third = await repo.validateCertificate();
      final fourth = await repo.validateCertificate();
      expect(first.state, CertificateValidationState.valid);
      expect(second.state, CertificateValidationState.vecAvailable);
      expect(third.state, CertificateValidationState.expired);
      expect(fourth.state, CertificateValidationState.valid);
      expect(first.canSign, isTrue);
      expect(second.canSign, isTrue);
      expect(third.canSign, isFalse);
    });

    test('fixedCertificateState pins the validation outcome', () async {
      final repo = SignatureRepositoryImpl(
        fixedCertificateState: CertificateValidationState.missing,
      );
      final result = await repo.validateCertificate();
      expect(result.state, CertificateValidationState.missing);
      expect(result.canSign, isFalse);
    });

    test('forceInboxError throws when loading the inbox', () async {
      final repo = SignatureRepositoryImpl(forceInboxError: true);
      expect(repo.loadInbox(), throwsA(isA<StateError>()));
    });

    test('forceCertificateError throws on validation', () async {
      final repo = SignatureRepositoryImpl(forceCertificateError: true);
      expect(repo.validateCertificate(), throwsA(isA<StateError>()));
    });
  });
}
