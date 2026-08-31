// Pure domain type — no Flutter, no Riverpod, no Dio

/// Thrown by consent repository reads when the remote clausulas service
/// cannot answer (network failure, 5xx, 401/403, malformed body) and no
/// trusted local evidence exists.
///
/// It marks the consent status as UNKNOWN, as opposed to a genuine
/// "not accepted" (404 / clausulaPendiente / clause 0 unselected). Callers
/// decide fail-open vs fail-closed per call-site; treating this state as
/// "not accepted" is what allowed a backend outage to destroy sessions.
final class ConsentStatusUnknownException implements Exception {
  const ConsentStatusUnknownException({
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String message;

  /// HTTP status of the failed call; `null` when the failure was
  /// transport-level (timeout, no connection).
  final int? statusCode;

  final Object? cause;

  @override
  String toString() => 'ConsentStatusUnknownException(status: $statusCode): $message';
}
