// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authSessionRepository)
const authSessionRepositoryProvider = AuthSessionRepositoryProvider._();

final class AuthSessionRepositoryProvider extends $FunctionalProvider<AuthSessionRepository, AuthSessionRepository, AuthSessionRepository> with $Provider<AuthSessionRepository> {
  const AuthSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthSessionRepository create(Ref ref) {
    return authSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSessionRepository>(value),
    );
  }
}

String _$authSessionRepositoryHash() => r'e63c32be2c2f49d934f9d14610b413898bbbc7b1';
