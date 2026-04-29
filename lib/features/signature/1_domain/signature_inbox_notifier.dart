import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_inbox_result.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_repository.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_provider.dart';

/// Owns the signature inbox screen state (STORY-45).
///
/// On `build()` it loads the inbox via [SignatureRepository.loadInbox].
/// `refresh()` reloads the inbox preserving the screen scaffolding.
///
/// NOTE on Riverpod codegen: per the implementation brief, hand-writing
/// `*.g.dart` files for the v3 generator is brittle (the generated
/// element tree references private internals such as `$Ref` /
/// `$ClassProviderElement` whose shape is sensitive to the generator
/// version). To keep STORY-45 self-contained we use plain
/// `AsyncNotifierProvider` / `Provider.autoDispose` here. A follow-up
/// can swap to `@riverpod` annotations when the codegen pipeline is
/// re-run repo-wide.
class SignatureInboxNotifier extends AsyncNotifier<SignatureInboxResult> {
  @override
  Future<SignatureInboxResult> build() async {
    final repo = ref.watch(signatureRepositoryProvider);
    // Trigger certificate validation in the background — the result is
    // surfaced through [certificateValidationProvider] so the inbox UI
    // can render its banner without blocking the document listing.
    ref.read(certificateValidationProvider.future).ignore();
    return repo.loadInbox();
  }

  /// Reloads the inbox and re-validates the certificate.
  Future<void> refresh() async {
    state = const AsyncValue<SignatureInboxResult>.loading();
    state = await AsyncValue.guard<SignatureInboxResult>(() async {
      // Invalidate so the banner reflects the current backend state.
      ref.invalidate(certificateValidationProvider);
      final repo = ref.read(signatureRepositoryProvider);
      return repo.loadInbox();
    });
  }
}

/// Notifier provider exposing the signature inbox state.
final signatureInboxProvider =
    AsyncNotifierProvider<SignatureInboxNotifier, SignatureInboxResult>(
      SignatureInboxNotifier.new,
      name: 'signatureInboxProvider',
    );

/// Async provider exposing the latest certificate / VEC validation
/// outcome (STORY-45).
///
/// Kept separate from [signatureInboxProvider] so the banner can render
/// independently from the document listing and so a failed validation
/// does not blank the inbox.
final certificateValidationProvider = FutureProvider<CertificateValidation>(
  (final ref) async {
    final repo = ref.watch(signatureRepositoryProvider);
    return repo.validateCertificate();
  },
  name: 'certificateValidationProvider',
);
