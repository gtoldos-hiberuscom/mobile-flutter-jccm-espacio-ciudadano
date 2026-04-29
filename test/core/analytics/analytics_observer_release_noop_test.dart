import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/console_analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';

void main() {
  group('ConsoleAnalyticsService release-mode contract', () {
    test('logEvent and setCurrentScreen are complete no-ops when releaseMode=true', () {
      final logger = _StrictLogger();
      ConsoleAnalyticsService(logger: logger, releaseMode: true)
        // Both entrypoints must produce zero log calls.
        ..logEvent(const PageViewEvent('/home'))
        ..setCurrentScreen(AnalyticsScreen.home);

      // Sanity: if the strict logger had been touched, it would have
      // failed the test from inside its overrides — but assert it
      // explicitly here too in case the contract is silently relaxed.
      expect(logger.touched, isFalse);
    });

    test('debug-mode path still emits (control)', () {
      final logger = _RecordingLogger();
      // ignore: avoid_redundant_argument_values — explicit for contract clarity
      ConsoleAnalyticsService(logger: logger, releaseMode: false)
        ..logEvent(const PageViewEvent('/home'))
        ..setCurrentScreen(AnalyticsScreen.home);

      expect(logger.messages, hasLength(2));
    });
  });
}

/// Logger that fails the surrounding test if any of its methods is
/// invoked. Used to encode the release-mode "zero emission" contract
/// as an unforgeable assertion.
class _StrictLogger implements AppLogger {
  bool touched = false;

  Never _fail(final String level, final String message) {
    touched = true;
    fail('ConsoleAnalyticsService leaked a $level call in releaseMode=true: "$message"');
  }

  @override
  void debug(final String message, {final Map<String, Object?>? context}) => _fail('debug', message);

  @override
  void info(final String message, {final Map<String, Object?>? context}) => _fail('info', message);

  @override
  void warning(final String message, {final Map<String, Object?>? context}) => _fail('warning', message);

  @override
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) => _fail('error', message);
}

class _RecordingLogger implements AppLogger {
  final List<String> messages = <String>[];

  @override
  void debug(final String message, {final Map<String, Object?>? context}) => messages.add(message);

  @override
  void info(final String message, {final Map<String, Object?>? context}) => messages.add(message);

  @override
  void warning(final String message, {final Map<String, Object?>? context}) => messages.add(message);

  @override
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) => messages.add(message);
}
