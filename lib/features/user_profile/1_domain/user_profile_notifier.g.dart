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
///   [authSessionNotifierProvider]. Returns `null` when there is no session.
/// - [logout] delegates to [AuthSessionNotifier.signOut], which clears all
///   secure storage and resets session state.

@ProviderFor(UserProfileNotifier)
const userProfileProvider = UserProfileNotifierProvider._();

/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   [authSessionNotifierProvider]. Returns `null` when there is no session.
/// - [logout] delegates to [AuthSessionNotifier.signOut], which clears all
///   secure storage and resets session state.
final class UserProfileNotifierProvider
    extends $AsyncNotifierProvider<UserProfileNotifier, UserProfile?> {
  /// Manages the currently logged-in user's profile.
  ///
  /// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
  ///   [authSessionNotifierProvider]. Returns `null` when there is no session.
  /// - [logout] delegates to [AuthSessionNotifier.signOut], which clears all
  ///   secure storage and resets session state.
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
    r'eae985ce75f2592f114f14c2c8d6651e6a3698c2';

/// Manages the currently logged-in user's profile.
///
/// - On build: derives a [UserProfile] from the active [AuthUser] exposed by
///   [authSessionNotifierProvider]. Returns `null` when there is no session.
/// - [logout] delegates to [AuthSessionNotifier.signOut], which clears all
///   secure storage and resets session state.

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
