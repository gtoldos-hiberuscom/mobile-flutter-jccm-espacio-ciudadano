import 'package:go_router/go_router.dart';

/// Session-based navigation guard.
///
/// Implement redirect logic here once the auth domain is available (STORY-12).
/// Returns null to allow navigation, or a path string to redirect.
final class SessionGuard {
  const SessionGuard();

  /// GoRouter redirect callback.
  ///
  /// Currently a no-op placeholder — always allows navigation.
  String? redirect(final GoRouterState state) => null;
}
