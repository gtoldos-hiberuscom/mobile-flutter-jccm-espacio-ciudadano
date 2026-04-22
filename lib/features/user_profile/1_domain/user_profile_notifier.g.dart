// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfileNotifier)
const userProfileNotifierProvider = UserProfileNotifierProvider._();

final class UserProfileNotifierProvider
    extends $AsyncNotifierProvider<UserProfileNotifier, UserProfile?> {
  const UserProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileNotifierProvider',
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

String _$userProfileNotifierHash() => r'e4f2a1b3c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0';

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
