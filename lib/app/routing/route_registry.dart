/// Route path constants used across the application.
///
/// Keep all route strings in one place to prevent typos and enable
/// compile-time refactoring. This file must not import Flutter or Riverpod.
abstract final class RouteRegistry {
  /// Splash / initial route.
  static const String root = '/';

  /// Placeholder home route — replace in STORY-13.
  static const String home = '/home';
}
