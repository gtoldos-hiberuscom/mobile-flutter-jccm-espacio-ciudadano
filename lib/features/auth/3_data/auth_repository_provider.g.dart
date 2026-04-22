// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [AuthRepository] implementation.
///
/// Kept alive for the full app lifetime so the auth lifecycle is always
/// available without re-creating the notifier on navigation changes.

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

/// Provides the singleton [AuthRepository] implementation.
///
/// Kept alive for the full app lifetime so the auth lifecycle is always
/// available without re-creating the notifier on navigation changes.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Provides the singleton [AuthRepository] implementation.
  ///
  /// Kept alive for the full app lifetime so the auth lifecycle is always
  /// available without re-creating the notifier on navigation changes.
  const AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'7cc7db53a75e6172903216f879748b4201c6d5dc';
