import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/log_level.dart';

/// PII-redacted patterns for context map keys (case-insensitive substring match).
///
/// Any context entry whose key contains one of these fragments will have its
/// value replaced with `'[REDACTED]'` before emission.
///
/// Sourced from `docs/security/pii-inventory.md` RED/AMBER classifications and
/// from a sweep of DTO/state field names used across the feature layers
/// (auth, agenda/sescam, social_welfare, state_affairs, digital_cards,
/// notifications/contact). Fragments are deliberately narrow substrings —
/// generic words such as `'date'` or `'fecha'` are excluded to avoid
/// over-redaction of non-PII metadata (e.g., `dateFormat`, `fechaInicio`
/// of a public event).
///
/// Defense-in-depth only: the primary control is "never put raw PII in
/// the log call" (see `docs/security/security-hardening.md` §5.3).
const _kPiiKeyFragments = <String>[
  // Session / authentication
  'token',
  'id',
  'name',
  // National identifiers
  'nif',
  'dni',
  'nss',
  // Vehicles / driving
  'plate',
  'license',
  'matricula',
  // Contact PII (notifications, support, profile)
  'email',
  'phone',
  'telefono',
  // Postal / cadastral PII
  'address',
  'direccion',
  // Birth / life-event PII
  'birth',
  'nacimiento',
];

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
  static Map<String, Object?>? _redact(final Map<String, Object?>? context) {
    if (context == null) {
      return null;
    }
    return {
      for (final entry in context.entries) entry.key: _isPiiKey(entry.key) ? '[REDACTED]' : entry.value,
    };
  }

  static bool _isPiiKey(final String key) {
    final lower = key.toLowerCase();
    return _kPiiKeyFragments.any(lower.contains);
  }
}
