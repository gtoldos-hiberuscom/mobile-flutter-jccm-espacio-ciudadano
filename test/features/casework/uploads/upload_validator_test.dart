import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_constraints.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_validator.dart';

void main() {
  group('validateNewFile', () {
    test('accepts a valid PDF', () {
      expect(
        validateNewFile(
          currentCount: 0,
          name: 'doc.pdf',
          sizeBytes: 1024,
          mimeType: 'application/pdf',
        ),
        isNull,
      );
    });

    test('rejects when current count reached the maximum', () {
      expect(
        validateNewFile(
          currentCount: kMaxFiles,
          name: 'doc.pdf',
          sizeBytes: 100,
          mimeType: 'application/pdf',
        ),
        UploadValidationFailure.tooManyFiles,
      );
    });

    test('rejects empty file', () {
      expect(
        validateNewFile(
          currentCount: 0,
          name: 'doc.pdf',
          sizeBytes: 0,
          mimeType: 'application/pdf',
        ),
        UploadValidationFailure.emptyFile,
      );
    });

    test('rejects file above the size limit', () {
      expect(
        validateNewFile(
          currentCount: 0,
          name: 'doc.pdf',
          sizeBytes: kMaxFileBytes + 1,
          mimeType: 'application/pdf',
        ),
        UploadValidationFailure.tooLarge,
      );
    });

    test('rejects unsupported MIME', () {
      expect(
        validateNewFile(
          currentCount: 0,
          name: 'archive.zip',
          sizeBytes: 100,
          mimeType: 'application/zip',
        ),
        UploadValidationFailure.unsupportedMime,
      );
    });

    test('treats blank name as unsupported', () {
      expect(
        validateNewFile(
          currentCount: 0,
          name: '   ',
          sizeBytes: 100,
          mimeType: 'application/pdf',
        ),
        UploadValidationFailure.unsupportedMime,
      );
    });
  });

  test('sha256HexOf returns deterministic lowercase hex', () {
    expect(
      sha256HexOf(Uint8List.fromList('hello'.codeUnits)),
      '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
    );
  });
}
