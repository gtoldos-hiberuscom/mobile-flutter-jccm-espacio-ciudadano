import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_outcome.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_deep_link_parser.dart';

void main() {
  group('SignatureDeepLinkParser.tryParse', () {
    test('parses a signed deep-link', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('jccmespacio://sign/afirma/return?docId=DOC-1&result=signed'),
      );
      expect(outcome, isNotNull);
      expect(outcome!.status, SignatureHandoffStatus.signed);
      expect(outcome.documentId, 'DOC-1');
      expect(outcome.errorReason, isNull);
      expect(outcome.completedAt, isNotNull);
    });

    test('parses a cancelled deep-link', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse(
          'jccmespacio://sign/afirma/return?docId=DOC-2&result=cancelled',
        ),
      );
      expect(outcome, isNotNull);
      expect(outcome!.status, SignatureHandoffStatus.cancelled);
      expect(outcome.documentId, 'DOC-2');
    });

    test('parses an error deep-link with reason', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse(
          'jccmespacio://sign/afirma/return?docId=DOC-3&result=error&reason=cert_expired',
        ),
      );
      expect(outcome, isNotNull);
      expect(outcome!.status, SignatureHandoffStatus.error);
      expect(outcome.documentId, 'DOC-3');
      expect(outcome.errorReason, 'cert_expired');
    });

    test('returns null when scheme does not match', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('https://sign/afirma/return?docId=DOC-1&result=signed'),
      );
      expect(outcome, isNull);
    });

    test('returns null when host does not match', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('jccmespacio://other/afirma/return?docId=DOC-1&result=signed'),
      );
      expect(outcome, isNull);
    });

    test('returns null when path does not match', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('jccmespacio://sign/clave/return?docId=DOC-1&result=signed'),
      );
      expect(outcome, isNull);
    });

    test('returns null when docId is missing', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('jccmespacio://sign/afirma/return?result=signed'),
      );
      expect(outcome, isNull);
    });

    test('returns null when docId is empty', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('jccmespacio://sign/afirma/return?docId=&result=signed'),
      );
      expect(outcome, isNull);
    });

    test('returns null when result is missing', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('jccmespacio://sign/afirma/return?docId=DOC-1'),
      );
      expect(outcome, isNull);
    });

    test('returns null when result is unknown', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse(
          'jccmespacio://sign/afirma/return?docId=DOC-1&result=mystery',
        ),
      );
      expect(outcome, isNull);
    });

    test('returns null on a malformed (non-matching) uri', () {
      final outcome = SignatureDeepLinkParser.tryParse(
        Uri.parse('not-a-deep-link'),
      );
      expect(outcome, isNull);
    });
  });
}
