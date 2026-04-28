// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_welfare_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socialWelfareRepository)
const socialWelfareRepositoryProvider = SocialWelfareRepositoryProvider._();

final class SocialWelfareRepositoryProvider
    extends
        $FunctionalProvider<
          SocialWelfareRepository,
          SocialWelfareRepository,
          SocialWelfareRepository
        >
    with $Provider<SocialWelfareRepository> {
  const SocialWelfareRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialWelfareRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialWelfareRepositoryHash();

  @$internal
  @override
  $ProviderElement<SocialWelfareRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SocialWelfareRepository create(Ref ref) {
    return socialWelfareRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialWelfareRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialWelfareRepository>(value),
    );
  }
}

String _$socialWelfareRepositoryHash() =>
    r'5335dba5236fbb74552f37c01100b4031e8f96d1';
