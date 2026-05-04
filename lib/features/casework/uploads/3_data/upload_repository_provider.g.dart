// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for the STORY-38 [UploadRepository].

@ProviderFor(uploadRepository)
const uploadRepositoryProvider = UploadRepositoryProvider._();

/// DI composition for the STORY-38 [UploadRepository].

final class UploadRepositoryProvider extends $FunctionalProvider<UploadRepository, UploadRepository, UploadRepository> with $Provider<UploadRepository> {
  /// DI composition for the STORY-38 [UploadRepository].
  const UploadRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadRepositoryHash();

  @$internal
  @override
  $ProviderElement<UploadRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  UploadRepository create(Ref ref) {
    return uploadRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadRepository>(value),
    );
  }
}

String _$uploadRepositoryHash() => r'7ddd1bb4570cd9a4b831d20c30c3ce1893d83db3';
