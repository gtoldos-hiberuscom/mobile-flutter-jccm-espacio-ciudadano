import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_outcome.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_request.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_inbox_result.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_controller.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_inbox_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_repository.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_handoff_launcher_provider.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_provider.dart';

class _FakeLauncher implements SignatureHandoffLauncher {
  _FakeLauncher({required this.accept});

  final bool accept;
  int calls = 0;
  Uri? lastUri;

  @override
  Future<bool> launchExternal(final Uri externalUri) async {
    calls++;
    lastUri = externalUri;
    return accept;
  }
}

class _CountingRepository implements SignatureRepository {
  _CountingRepository()
    : _inner = SignatureRepositoryImpl(
        fixedCertificateState: CertificateValidationState.valid,
      );

  final SignatureRepositoryImpl _inner;
  int loadInboxCalls = 0;

  @override
  Future<SignatureInboxResult> loadInbox() {
    loadInboxCalls++;
    return _inner.loadInbox();
  }

  @override
  Future<CertificateValidation> validateCertificate() =>
      _inner.validateCertificate();

  @override
  Future<List<SignatureDocument>> loadSignedHistory() =>
      _inner.loadSignedHistory();
}

SignatureHandoffRequest _request(final String docId) =>
    SignatureHandoffRequest(
      documentId: docId,
      documentTitle: 'Doc $docId',
      externalUri: Uri.parse('https://afirma.jccm.es/sign?docId=$docId'),
      returnDeepLink: Uri.parse(
        'jccmespacio://sign/afirma/return?docId=$docId',
      ),
      requestedAt: DateTime(2026, 4, 21, 10),
    );

void main() {
  group('SignatureHandoffController', () {
    test(
      'startHandoff happy path sets pending and leaves it pending until completeFromDeepLink',
      () async {
        final launcher = _FakeLauncher(accept: true);
        final container = ProviderContainer(
          overrides: [
            signatureRepositoryProvider.overrideWith(
              (final ref) => SignatureRepositoryImpl(
                fixedCertificateState: CertificateValidationState.valid,
              ),
            ),
            signatureHandoffLauncherProvider.overrideWithValue(launcher),
          ],
        );
        addTearDown(container.dispose);

        // Prime the inbox so the handoff controller can refresh it later.
        await container.read(signatureInboxProvider.future);

        final notifier = container.read(
          signatureHandoffControllerProvider.notifier,
        );
        final accepted = await notifier.startHandoff(_request('DOC-1'));

        expect(accepted, isTrue);
        expect(launcher.calls, 1);
        final outcome = container.read(signatureHandoffControllerProvider);
        expect(outcome, isNotNull);
        expect(outcome!.status, SignatureHandoffStatus.pending);
        expect(outcome.documentId, 'DOC-1');
        expect(outcome.completedAt, isNull);
      },
    );

    test('startHandoff failure sets state to error', () async {
      final launcher = _FakeLauncher(accept: false);
      final container = ProviderContainer(
        overrides: [
          signatureRepositoryProvider.overrideWith(
            (final ref) => SignatureRepositoryImpl(
              fixedCertificateState: CertificateValidationState.valid,
            ),
          ),
          signatureHandoffLauncherProvider.overrideWithValue(launcher),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        signatureHandoffControllerProvider.notifier,
      );
      final accepted = await notifier.startHandoff(_request('DOC-2'));

      expect(accepted, isFalse);
      final outcome = container.read(signatureHandoffControllerProvider);
      expect(outcome, isNotNull);
      expect(outcome!.status, SignatureHandoffStatus.error);
      expect(outcome.documentId, 'DOC-2');
      expect(outcome.errorReason, 'launcher_refused');
      expect(outcome.completedAt, isNotNull);
    });

    test(
      'completeFromDeepLink parses the uri and triggers an inbox refresh',
      () async {
        final launcher = _FakeLauncher(accept: true);
        final repo = _CountingRepository();
        final container = ProviderContainer(
          overrides: [
            signatureRepositoryProvider.overrideWithValue(repo),
            signatureHandoffLauncherProvider.overrideWithValue(launcher),
          ],
        );
        addTearDown(container.dispose);

        // Initial inbox load.
        await container.read(signatureInboxProvider.future);
        final loadsAfterPrime = repo.loadInboxCalls;

        container
            .read(signatureHandoffControllerProvider.notifier)
            .completeFromDeepLink(
              Uri.parse(
                'jccmespacio://sign/afirma/return?docId=DOC-9&result=signed',
              ),
            );

        final outcome = container.read(signatureHandoffControllerProvider);
        expect(outcome, isNotNull);
        expect(outcome!.status, SignatureHandoffStatus.signed);
        expect(outcome.documentId, 'DOC-9');

        // Wait for the fire-and-forget refresh future to settle.
        await container.read(signatureInboxProvider.future);
        expect(repo.loadInboxCalls, greaterThan(loadsAfterPrime));
      },
    );

    test(
      'completeFromDeepLink with a non-matching uri leaves the previous state untouched',
      () async {
        final launcher = _FakeLauncher(accept: true);
        final container = ProviderContainer(
          overrides: [
            signatureRepositoryProvider.overrideWith(
              (final ref) => SignatureRepositoryImpl(
                fixedCertificateState: CertificateValidationState.valid,
              ),
            ),
            signatureHandoffLauncherProvider.overrideWithValue(launcher),
          ],
        );
        addTearDown(container.dispose);
        await container.read(signatureInboxProvider.future);

        final notifier = container.read(
          signatureHandoffControllerProvider.notifier,
        );
        await notifier.startHandoff(_request('DOC-3'));
        notifier.completeFromDeepLink(Uri.parse('https://wrong/scheme'));

        final outcome = container.read(signatureHandoffControllerProvider);
        expect(outcome, isNotNull);
        expect(outcome!.status, SignatureHandoffStatus.pending);
      },
    );

    test('clear resets the controller state to null', () async {
      final launcher = _FakeLauncher(accept: true);
      final container = ProviderContainer(
        overrides: [
          signatureRepositoryProvider.overrideWith(
            (final ref) => SignatureRepositoryImpl(
              fixedCertificateState: CertificateValidationState.valid,
            ),
          ),
          signatureHandoffLauncherProvider.overrideWithValue(launcher),
        ],
      );
      addTearDown(container.dispose);
      await container.read(signatureInboxProvider.future);

      final notifier = container.read(
        signatureHandoffControllerProvider.notifier,
      );
      await notifier.startHandoff(_request('DOC-4'));
      expect(container.read(signatureHandoffControllerProvider), isNotNull);

      notifier.clear();
      expect(container.read(signatureHandoffControllerProvider), isNull);
    });
  });
}
