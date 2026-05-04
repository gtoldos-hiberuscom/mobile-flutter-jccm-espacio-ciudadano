// ignore_for_file: avoid_classes_with_only_static_members

import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_outcome.dart';

/// Pure parser that turns the Afirma return deep-link into a
/// [SignatureHandoffOutcome] (STORY-46).
///
/// The expected URI shape is:
///
///   `jccmespacio://sign/afirma/return?docId=<id>&result=<signed|cancelled|error>[&reason=...]`
///
/// Returns `null` when the URI does not match (wrong scheme/host/path,
/// missing `docId`, missing or unknown `result`). The parser deliberately
/// keeps the failure surface coarse — the [SignatureHandoffParseFailure]
/// enum is reserved for future logging / analytics.
abstract final class SignatureDeepLinkParser {
  /// Canonical custom scheme reserved for in-app deep links.
  static const String scheme = 'jccmespacio';

  /// Canonical authority for the signature deep links.
  static const String host = 'sign';

  /// Canonical path of the Afirma return deep link.
  static const String path = '/afirma/return';

  /// Attempts to parse [returnUri] into a terminal
  /// [SignatureHandoffOutcome]. Returns `null` when [returnUri] does
  /// not match the expected contract.
  static SignatureHandoffOutcome? tryParse(final Uri returnUri) {
    if (returnUri.scheme != scheme) {
      return null;
    }
    if (returnUri.host != host) {
      return null;
    }
    if (returnUri.path != path) {
      return null;
    }

    final docId = returnUri.queryParameters['docId'];
    if (docId == null || docId.isEmpty) {
      return null;
    }

    final result = returnUri.queryParameters['result'];
    final status = _statusFromToken(result);
    if (status == null) {
      return null;
    }

    final reason = returnUri.queryParameters['reason'];

    return SignatureHandoffOutcome(
      status: status,
      documentId: docId,
      errorReason: status == SignatureHandoffStatus.error ? (reason != null && reason.isNotEmpty ? reason : null) : null,
      completedAt: DateTime.now(),
    );
  }

  static SignatureHandoffStatus? _statusFromToken(final String? token) {
    switch (token) {
      case 'signed':
        return SignatureHandoffStatus.signed;
      case 'cancelled':
        return SignatureHandoffStatus.cancelled;
      case 'error':
        return SignatureHandoffStatus.error;
      default:
        return null;
    }
  }
}
