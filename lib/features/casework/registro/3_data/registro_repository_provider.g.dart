// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for the STORY-36 [RegistroRepository].

@ProviderFor(registroRepository)
const registroRepositoryProvider = RegistroRepositoryProvider._();

/// DI composition for the STORY-36 [RegistroRepository].

final class RegistroRepositoryProvider
    extends
        $FunctionalProvider<
          RegistroRepository,
          RegistroRepository,
          RegistroRepository
        >
    with $Provider<RegistroRepository> {
  /// DI composition for the STORY-36 [RegistroRepository].
  const RegistroRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registroRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registroRepositoryHash();

  @$internal
  @override
  $ProviderElement<RegistroRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegistroRepository create(Ref ref) {
    return registroRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistroRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistroRepository>(value),
    );
  }
}

String _$registroRepositoryHash() =>
    r'959cd691454cb4c39edceba82630ae8e5c48f25c';
