// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod [AsyncNotifier] that manages the full authentication lifecycle.
///
/// ## State machine
/// ```
/// AuthUnauthenticated ──login()──► AuthLoading ──success──► AuthAuthenticated
///                                               └─failure──► AuthError
/// AuthAuthenticated ──logout()──► AuthUnauthenticated
/// AuthAuthenticated ──checkAndRefresh()──[expired]──► AuthLoading
///                                         ├─success──► AuthAuthenticated
///                                         └─failure──► AuthExpired
/// ```
///
/// ## sessionStateProvider bridge
/// Every state transition also updates [sessionStateProvider] so that the
/// GoRouter guard reacts to authentication changes without knowing about
/// the auth feature's internal structure.
///
/// ## PII policy
/// Token values and [Session.idAgente] are never logged. All `debugPrint`
/// calls are omitted from this file intentionally.

@ProviderFor(SessionNotifier)
const sessionProvider = SessionNotifierProvider._();

/// Riverpod [AsyncNotifier] that manages the full authentication lifecycle.
///
/// ## State machine
/// ```
/// AuthUnauthenticated ──login()──► AuthLoading ──success──► AuthAuthenticated
///                                               └─failure──► AuthError
/// AuthAuthenticated ──logout()──► AuthUnauthenticated
/// AuthAuthenticated ──checkAndRefresh()──[expired]──► AuthLoading
///                                         ├─success──► AuthAuthenticated
///                                         └─failure──► AuthExpired
/// ```
///
/// ## sessionStateProvider bridge
/// Every state transition also updates [sessionStateProvider] so that the
/// GoRouter guard reacts to authentication changes without knowing about
/// the auth feature's internal structure.
///
/// ## PII policy
/// Token values and [Session.idAgente] are never logged. All `debugPrint`
/// calls are omitted from this file intentionally.
final class SessionNotifierProvider extends $AsyncNotifierProvider<SessionNotifier, AuthState> {
  /// Riverpod [AsyncNotifier] that manages the full authentication lifecycle.
  ///
  /// ## State machine
  /// ```
  /// AuthUnauthenticated ──login()──► AuthLoading ──success──► AuthAuthenticated
  ///                                               └─failure──► AuthError
  /// AuthAuthenticated ──logout()──► AuthUnauthenticated
  /// AuthAuthenticated ──checkAndRefresh()──[expired]──► AuthLoading
  ///                                         ├─success──► AuthAuthenticated
  ///                                         └─failure──► AuthExpired
  /// ```
  ///
  /// ## sessionStateProvider bridge
  /// Every state transition also updates [sessionStateProvider] so that the
  /// GoRouter guard reacts to authentication changes without knowing about
  /// the auth feature's internal structure.
  ///
  /// ## PII policy
  /// Token values and [Session.idAgente] are never logged. All `debugPrint`
  /// calls are omitted from this file intentionally.
  const SessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionNotifierHash();

  @$internal
  @override
  SessionNotifier create() => SessionNotifier();
}

String _$sessionNotifierHash() => r'9d11bccf5fb76a6a33775be2649b54766de86fa7';

/// Riverpod [AsyncNotifier] that manages the full authentication lifecycle.
///
/// ## State machine
/// ```
/// AuthUnauthenticated ──login()──► AuthLoading ──success──► AuthAuthenticated
///                                               └─failure──► AuthError
/// AuthAuthenticated ──logout()──► AuthUnauthenticated
/// AuthAuthenticated ──checkAndRefresh()──[expired]──► AuthLoading
///                                         ├─success──► AuthAuthenticated
///                                         └─failure──► AuthExpired
/// ```
///
/// ## sessionStateProvider bridge
/// Every state transition also updates [sessionStateProvider] so that the
/// GoRouter guard reacts to authentication changes without knowing about
/// the auth feature's internal structure.
///
/// ## PII policy
/// Token values and [Session.idAgente] are never logged. All `debugPrint`
/// calls are omitted from this file intentionally.

abstract class _$SessionNotifier extends $AsyncNotifier<AuthState> {
  FutureOr<AuthState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AuthState>, AuthState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<AuthState>, AuthState>, AsyncValue<AuthState>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
