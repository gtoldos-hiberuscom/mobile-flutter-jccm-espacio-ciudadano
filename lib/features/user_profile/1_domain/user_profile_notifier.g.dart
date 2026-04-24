// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the currently logged-in user's profile.
///
/// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
///   [UserProfile]; otherwise returns `null`.
/// - [logout] delegates to [SessionNotifier.logout] then resets state.

@ProviderFor(UserProfileNotifier)
const userProfileProvider = UserProfileNotifierProvider._();

/// Manages the currently logged-in user's profile.
///
/// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
///   [UserProfile]; otherwise returns `null`.
/// - [logout] delegates to [SessionNotifier.logout] then resets state.
final class UserProfileNotifierProvider
    extends $AsyncNotifierProvider<UserProfileNotifier, UserProfile?> {
  /// Manages the currently logged-in user's profile.
  ///
  /// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
  ///   [UserProfile]; otherwise returns `null`.
  /// - [logout] delegates to [SessionNotifier.logout] then resets state.
  const UserProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileNotifierHash();

  @$internal
  @override
  UserProfileNotifier create() => UserProfileNotifier();
}

String _$userProfileNotifierHash() =>
    r'd3fe50aedb1e3de2f8a8d09641617f1076308129';

/// Manages the currently logged-in user's profile.
///
/// - On build: if [sessionStateProvider] has an idAgente, returns a scaffold
///   [UserProfile]; otherwise returns `null`.
/// - [logout] delegates to [SessionNotifier.logout] then resets state.

abstract class _$UserProfileNotifier extends $AsyncNotifier<UserProfile?> {
  FutureOr<UserProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserProfile?>, UserProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile?>, UserProfile?>,
              AsyncValue<UserProfile?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
