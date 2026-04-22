import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Session state for the currently authenticated user.
///
/// `null`  → not logged in  
/// non-null string → opaque session token / user identifier
///
/// This is a keepAlive placeholder that will be replaced by the full auth
/// domain implementation in the auth feature story. The notifier intentionally
/// starts unauthenticated so guards redirect to the landing page.
class SessionStateNotifier extends Notifier<String?> {
  @override
  String? build() => null; // null = not logged in

  /// Sets the active session token (called from the login callback).
  // ignore: use_setters_to_change_properties
  void establish(final String token) => state = token;

  /// Clears the session (called on logout or token expiry).
  // ignore: use_setters_to_change_properties
  void invalidate() => state = null;
}

/// Global session-state provider.
///
/// Kept alive for the full lifetime of the app so guards always have access
/// to the current authentication state without recreating the notifier on
/// every navigation event.
final sessionStateProvider =
    NotifierProvider<SessionStateNotifier, String?>(
  SessionStateNotifier.new,
);
