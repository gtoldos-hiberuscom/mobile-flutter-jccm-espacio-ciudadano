// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [AgendaRepository].
///
/// Not kept alive on purpose: the agenda is expected to refresh whenever
/// the user navigates back into the agenda surface (canon §16).

@ProviderFor(agendaRepository)
const agendaRepositoryProvider = AgendaRepositoryProvider._();

/// DI composition for [AgendaRepository].
///
/// Not kept alive on purpose: the agenda is expected to refresh whenever
/// the user navigates back into the agenda surface (canon §16).

final class AgendaRepositoryProvider
    extends
        $FunctionalProvider<
          AgendaRepository,
          AgendaRepository,
          AgendaRepository
        >
    with $Provider<AgendaRepository> {
  /// DI composition for [AgendaRepository].
  ///
  /// Not kept alive on purpose: the agenda is expected to refresh whenever
  /// the user navigates back into the agenda surface (canon §16).
  const AgendaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agendaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agendaRepositoryHash();

  @$internal
  @override
  $ProviderElement<AgendaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AgendaRepository create(Ref ref) {
    return agendaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgendaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgendaRepository>(value),
    );
  }
}

String _$agendaRepositoryHash() => r'4a8afb775da2971de5fca62e6372f17490965505';
