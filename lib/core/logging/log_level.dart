/// Severity levels for `AppLogger`.
///
/// Ordered from most-verbose to most-severe so numeric comparison works:
/// `level.index >= LogLevel.warning.index`.
enum LogLevel {
  /// Fine-grained diagnostic information; disabled in release builds.
  debug,

  /// General informational messages about application flow.
  info,

  /// Potentially harmful situations that do not prevent execution.
  warning,

  /// Errors that may require attention; always emitted even in release builds.
  error,
}
