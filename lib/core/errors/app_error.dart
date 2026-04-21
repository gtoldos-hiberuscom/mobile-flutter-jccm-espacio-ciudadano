// lib/core/errors/app_error.dart

/// Base sealed class for all application-level errors.
///
/// Use these types in domain use-case return values (e.g. `Either`) to signal
/// recoverable failures. Do not throw these directly; surface them as values.
sealed class AppError {
  const AppError({required this.message});

  /// Human-readable description of the error.
  final String message;
}

/// Represents a network-level failure.
final class NetworkError extends AppError {
  const NetworkError({required super.message, this.statusCode});

  /// HTTP status code if available.
  final int? statusCode;
}

/// Indicates the session has expired or the user is not authorised.
final class UnauthorizedError extends AppError {
  const UnauthorizedError() : super(message: 'Session expired');
}

/// The requested resource was not found.
final class NotFoundError extends AppError {
  const NotFoundError({required super.message});
}

/// A catch-all for errors that do not fit any of the above categories.
final class UnknownError extends AppError {
  const UnknownError({required super.message});
}
