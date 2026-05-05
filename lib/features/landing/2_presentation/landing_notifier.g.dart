// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the login flow state for the public landing screen.
///
/// Orchestration: UI -> [login] -> [AuthSessionNotifier.login] -> [LandingState].
/// Navigation is triggered by the page via [ref.listen] on [loginSuccess].

@ProviderFor(LandingNotifier)
const landingProvider = LandingNotifierProvider._();

/// Owns the login flow state for the public landing screen.
///
/// Orchestration: UI -> [login] -> [AuthSessionNotifier.login] -> [LandingState].
/// Navigation is triggered by the page via [ref.listen] on [loginSuccess].
final class LandingNotifierProvider extends $NotifierProvider<LandingNotifier, LandingState> {
  /// Owns the login flow state for the public landing screen.
  ///
  /// Orchestration: UI -> [login] -> [AuthSessionNotifier.login] -> [LandingState].
  /// Navigation is triggered by the page via [ref.listen] on [loginSuccess].
  const LandingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'landingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$landingNotifierHash();

  @$internal
  @override
  LandingNotifier create() => LandingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LandingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LandingState>(value),
    );
  }
}

String _$landingNotifierHash() => r'643bc298708fbdd2a4e6ec697ed64db3bc4b2c77';

/// Owns the login flow state for the public landing screen.
///
/// Orchestration: UI -> [login] -> [AuthSessionNotifier.login] -> [LandingState].
/// Navigation is triggered by the page via [ref.listen] on [loginSuccess].

abstract class _$LandingNotifier extends $Notifier<LandingState> {
  LandingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LandingState, LandingState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<LandingState, LandingState>, LandingState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
