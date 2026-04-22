/// Contract for application-level loggers.
///
/// Implementations must:
/// - Redact any context value whose key matches a known PII pattern
///   (see §26 security annex and `docs/security/pii-inventory.md`).
/// - Never emit `debug` messages in release builds.
/// - Always emit `error` messages regardless of build flavour.
///
/// The interface has no Flutter or BuildContext dependency so it can be used
/// from any architectural layer.
abstract interface class AppLogger {
  /// Logs a fine-grained diagnostic message.
  ///
  /// No-op in release builds.
  void debug(final String message, {final Map<String, Object?>? context});

  /// Logs a general informational message about application flow.
  void info(final String message, {final Map<String, Object?>? context});

  /// Logs a potentially harmful situation that does not prevent execution.
  void warning(final String message, {final Map<String, Object?>? context});

  /// Logs an error with an optional exception and stack trace.
  ///
  /// Always emitted — even in release builds — because errors require
  /// operational visibility.
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  });
}
