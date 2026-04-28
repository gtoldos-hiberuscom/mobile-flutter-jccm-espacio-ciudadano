// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_cards_exporter_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [DigitalCardsExporterRepository] (canon §16).
///
/// Kept alive for the lifetime of the app so the temp-file cache can be
/// reused across navigations.

@ProviderFor(digitalCardsExporterRepository)
const digitalCardsExporterRepositoryProvider =
    DigitalCardsExporterRepositoryProvider._();

/// DI composition for [DigitalCardsExporterRepository] (canon §16).
///
/// Kept alive for the lifetime of the app so the temp-file cache can be
/// reused across navigations.

final class DigitalCardsExporterRepositoryProvider
    extends
        $FunctionalProvider<
          DigitalCardsExporterRepository,
          DigitalCardsExporterRepository,
          DigitalCardsExporterRepository
        >
    with $Provider<DigitalCardsExporterRepository> {
  /// DI composition for [DigitalCardsExporterRepository] (canon §16).
  ///
  /// Kept alive for the lifetime of the app so the temp-file cache can be
  /// reused across navigations.
  const DigitalCardsExporterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'digitalCardsExporterRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$digitalCardsExporterRepositoryHash();

  @$internal
  @override
  $ProviderElement<DigitalCardsExporterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DigitalCardsExporterRepository create(Ref ref) {
    return digitalCardsExporterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DigitalCardsExporterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DigitalCardsExporterRepository>(
        value,
      ),
    );
  }
}

String _$digitalCardsExporterRepositoryHash() =>
    r'361168a0140a7806d21a5cf9bbdc9df0b52a8943';
