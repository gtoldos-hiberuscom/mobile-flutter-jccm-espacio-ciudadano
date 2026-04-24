import 'package:jccm_espacio_ciudadano/app/config/build_environment.dart';

/// Typed runtime configuration for the application.
///
/// An [AppConfig] instance is created from the environment-specific JSON file
/// at start-up and passed through `bootstrap` into the root widget tree.
/// No business logic or Flutter/UI imports belong here.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.appName,
    this.timeout = 30,
    this.debugMode = false,
  });

  /// The active [BuildEnvironment] for this run.
  final BuildEnvironment environment;

  /// Base URL for the remote API.
  final String baseUrl;

  /// Human-readable application name used in UI and analytics.
  final String appName;

  /// Network timeout in seconds.
  final int timeout;

  /// Whether verbose/debug logging is enabled.
  final bool debugMode;

  @override
  String toString() => 'AppConfig(env: ${environment.name}, baseUrl: $baseUrl, appName: $appName)';
}
