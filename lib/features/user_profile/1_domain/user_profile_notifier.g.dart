// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   `authSessionProvider`. Returns `null` when there is no session.
/// - [logout] delegates to [LogoutUseCase], which terminates the Cl@ve
///   session and clears the persisted local data.

@ProviderFor(UserProfileNotifier)
const userProfileProvider = UserProfileNotifierProvider._();

/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   `authSessionProvider`. Returns `null` when there is no session.
/// - [logout] delegates to [LogoutUseCase], which terminates the Cl@ve
///   session and clears the persisted local data.
final class UserProfileNotifierProvider extends $AsyncNotifierProvider<UserProfileNotifier, UserProfile?> {
  /// Manages the currently logged-in user's profile.
  ///
  /// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
  ///   `authSessionProvider`. Returns `null` when there is no session.
  /// - [logout] delegates to [LogoutUseCase], which terminates the Cl@ve
  ///   session and clears the persisted local data.
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

String _$userProfileNotifierHash() => r'd4f1447a2bb4aefa544b96b6cc096fdc7762151f';

/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   `authSessionProvider`. Returns `null` when there is no session.
/// - [logout] delegates to [LogoutUseCase], which terminates the Cl@ve
///   session and clears the persisted local data.

abstract class _$UserProfileNotifier extends $AsyncNotifier<UserProfile?> {
  FutureOr<UserProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserProfile?>, UserProfile?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<UserProfile?>, UserProfile?>, AsyncValue<UserProfile?>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
