import 'package:flutter/foundation.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';

/// Handles async initialisation steps that must complete before `runApp`.
///
/// Add platform-channel setup, logging configuration, remote-config fetches,
/// or any SDK initialisations here. Keep this class free of UI dependencies.
///
/// Usage: call [AppInitializer.initialize] inside `bootstrap`.
final class AppInitializer {
  const AppInitializer._();

  /// Runs all initialisation steps sequentially.
  ///
  /// Errors thrown here will propagate to `bootstrap` and crash the app
  /// early with a meaningful message rather than silently swallowing them.
  static Future<void> initialize(final AppConfig config) async {
    _configureLogging(config);
    // Future slots: analytics, crash-reporting, remote-config, etc.
  }

  static void _configureLogging(final AppConfig config) {
    if (config.debugMode && kDebugMode) {
      // ignore: avoid_print — intentional debug output during initialisation.
      debugPrint('[AppInitializer] Running in ${config.environment.name} mode');
    }
  }
}
