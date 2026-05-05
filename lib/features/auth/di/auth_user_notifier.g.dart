// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthUserNotifier)
const authUserProvider = AuthUserNotifierProvider._();

final class AuthUserNotifierProvider extends $NotifierProvider<AuthUserNotifier, AuthUser?> {
  const AuthUserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authUserNotifierHash();

  @$internal
  @override
  AuthUserNotifier create() => AuthUserNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUser?>(value),
    );
  }
}

String _$authUserNotifierHash() => r'99d07fe1fc8034075788f3090e50cf2ccb02b863';

abstract class _$AuthUserNotifier extends $Notifier<AuthUser?> {
  AuthUser? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthUser?, AuthUser?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AuthUser?, AuthUser?>, AuthUser?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
