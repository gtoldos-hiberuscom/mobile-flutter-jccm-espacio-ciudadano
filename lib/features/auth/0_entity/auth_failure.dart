enum AuthFailureReason {
  cancelled,
  configuration,
  invalidResponse,
  remoteFailure,
  unexpected,
}

final class AuthException implements Exception {
  const AuthException._({
    required this.reason,
    required this.message,
    this.cause,
  });

  const factory AuthException.cancelled({
    final Object? cause,
  }) = _AuthCancelledException;

  const factory AuthException.configuration({
    required final String message,
    final Object? cause,
  }) = _AuthConfigurationException;

  const factory AuthException.invalidResponse({
    required final String message,
    final Object? cause,
  }) = _AuthInvalidResponseException;

  const factory AuthException.remoteFailure({
    required final String message,
    final Object? cause,
  }) = _AuthRemoteFailureException;

  const factory AuthException.unexpected({
    final Object? cause,
  }) = _AuthUnexpectedException;

  final AuthFailureReason reason;
  final String message;
  final Object? cause;

  @override
  String toString() => 'AuthException($reason): $message';
}

final class _AuthCancelledException extends AuthException {
  const _AuthCancelledException({super.cause})
    : super._(
        reason: AuthFailureReason.cancelled,
        message: 'Authentication was cancelled.',
      );
}

final class _AuthConfigurationException extends AuthException {
  const _AuthConfigurationException({
    required super.message,
    super.cause,
  }) : super._(reason: AuthFailureReason.configuration);
}

final class _AuthInvalidResponseException extends AuthException {
  const _AuthInvalidResponseException({
    required super.message,
    super.cause,
  }) : super._(reason: AuthFailureReason.invalidResponse);
}

final class _AuthRemoteFailureException extends AuthException {
  const _AuthRemoteFailureException({
    required super.message,
    super.cause,
  }) : super._(reason: AuthFailureReason.remoteFailure);
}

final class _AuthUnexpectedException extends AuthException {
  const _AuthUnexpectedException({super.cause})
    : super._(
        reason: AuthFailureReason.unexpected,
        message: 'Unexpected authentication failure.',
      );
}
