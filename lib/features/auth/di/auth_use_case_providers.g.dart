// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_use_case_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [LoginUseCase].
///
/// Injects the notifiers so the use case can persist the session and user
/// in memory. Also passes the SecureStorage so the access token is written
/// there, making it available to [AuthInterceptor] for subsequent requests.

@ProviderFor(loginUseCase)
const loginUseCaseProvider = LoginUseCaseProvider._();

/// DI composition for [LoginUseCase].
///
/// Injects the notifiers so the use case can persist the session and user
/// in memory. Also passes the SecureStorage so the access token is written
/// there, making it available to [AuthInterceptor] for subsequent requests.

final class LoginUseCaseProvider extends $FunctionalProvider<LoginUseCase, LoginUseCase, LoginUseCase> with $Provider<LoginUseCase> {
  /// DI composition for [LoginUseCase].
  ///
  /// Injects the notifiers so the use case can persist the session and user
  /// in memory. Also passes the SecureStorage so the access token is written
  /// there, making it available to [AuthInterceptor] for subsequent requests.
  const LoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoginUseCase> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  LoginUseCase create(Ref ref) {
    return loginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUseCase>(value),
    );
  }
}

String _$loginUseCaseHash() => r'2961de0305e8c31b42bdbf765e777b3513f0b2c0';

/// DI composition for [LogoutUseCase].

@ProviderFor(logoutUseCase)
const logoutUseCaseProvider = LogoutUseCaseProvider._();

/// DI composition for [LogoutUseCase].

final class LogoutUseCaseProvider extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase> with $Provider<LogoutUseCase> {
  /// DI composition for [LogoutUseCase].
  const LogoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'a52b00ac1ff9010f47f7e4a61ea6a48f7d412b13';
