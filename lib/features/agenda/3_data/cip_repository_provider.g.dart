// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cip_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [CipRepository] (STORY-31).
///
/// Co-located in the agenda data layer per the TASK-71 surface decision
/// (CIP_REUSE — salud owns the CIP). Not kept alive on purpose: the
/// CIP snapshot should refresh on every visit to the agenda or salud
/// home entry (canon §16).

@ProviderFor(cipRepository)
const cipRepositoryProvider = CipRepositoryProvider._();

/// DI composition for [CipRepository] (STORY-31).
///
/// Co-located in the agenda data layer per the TASK-71 surface decision
/// (CIP_REUSE — salud owns the CIP). Not kept alive on purpose: the
/// CIP snapshot should refresh on every visit to the agenda or salud
/// home entry (canon §16).

final class CipRepositoryProvider extends $FunctionalProvider<CipRepository, CipRepository, CipRepository> with $Provider<CipRepository> {
  /// DI composition for [CipRepository] (STORY-31).
  ///
  /// Co-located in the agenda data layer per the TASK-71 surface decision
  /// (CIP_REUSE — salud owns the CIP). Not kept alive on purpose: the
  /// CIP snapshot should refresh on every visit to the agenda or salud
  /// home entry (canon §16).
  const CipRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cipRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cipRepositoryHash();

  @$internal
  @override
  $ProviderElement<CipRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CipRepository create(Ref ref) {
    return cipRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CipRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CipRepository>(value),
    );
  }
}

String _$cipRepositoryHash() => r'2b4f00ca4c29e1b7c588dbe0e45b52f0e9cb1a97';
