import 'package:jccm_espacio_ciudadano/features/auth/auth.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_session_notifier.dart' show AuthSessionNotifier;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'landing_notifier.g.dart';

/// UI state for the public landing screen login flow.
final class LandingState {
  const LandingState({
    this.isLoggingIn = false,
    this.error,
    this.loginSuccess = false,
  });

  final bool isLoggingIn;

  /// Non-null when login failed with a non-cancellation error.
  final AuthException? error;

  /// One-shot signal consumed by the page to trigger navigation.
  final bool loginSuccess;
}

/// Owns the login flow state for the public landing screen.
///
/// Orchestration: UI -> [login] -> [AuthSessionNotifier.login] -> [LandingState].
/// Navigation is triggered by the page via [ref.listen] on [loginSuccess].
@riverpod
class LandingNotifier extends _$LandingNotifier {
  @override
  LandingState build() => const LandingState();

  Future<void> login() async {
    if (state.isLoggingIn) return;
    state = const LandingState(isLoggingIn: true);
    try {
      await ref.read(loginUseCaseProvider).call();
      state = const LandingState(loginSuccess: true);
    } on AuthException catch (e) {
      // Cancellations are silent — user deliberately dismissed the flow.
      state = e.reason == AuthFailureReason.cancelled ? const LandingState() : LandingState(error: e);
    } catch (e) {
      state = LandingState(error: AuthException.unexpected(cause: e));
    }
  }

  void clearError() => state = const LandingState();
}
