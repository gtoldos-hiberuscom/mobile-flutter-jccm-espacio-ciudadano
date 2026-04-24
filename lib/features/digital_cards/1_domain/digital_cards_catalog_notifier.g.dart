// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_cards_catalog_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the digital cards catalogue screen state (STORY-48).
///
/// On `build()` it asks the repository for a catalogue snapshot; the UI
/// renders loading/loaded/empty/error from the resulting
/// [DigitalCardsCatalog]. Refresh forces a new fetch.

@ProviderFor(DigitalCardsCatalogNotifier)
const digitalCardsCatalogProvider = DigitalCardsCatalogNotifierProvider._();

/// Owns the digital cards catalogue screen state (STORY-48).
///
/// On `build()` it asks the repository for a catalogue snapshot; the UI
/// renders loading/loaded/empty/error from the resulting
/// [DigitalCardsCatalog]. Refresh forces a new fetch.
final class DigitalCardsCatalogNotifierProvider
    extends
        $AsyncNotifierProvider<
          DigitalCardsCatalogNotifier,
          DigitalCardsCatalog
        > {
  /// Owns the digital cards catalogue screen state (STORY-48).
  ///
  /// On `build()` it asks the repository for a catalogue snapshot; the UI
  /// renders loading/loaded/empty/error from the resulting
  /// [DigitalCardsCatalog]. Refresh forces a new fetch.
  const DigitalCardsCatalogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'digitalCardsCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$digitalCardsCatalogNotifierHash();

  @$internal
  @override
  DigitalCardsCatalogNotifier create() => DigitalCardsCatalogNotifier();
}

String _$digitalCardsCatalogNotifierHash() =>
    r'78ebb3df191535bfd0cb8e596496b374d8dc33a1';

/// Owns the digital cards catalogue screen state (STORY-48).
///
/// On `build()` it asks the repository for a catalogue snapshot; the UI
/// renders loading/loaded/empty/error from the resulting
/// [DigitalCardsCatalog]. Refresh forces a new fetch.

abstract class _$DigitalCardsCatalogNotifier
    extends $AsyncNotifier<DigitalCardsCatalog> {
  FutureOr<DigitalCardsCatalog> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<DigitalCardsCatalog>, DigitalCardsCatalog>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DigitalCardsCatalog>, DigitalCardsCatalog>,
              AsyncValue<DigitalCardsCatalog>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
