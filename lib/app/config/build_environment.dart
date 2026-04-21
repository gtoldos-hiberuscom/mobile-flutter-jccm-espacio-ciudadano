/// Defines the build environments supported by the application.
enum BuildEnvironment {
  development,
  preproduction,
  production;

  /// Returns true when running in a non-production environment.
  bool get isDebugCapable => this != BuildEnvironment.production;
}
