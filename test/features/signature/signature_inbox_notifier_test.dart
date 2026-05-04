import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_inbox_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_provider.dart';

void main() {
  group('SignatureInboxNotifier', () {
    ProviderContainer makeContainer({
      final bool forceInboxError = false,
      final CertificateValidationState? fixedCertificateState,
    }) => ProviderContainer(
      overrides: [
        signatureRepositoryProvider.overrideWith(
          (final ref) => SignatureRepositoryImpl(
            forceInboxError: forceInboxError,
            fixedCertificateState: fixedCertificateState ?? CertificateValidationState.valid,
          ),
        ),
      ],
    );

    test('initial build loads pending and signed documents', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = await container.read(signatureInboxProvider.future);
      expect(state.pending, hasLength(4));
      expect(state.signed, hasLength(2));
    });

    test('certificate provider returns the configured state', () async {
      final container = makeContainer(
        fixedCertificateState: CertificateValidationState.expired,
      );
      addTearDown(container.dispose);

      final validation = await container.read(certificateValidationProvider.future);
      expect(validation.state, CertificateValidationState.expired);
    });

    test('refresh reloads the inbox and re-validates the certificate', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(signatureInboxProvider.future);
      await container.read(certificateValidationProvider.future);

      final notifier = container.read(signatureInboxProvider.notifier);
      await notifier.refresh();

      final reloaded = container.read(signatureInboxProvider).requireValue;
      expect(reloaded.pending, hasLength(4));
      expect(reloaded.signed, hasLength(2));
    });

    test('initial build error path bubbles up through AsyncValue', () async {
      final container = makeContainer(forceInboxError: true);
      addTearDown(container.dispose);

      final result = await container
          .read(signatureInboxProvider.future)
          .then<Object?>(
            (final v) => v,
            onError: (final Object e, final _) => e,
          );
      expect(result, isA<StateError>());
    });
  });
}
