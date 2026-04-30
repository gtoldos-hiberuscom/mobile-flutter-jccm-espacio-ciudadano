// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the user's authentication session in memory and synchronises it with
/// `SecureStorage` (encrypted at rest).
///
/// - `build()` rehydrates the session from `SecureStorage` on cold start.
/// - [signIn] runs the Cl@ve login flow, derives the [AuthUser] from the
///   `id_token`, persists tokens, and emits `AuthenticatedSession`.
/// - [signOut] revokes at the OIDC end-session endpoint, wipes
///   `SecureStorage`, and emits `UnauthenticatedSession`.
///
/// Feature code that needs the citizen document (DNI / NIE) reads
/// `currentIdAgenteProvider`; transversal flows that need the access token
/// (e.g. Dio auth interceptor) can watch `currentAuthSessionProvider`.

@ProviderFor(AuthSessionNotifier)
const authSessionProvider = AuthSessionNotifierProvider._();

/// Owns the user's authentication session in memory and synchronises it with
/// `SecureStorage` (encrypted at rest).
///
/// - `build()` rehydrates the session from `SecureStorage` on cold start.
/// - [signIn] runs the Cl@ve login flow, derives the [AuthUser] from the
///   `id_token`, persists tokens, and emits `AuthenticatedSession`.
/// - [signOut] revokes at the OIDC end-session endpoint, wipes
///   `SecureStorage`, and emits `UnauthenticatedSession`.
///
/// Feature code that needs the citizen document (DNI / NIE) reads
/// `currentIdAgenteProvider`; transversal flows that need the access token
/// (e.g. Dio auth interceptor) can watch `currentAuthSessionProvider`.
final class AuthSessionNotifierProvider
    extends $AsyncNotifierProvider<AuthSessionNotifier, AuthSessionState> {
  /// Owns the user's authentication session in memory and synchronises it with
  /// `SecureStorage` (encrypted at rest).
  ///
  /// - `build()` rehydrates the session from `SecureStorage` on cold start.
  /// - [signIn] runs the Cl@ve login flow, derives the [AuthUser] from the
  ///   `id_token`, persists tokens, and emits `AuthenticatedSession`.
  /// - [signOut] revokes at the OIDC end-session endpoint, wipes
  ///   `SecureStorage`, and emits `UnauthenticatedSession`.
  ///
  /// Feature code that needs the citizen document (DNI / NIE) reads
  /// `currentIdAgenteProvider`; transversal flows that need the access token
  /// (e.g. Dio auth interceptor) can watch `currentAuthSessionProvider`.
  const AuthSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionNotifierHash();

  @$internal
  @override
  AuthSessionNotifier create() => AuthSessionNotifier();
}

String _$authSessionNotifierHash() =>
    r'd9d040d66255da1c0d203c58d87aece28be08e97';

/// Owns the user's authentication session in memory and synchronises it with
/// `SecureStorage` (encrypted at rest).
///
/// - `build()` rehydrates the session from `SecureStorage` on cold start.
/// - [signIn] runs the Cl@ve login flow, derives the [AuthUser] from the
///   `id_token`, persists tokens, and emits `AuthenticatedSession`.
/// - [signOut] revokes at the OIDC end-session endpoint, wipes
///   `SecureStorage`, and emits `UnauthenticatedSession`.
///
/// Feature code that needs the citizen document (DNI / NIE) reads
/// `currentIdAgenteProvider`; transversal flows that need the access token
/// (e.g. Dio auth interceptor) can watch `currentAuthSessionProvider`.

abstract class _$AuthSessionNotifier extends $AsyncNotifier<AuthSessionState> {
  FutureOr<AuthSessionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AuthSessionState>, AuthSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSessionState>, AuthSessionState>,
              AsyncValue<AuthSessionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Convenience: returns the active [AuthSession] or `null`.

@ProviderFor(currentAuthSession)
const currentAuthSessionProvider = CurrentAuthSessionProvider._();

/// Convenience: returns the active [AuthSession] or `null`.

final class CurrentAuthSessionProvider
    extends $FunctionalProvider<AuthSession?, AuthSession?, AuthSession?>
    with $Provider<AuthSession?> {
  /// Convenience: returns the active [AuthSession] or `null`.
  const CurrentAuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAuthSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAuthSessionHash();

  @$internal
  @override
  $ProviderElement<AuthSession?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthSession? create(Ref ref) {
    return currentAuthSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSession?>(value),
    );
  }
}

String _$currentAuthSessionHash() =>
    r'2198bbff856d4080ebd9dce788ff875305a0db8f';

/// Convenience: returns the active [AuthUser] or `null`.

@ProviderFor(currentAuthUser)
const currentAuthUserProvider = CurrentAuthUserProvider._();

/// Convenience: returns the active [AuthUser] or `null`.

final class CurrentAuthUserProvider
    extends $FunctionalProvider<AuthUser?, AuthUser?, AuthUser?>
    with $Provider<AuthUser?> {
  /// Convenience: returns the active [AuthUser] or `null`.
  const CurrentAuthUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAuthUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAuthUserHash();

  @$internal
  @override
  $ProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUser? create(Ref ref) {
    return currentAuthUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUser?>(value),
    );
  }
}

String _$currentAuthUserHash() => r'ca0984be976215be30d6b31011fdf7d61ca0bb9d';

/// Convenience: returns the citizen's `idAgente` (NIF / sub) or `null`.
///
/// This is the canonical entry point for feature code that needs the
/// document identifier — recommendations, hechos vitales, firma, etc.

@ProviderFor(currentIdAgente)
const currentIdAgenteProvider = CurrentIdAgenteProvider._();

/// Convenience: returns the citizen's `idAgente` (NIF / sub) or `null`.
///
/// This is the canonical entry point for feature code that needs the
/// document identifier — recommendations, hechos vitales, firma, etc.

final class CurrentIdAgenteProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Convenience: returns the citizen's `idAgente` (NIF / sub) or `null`.
  ///
  /// This is the canonical entry point for feature code that needs the
  /// document identifier — recommendations, hechos vitales, firma, etc.
  const CurrentIdAgenteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentIdAgenteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentIdAgenteHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentIdAgente(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentIdAgenteHash() => r'292d73c88db581d8842542129d9ea848ca119150';
