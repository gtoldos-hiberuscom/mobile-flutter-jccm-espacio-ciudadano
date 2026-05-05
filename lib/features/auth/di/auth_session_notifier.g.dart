// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthSessionNotifier)
const authSessionProvider = AuthSessionNotifierProvider._();

final class AuthSessionNotifierProvider extends $NotifierProvider<AuthSessionNotifier, AuthSession?> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSession?>(value),
    );
  }
}

String _$authSessionNotifierHash() => r'5b05d62a3a7a367475bf592fa6c4584dc316a846';

abstract class _$AuthSessionNotifier extends $Notifier<AuthSession?> {
  AuthSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthSession?, AuthSession?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AuthSession?, AuthSession?>, AuthSession?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
