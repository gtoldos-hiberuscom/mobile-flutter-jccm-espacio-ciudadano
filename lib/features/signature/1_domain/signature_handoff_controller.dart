import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_outcome.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_request.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_deep_link_parser.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_inbox_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_handoff_launcher_provider.dart';

/// Owns the in-flight external-signature handoff state (STORY-46).
///
/// State lifecycle:
///   `null` → `pending` (after [startHandoff]) → terminal outcome
///   (`signed | cancelled | error`) when [completeFromDeepLink] fires,
///   or `error` if the launcher itself refused to open the external
///   application.
///
/// Plain `Notifier` (no codegen) — see the rationale documented in
/// `signature_inbox_notifier.dart`.
class SignatureHandoffController extends Notifier<SignatureHandoffOutcome?> {
  @override
  SignatureHandoffOutcome? build() => null;

  /// Launches the external signature flow and transitions the outcome
  /// to [SignatureHandoffStatus.pending].
  ///
  /// Returns `true` when the OS accepted the launch request, `false`
  /// otherwise. On failure the state is set to a terminal `error`
  /// outcome so the UI can prompt the citizen to retry.
  Future<bool> startHandoff(final SignatureHandoffRequest request) async {
    state = SignatureHandoffOutcome.pending(documentId: request.documentId);
    final launcher = ref.read(signatureHandoffLauncherProvider);
    final accepted = await launcher.launchExternal(request.externalUri);
    if (!accepted) {
      state = SignatureHandoffOutcome(
        status: SignatureHandoffStatus.error,
        documentId: request.documentId,
        errorReason: 'launcher_refused',
        completedAt: DateTime.now(),
      );
      return false;
    }
    return true;
  }

  /// Parses the deep-link return [uri], updates the controller state
  /// with the parsed outcome and refreshes the signature inbox so the
  /// just-signed document moves into the `signed` tab.
  ///
  /// When the URI cannot be parsed the state is left untouched so the
  /// UI keeps showing the previous (typically `pending`) outcome.
  void completeFromDeepLink(final Uri uri) {
    final outcome = SignatureDeepLinkParser.tryParse(uri);
    if (outcome == null) {
      return;
    }
    state = outcome;
    // Fire-and-forget refresh — the inbox notifier owns its own loading
    // state, so any error there is surfaced via its own AsyncValue.
    unawaited(ref.read(signatureInboxProvider.notifier).refresh());
  }

  /// Resets the controller. Used by the inbox page when it leaves the
  /// screen so a stale outcome does not leak into a future visit.
  void clear() {
    state = null;
  }
}

/// Notifier provider exposing the handoff controller.
final signatureHandoffControllerProvider = NotifierProvider<SignatureHandoffController, SignatureHandoffOutcome?>(
  SignatureHandoffController.new,
  name: 'signatureHandoffControllerProvider',
);
