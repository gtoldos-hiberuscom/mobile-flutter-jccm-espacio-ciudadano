// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_consent_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [DataConsentRepository].

@ProviderFor(dataConsentRepository)
const dataConsentRepositoryProvider = DataConsentRepositoryProvider._();

/// DI composition for [DataConsentRepository].

final class DataConsentRepositoryProvider
    extends
        $FunctionalProvider<
          DataConsentRepository,
          DataConsentRepository,
          DataConsentRepository
        >
    with $Provider<DataConsentRepository> {
  /// DI composition for [DataConsentRepository].
  const DataConsentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataConsentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataConsentRepositoryHash();

  @$internal
  @override
  $ProviderElement<DataConsentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DataConsentRepository create(Ref ref) {
    return dataConsentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataConsentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataConsentRepository>(value),
    );
  }
}

String _$dataConsentRepositoryHash() =>
    r'45ac7ecd28b3eebe530aa88ff17b06865b63e408';
