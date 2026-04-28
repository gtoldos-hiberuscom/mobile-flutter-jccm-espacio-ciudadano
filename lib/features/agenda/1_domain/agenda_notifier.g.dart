// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the agenda screen state (snapshot + temporal filter + calendar
/// month + selected day).
///
/// On `build()` it asks the repository for a snapshot and rebuilds the
/// state machine around it. UI mutators ([setPeriod], [setMonth],
/// [selectDay], [clearSelectedDay]) only mutate the in-memory view-model
/// — they never re-fetch (use [refresh] for that).

@ProviderFor(AgendaNotifier)
const agendaProvider = AgendaNotifierProvider._();

/// Owns the agenda screen state (snapshot + temporal filter + calendar
/// month + selected day).
///
/// On `build()` it asks the repository for a snapshot and rebuilds the
/// state machine around it. UI mutators ([setPeriod], [setMonth],
/// [selectDay], [clearSelectedDay]) only mutate the in-memory view-model
/// — they never re-fetch (use [refresh] for that).
final class AgendaNotifierProvider extends $AsyncNotifierProvider<AgendaNotifier, AgendaState> {
  /// Owns the agenda screen state (snapshot + temporal filter + calendar
  /// month + selected day).
  ///
  /// On `build()` it asks the repository for a snapshot and rebuilds the
  /// state machine around it. UI mutators ([setPeriod], [setMonth],
  /// [selectDay], [clearSelectedDay]) only mutate the in-memory view-model
  /// — they never re-fetch (use [refresh] for that).
  const AgendaNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agendaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agendaNotifierHash();

  @$internal
  @override
  AgendaNotifier create() => AgendaNotifier();
}

String _$agendaNotifierHash() => r'3d105a1d7333c990aa5e877df5d8d4392711585a';

/// Owns the agenda screen state (snapshot + temporal filter + calendar
/// month + selected day).
///
/// On `build()` it asks the repository for a snapshot and rebuilds the
/// state machine around it. UI mutators ([setPeriod], [setMonth],
/// [selectDay], [clearSelectedDay]) only mutate the in-memory view-model
/// — they never re-fetch (use [refresh] for that).

abstract class _$AgendaNotifier extends $AsyncNotifier<AgendaState> {
  FutureOr<AgendaState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AgendaState>, AgendaState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<AgendaState>, AgendaState>, AsyncValue<AgendaState>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
