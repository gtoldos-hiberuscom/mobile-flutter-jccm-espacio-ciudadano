// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reactive view of the persisted [AuthSessionState].
///
/// Pure exposition: no business logic, no I/O. The notifier subscribes to
/// `AuthSessionRepository.watch()` and rebuilds whenever a use case
/// (`LoginUseCase`, `LogoutUseCase`) mutates the persisted session.

@ProviderFor(AuthSessionNotifier)
const authSessionProvider = AuthSessionNotifierProvider._();

/// Reactive view of the persisted [AuthSessionState].
///
/// Pure exposition: no business logic, no I/O. The notifier subscribes to
/// `AuthSessionRepository.watch()` and rebuilds whenever a use case
/// (`LoginUseCase`, `LogoutUseCase`) mutates the persisted session.
final class AuthSessionNotifierProvider
    extends $AsyncNotifierProvider<AuthSessionNotifier, AuthSessionState> {
  /// Reactive view of the persisted [AuthSessionState].
  ///
  /// Pure exposition: no business logic, no I/O. The notifier subscribes to
  /// `AuthSessionRepository.watch()` and rebuilds whenever a use case
  /// (`LoginUseCase`, `LogoutUseCase`) mutates the persisted session.
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
    r'0bf72bf96773ce4aa505595c50ddf7c0941cdee9';

/// Reactive view of the persisted [AuthSessionState].
///
/// Pure exposition: no business logic, no I/O. The notifier subscribes to
/// `AuthSessionRepository.watch()` and rebuilds whenever a use case
/// (`LoginUseCase`, `LogoutUseCase`) mutates the persisted session.

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

/// Convenience: returns the active [AuthTokens] or \`null\`.

@ProviderFor(currentAuthSession)
const currentAuthSessionProvider = CurrentAuthSessionProvider._();

/// Convenience: returns the active [AuthTokens] or \`null\`.

final class CurrentAuthSessionProvider
    extends $FunctionalProvider<AuthTokens?, AuthTokens?, AuthTokens?>
    with $Provider<AuthTokens?> {
  /// Convenience: returns the active [AuthTokens] or \`null\`.
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
  $ProviderElement<AuthTokens?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthTokens? create(Ref ref) {
    return currentAuthSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthTokens? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthTokens?>(value),
    );
  }
}

String _$currentAuthSessionHash() =>
    r'887d42c8ade48e2a39e6e1c3343227e1738befe2';

/// Convenience: returns the active [AuthUser] or \`null\`.

@ProviderFor(currentAuthUser)
const currentAuthUserProvider = CurrentAuthUserProvider._();

/// Convenience: returns the active [AuthUser] or \`null\`.

final class CurrentAuthUserProvider
    extends $FunctionalProvider<AuthUser?, AuthUser?, AuthUser?>
    with $Provider<AuthUser?> {
  /// Convenience: returns the active [AuthUser] or \`null\`.
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

String _$currentAuthUserHash() => r'453d7295a10af754e024cadc11a2fe5a8f1dae68';

/// Convenience: returns the citizen's \`idAgente\` (NIF / sub) or \`null\`.
///
/// Canonical entry point for feature code that needs the document
/// identifier — recommendations, hechos vitales, firma, etc.

@ProviderFor(currentIdAgente)
const currentIdAgenteProvider = CurrentIdAgenteProvider._();

/// Convenience: returns the citizen's \`idAgente\` (NIF / sub) or \`null\`.
///
/// Canonical entry point for feature code that needs the document
/// identifier — recommendations, hechos vitales, firma, etc.

final class CurrentIdAgenteProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Convenience: returns the citizen's \`idAgente\` (NIF / sub) or \`null\`.
  ///
  /// Canonical entry point for feature code that needs the document
  /// identifier — recommendations, hechos vitales, firma, etc.
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

String _$currentIdAgenteHash() => r'9f50868d561172d4985a1fe09b9e1e6e8b0e293c';
