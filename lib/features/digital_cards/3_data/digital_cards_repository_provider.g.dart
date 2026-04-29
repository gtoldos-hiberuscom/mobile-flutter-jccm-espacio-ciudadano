// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_cards_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [DigitalCardsRepository] (canon §16).
///
/// Not kept alive on purpose: navigation back into the cards catalogue
/// should re-fetch the snapshot.

@ProviderFor(digitalCardsRepository)
const digitalCardsRepositoryProvider = DigitalCardsRepositoryProvider._();

/// DI composition for [DigitalCardsRepository] (canon §16).
///
/// Not kept alive on purpose: navigation back into the cards catalogue
/// should re-fetch the snapshot.

final class DigitalCardsRepositoryProvider extends $FunctionalProvider<DigitalCardsRepository, DigitalCardsRepository, DigitalCardsRepository> with $Provider<DigitalCardsRepository> {
  /// DI composition for [DigitalCardsRepository] (canon §16).
  ///
  /// Not kept alive on purpose: navigation back into the cards catalogue
  /// should re-fetch the snapshot.
  const DigitalCardsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'digitalCardsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$digitalCardsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DigitalCardsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DigitalCardsRepository create(Ref ref) {
    return digitalCardsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DigitalCardsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DigitalCardsRepository>(value),
    );
  }
}

String _$digitalCardsRepositoryHash() => r'9eb5ec2bfc5158290bbdfb201fca70194ef8441a';
