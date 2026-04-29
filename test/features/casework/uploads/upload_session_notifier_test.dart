import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_constraints.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_validator.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/3_data/upload_repository_provider.dart';

class _FakeRepo implements UploadRepository {
  _FakeRepo();

  @override
  Future<String> computeServerHash(final Uint8List bytes) async => sha256HexOf(bytes);

  @override
  Future<UploadAttachment> uploadUnsigned(
    final UploadAttachment attachment,
    final Uint8List bytes,
    final String expedienteRef,
  ) async {
    if (attachment.displayName.toLowerCase().contains('fail')) {
      return attachment.copyWith(
        status: UploadAttachmentStatus.failed,
        errorMessage: 'fake-fail',
      );
    }
    return attachment.copyWith(
      status: UploadAttachmentStatus.uploaded,
      clearError: true,
    );
  }

  @override
  Future<JustificanteState> requestJustificante(final UploadSession session) => Future<JustificanteState>.value(
    const JustificanteState.unavailable('test-stub'),
  );
}

ProviderContainer _container(final UploadRepository repo) {
  final c = ProviderContainer(
    overrides: [
      uploadRepositoryProvider.overrideWith((final ref) => repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

PickedFile _pdf({final String name = 'doc.pdf', final int sizeBytes = 1024}) {
  final bytes = Uint8List.fromList(List<int>.filled(sizeBytes, 1));
  return (
    name: name,
    sizeBytes: bytes.length,
    mimeType: 'application/pdf',
    bytes: bytes,
  );
}

void main() {
  test('add → hash → upload happy path', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');

    await c.read(uploadSessionProvider.notifier).addFiles(<PickedFile>[_pdf()]);
    final attachment = c.read(uploadSessionProvider).files.single;
    expect(attachment.status, UploadAttachmentStatus.hashed);
    expect(attachment.sha256Hex, isNotNull);

    await c.read(uploadSessionProvider.notifier).uploadAll(<String, Uint8List>{
      attachment.id: Uint8List.fromList(List<int>.filled(attachment.sizeBytes, 1)),
    });
    expect(
      c.read(uploadSessionProvider).files.single.status,
      UploadAttachmentStatus.uploaded,
    );
  });

  test('rejects oversize file', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');
    await c.read(uploadSessionProvider.notifier).addFiles(<PickedFile>[
      _pdf(name: 'huge.pdf', sizeBytes: kMaxFileBytes + 10),
    ]);
    final attachment = c.read(uploadSessionProvider).files.single;
    expect(attachment.status, UploadAttachmentStatus.failed);
    expect(attachment.errorMessage, UploadValidationFailure.tooLarge.name);
  });

  test('rejects the 6th file when 5 are already attached', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');
    final picked = List<PickedFile>.generate(
      kMaxFiles + 1,
      (final i) => _pdf(name: 'f$i.pdf', sizeBytes: 16),
    );
    await c.read(uploadSessionProvider.notifier).addFiles(picked);
    final files = c.read(uploadSessionProvider).files;
    expect(files.length, kMaxFiles + 1);
    expect(files.last.status, UploadAttachmentStatus.failed);
    expect(files.last.errorMessage, UploadValidationFailure.tooManyFiles.name);
  });

  test('failed upload preserves earlier files state', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');
    await c.read(uploadSessionProvider.notifier).addFiles(<PickedFile>[
      _pdf(name: 'ok.pdf'),
      _pdf(name: 'will-fail.pdf'),
    ]);
    final session = c.read(uploadSessionProvider);
    final bytesById = <String, Uint8List>{
      for (final f in session.files) f.id: Uint8List.fromList(List<int>.filled(f.sizeBytes, 1)),
    };
    await c.read(uploadSessionProvider.notifier).uploadAll(bytesById);
    final files = c.read(uploadSessionProvider).files;
    expect(files.first.status, UploadAttachmentStatus.uploaded);
    expect(files.last.status, UploadAttachmentStatus.failed);
  });

  test('finalize without all uploaded does nothing', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');
    await c.read(uploadSessionProvider.notifier).addFiles(<PickedFile>[_pdf()]);
    await c.read(uploadSessionProvider.notifier).finalizeAndRequestJustificante();
    final session = c.read(uploadSessionProvider);
    expect(session.finalized, isFalse);
    expect(session.justificante, isA<JustificantePending>());
  });

  test('finalize after all uploaded returns unavailable justificante', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');
    await c.read(uploadSessionProvider.notifier).addFiles(<PickedFile>[_pdf()]);
    final f = c.read(uploadSessionProvider).files.single;
    await c.read(uploadSessionProvider.notifier).uploadAll(<String, Uint8List>{
      f.id: Uint8List.fromList(List<int>.filled(f.sizeBytes, 1)),
    });
    await c.read(uploadSessionProvider.notifier).finalizeAndRequestJustificante();
    final session = c.read(uploadSessionProvider);
    expect(session.finalized, isTrue);
    expect(session.justificante, isA<JustificanteUnavailable>());
  });

  test('removeFile drops a staged attachment', () async {
    final c = _container(_FakeRepo());
    c.read(uploadSessionProvider.notifier).start('exp-1');
    await c.read(uploadSessionProvider.notifier).addFiles(<PickedFile>[_pdf()]);
    final id = c.read(uploadSessionProvider).files.single.id;
    c.read(uploadSessionProvider.notifier).removeFile(id);
    expect(c.read(uploadSessionProvider).files, isEmpty);
  });
}
