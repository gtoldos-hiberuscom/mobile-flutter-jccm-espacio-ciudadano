// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_events_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the life-events selection state for a given `idAgente` (STORY-54).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).

@ProviderFor(LifeEventsNotifier)
const lifeEventsProvider = LifeEventsNotifierFamily._();

/// Owns the life-events selection state for a given `idAgente` (STORY-54).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).
final class LifeEventsNotifierProvider
    extends $AsyncNotifierProvider<LifeEventsNotifier, LifeEventsSelection> {
  /// Owns the life-events selection state for a given `idAgente` (STORY-54).
  ///
  /// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
  /// story (depends on TASK-21 idAgente closure).
  const LifeEventsNotifierProvider._({
    required LifeEventsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lifeEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lifeEventsNotifierHash();

  @override
  String toString() {
    return r'lifeEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LifeEventsNotifier create() => LifeEventsNotifier();

  @override
  bool operator ==(Object other) {
    return other is LifeEventsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lifeEventsNotifierHash() =>
    r'8ba3331c64bf10d10683d6e8976230d9498820b3';

/// Owns the life-events selection state for a given `idAgente` (STORY-54).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).

final class LifeEventsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LifeEventsNotifier,
          AsyncValue<LifeEventsSelection>,
          LifeEventsSelection,
          FutureOr<LifeEventsSelection>,
          String
        > {
  const LifeEventsNotifierFamily._()
    : super(
        retry: null,
        name: r'lifeEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns the life-events selection state for a given `idAgente` (STORY-54).
  ///
  /// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
  /// story (depends on TASK-21 idAgente closure).

  LifeEventsNotifierProvider call(String idAgente) =>
      LifeEventsNotifierProvider._(argument: idAgente, from: this);

  @override
  String toString() => r'lifeEventsProvider';
}

/// Owns the life-events selection state for a given `idAgente` (STORY-54).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).

abstract class _$LifeEventsNotifier
    extends $AsyncNotifier<LifeEventsSelection> {
  late final _$args = ref.$arg as String;
  String get idAgente => _$args;

  FutureOr<LifeEventsSelection> build(String idAgente);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<LifeEventsSelection>, LifeEventsSelection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LifeEventsSelection>, LifeEventsSelection>,
              AsyncValue<LifeEventsSelection>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
