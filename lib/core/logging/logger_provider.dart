import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/console_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/log_level.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

/// Provides the application-level [AppLogger] singleton.
///
/// - **Debug builds**: returns a [ConsoleLogger] at [LogLevel.debug] so all
///   messages are visible during development.
/// - **Release builds**: returns a [ConsoleLogger] at [LogLevel.error] so
///   only errors reach the console — verbose diagnostics are suppressed.
///
/// Future sprint: swap the release-mode implementation for a remote
/// crash-reporting adapter (e.g. Firebase Crashlytics) without changing
/// call-sites.
@Riverpod(keepAlive: true)
AppLogger appLogger(final Ref ref) {
  return kReleaseMode ? const ConsoleLogger(level: LogLevel.error) : const ConsoleLogger();
}
