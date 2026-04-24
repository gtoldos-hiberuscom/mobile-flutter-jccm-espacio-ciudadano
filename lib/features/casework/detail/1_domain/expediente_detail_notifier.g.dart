// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expediente_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
/// (STORY-35).
///
/// One notifier instance per `numexp` — Riverpod's family semantics
/// keep navigation between detail pages cheap and isolated.

@ProviderFor(ExpedienteDetailNotifier)
const expedienteDetailProvider = ExpedienteDetailNotifierFamily._();

/// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
/// (STORY-35).
///
/// One notifier instance per `numexp` — Riverpod's family semantics
/// keep navigation between detail pages cheap and isolated.
final class ExpedienteDetailNotifierProvider
    extends $AsyncNotifierProvider<ExpedienteDetailNotifier, ExpedienteDetail> {
  /// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
  /// (STORY-35).
  ///
  /// One notifier instance per `numexp` — Riverpod's family semantics
  /// keep navigation between detail pages cheap and isolated.
  const ExpedienteDetailNotifierProvider._({
    required ExpedienteDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'expedienteDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expedienteDetailNotifierHash();

  @override
  String toString() {
    return r'expedienteDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExpedienteDetailNotifier create() => ExpedienteDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is ExpedienteDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expedienteDetailNotifierHash() =>
    r'104c37b36c4e055d957d7c08b6735c3167c08793';

/// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
/// (STORY-35).
///
/// One notifier instance per `numexp` — Riverpod's family semantics
/// keep navigation between detail pages cheap and isolated.

final class ExpedienteDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ExpedienteDetailNotifier,
          AsyncValue<ExpedienteDetail>,
          ExpedienteDetail,
          FutureOr<ExpedienteDetail>,
          String
        > {
  const ExpedienteDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'expedienteDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
  /// (STORY-35).
  ///
  /// One notifier instance per `numexp` — Riverpod's family semantics
  /// keep navigation between detail pages cheap and isolated.

  ExpedienteDetailNotifierProvider call(String numexp) =>
      ExpedienteDetailNotifierProvider._(argument: numexp, from: this);

  @override
  String toString() => r'expedienteDetailProvider';
}

/// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
/// (STORY-35).
///
/// One notifier instance per `numexp` — Riverpod's family semantics
/// keep navigation between detail pages cheap and isolated.

abstract class _$ExpedienteDetailNotifier
    extends $AsyncNotifier<ExpedienteDetail> {
  late final _$args = ref.$arg as String;
  String get numexp => _$args;

  FutureOr<ExpedienteDetail> build(String numexp);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<ExpedienteDetail>, ExpedienteDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExpedienteDetail>, ExpedienteDetail>,
              AsyncValue<ExpedienteDetail>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
