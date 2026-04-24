// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expediente_detail_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [ExpedienteDetailRepository] (STORY-35).

@ProviderFor(expedienteDetailRepository)
const expedienteDetailRepositoryProvider =
    ExpedienteDetailRepositoryProvider._();

/// DI composition for [ExpedienteDetailRepository] (STORY-35).

final class ExpedienteDetailRepositoryProvider
    extends
        $FunctionalProvider<
          ExpedienteDetailRepository,
          ExpedienteDetailRepository,
          ExpedienteDetailRepository
        >
    with $Provider<ExpedienteDetailRepository> {
  /// DI composition for [ExpedienteDetailRepository] (STORY-35).
  const ExpedienteDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expedienteDetailRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expedienteDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpedienteDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpedienteDetailRepository create(Ref ref) {
    return expedienteDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpedienteDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpedienteDetailRepository>(value),
    );
  }
}

String _$expedienteDetailRepositoryHash() =>
    r'04c1cef71ac02004dba10e785680d0c20e2b3f0d';
