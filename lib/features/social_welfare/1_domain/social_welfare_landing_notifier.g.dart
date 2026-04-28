// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_welfare_landing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocialWelfareLandingNotifier)
const socialWelfareLandingProvider = SocialWelfareLandingNotifierProvider._();

final class SocialWelfareLandingNotifierProvider
    extends
        $AsyncNotifierProvider<
          SocialWelfareLandingNotifier,
          SocialWelfareSnapshot
        > {
  const SocialWelfareLandingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialWelfareLandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialWelfareLandingNotifierHash();

  @$internal
  @override
  SocialWelfareLandingNotifier create() => SocialWelfareLandingNotifier();
}

String _$socialWelfareLandingNotifierHash() =>
    r'6e621a5269c6db5ed9fb5266825bfa62ee144d91';

abstract class _$SocialWelfareLandingNotifier
    extends $AsyncNotifier<SocialWelfareSnapshot> {
  FutureOr<SocialWelfareSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<SocialWelfareSnapshot>, SocialWelfareSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SocialWelfareSnapshot>,
                SocialWelfareSnapshot
              >,
              AsyncValue<SocialWelfareSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
