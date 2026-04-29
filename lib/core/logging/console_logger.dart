import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/log_level.dart';
import 'package:jccm_espacio_ciudadano/core/security/pii_key_fragments.dart';

// Sprint 9 conflict resolution (TASK-69 + STORY-64): the canonical PII
// fragment list moved to `lib/core/security/pii_key_fragments.dart` so
// both the logging sink and the analytics redaction wrapper share a
// single source of truth. The Sprint 9 / TASK-69 expansion (nif, email,
// phone, telefono, address, direccion, birth, nacimiento) is folded
// into that module — see `piiKeyFragments` and `redactFields(...)`.

/// Development-console implementation of [AppLogger].
///
/// - **Debug builds**: emits all levels using `debugPrint`.
/// - **Release builds**: only [LogLevel.error] and above are emitted;
///   [LogLevel.debug] calls are complete no-ops.
///
/// All context maps are sanitised via [_redact] before any output is produced.
final class ConsoleLogger implements AppLogger {
  const ConsoleLogger({this.level = LogLevel.debug});

  /// Minimum level to emit. Messages below this threshold are silently dropped.
  final LogLevel level;

  // ── Public API ──────────────────────────────────────────────────────────────

  @override
  void debug(final String message, {final Map<String, Object?>? context}) {
    if (kReleaseMode) {
      return; // complete no-op in release
    }
    _emit(LogLevel.debug, message, context: context);
  }

  @override
  void info(final String message, {final Map<String, Object?>? context}) {
    _emit(LogLevel.info, message, context: context);
  }

  @override
  void warning(final String message, {final Map<String, Object?>? context}) {
    _emit(LogLevel.warning, message, context: context);
  }

  @override
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {
    _emit(
      LogLevel.error,
      message,
      exception: exception,
      stackTrace: stackTrace,
      context: context,
    );
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  void _emit(
    final LogLevel emitLevel,
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {
    // Honour configured minimum level.
    if (emitLevel.index < level.index) {
      return;
    }

    final prefix = _prefix(emitLevel);
    final sanitised = _redact(context);

    final buffer = StringBuffer('$prefix $message');
    if (sanitised != null && sanitised.isNotEmpty) {
      buffer.write(' | context: $sanitised');
    }
    if (exception != null) {
      buffer.write(' | exception: $exception');
    }
    // ignore: avoid_print — intentional console output for development
    print(buffer);

    if (stackTrace != null) {
      // ignore: avoid_print
      print(stackTrace);
    }
  }

  static String _prefix(final LogLevel l) => switch (l) {
    LogLevel.debug => '[DEBUG]',
    LogLevel.info => '[INFO]',
    LogLevel.warning => '[WARN]',
    LogLevel.error => '[ERROR]',
  };

  /// Returns a copy of [context] with PII values replaced by `'[REDACTED]'`.
  ///
  /// Matching is case-insensitive substring on the **key** only —
  /// values are never inspected for PII patterns (too fragile; prefer
  /// never logging them in the first place).
  ///
  /// Delegates to [redactFields] so the fragment list stays in sync
  /// with all other sinks.
  static Map<String, Object?>? _redact(final Map<String, Object?>? context) {
    if (context == null) {
      return null;
    }
    return redactFields(context);
  }
}
