enum AuthFailureReason {
  cancelled,
  configuration,

  /// Se pidió una sesión de navegador **aislada** y el navegador del
  /// dispositivo no puede darla.
  ///
  /// El fork lo lanza **antes de abrir nada**, en vez de compartir el
  /// contenedor en silencio — que es lo peor que podría pasar aquí, porque el
  /// aislamiento es justamente lo que se está comprando. Quien llama puede
  /// reintentar sin aislamiento, avisando al ciudadano.
  ephemeralUnavailable,
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

  const factory AuthException.ephemeralUnavailable({
    final Object? cause,
  }) = _AuthEphemeralUnavailableException;

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

final class _AuthEphemeralUnavailableException extends AuthException {
  const _AuthEphemeralUnavailableException({super.cause})
    : super._(
        reason: AuthFailureReason.ephemeralUnavailable,
        message: 'The browser cannot provide an ephemeral (isolated) session.',
      );
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
