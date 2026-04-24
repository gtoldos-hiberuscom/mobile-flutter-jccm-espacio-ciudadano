// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_consent_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the data-consent (`clausulas`) state for a given `idAgente`
/// (STORY-55).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).

@ProviderFor(DataConsentNotifier)
const dataConsentProvider = DataConsentNotifierFamily._();

/// Owns the data-consent (`clausulas`) state for a given `idAgente`
/// (STORY-55).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).
final class DataConsentNotifierProvider
    extends $AsyncNotifierProvider<DataConsentNotifier, DataConsentSnapshot> {
  /// Owns the data-consent (`clausulas`) state for a given `idAgente`
  /// (STORY-55).
  ///
  /// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
  /// story (depends on TASK-21 idAgente closure).
  const DataConsentNotifierProvider._({
    required DataConsentNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dataConsentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dataConsentNotifierHash();

  @override
  String toString() {
    return r'dataConsentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DataConsentNotifier create() => DataConsentNotifier();

  @override
  bool operator ==(Object other) {
    return other is DataConsentNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dataConsentNotifierHash() =>
    r'34a5a98a908d60731d51471e346bd5818c8d70df';

/// Owns the data-consent (`clausulas`) state for a given `idAgente`
/// (STORY-55).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).

final class DataConsentNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DataConsentNotifier,
          AsyncValue<DataConsentSnapshot>,
          DataConsentSnapshot,
          FutureOr<DataConsentSnapshot>,
          String
        > {
  const DataConsentNotifierFamily._()
    : super(
        retry: null,
        name: r'dataConsentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns the data-consent (`clausulas`) state for a given `idAgente`
  /// (STORY-55).
  ///
  /// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
  /// story (depends on TASK-21 idAgente closure).

  DataConsentNotifierProvider call(String idAgente) =>
      DataConsentNotifierProvider._(argument: idAgente, from: this);

  @override
  String toString() => r'dataConsentProvider';
}

/// Owns the data-consent (`clausulas`) state for a given `idAgente`
/// (STORY-55).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).

abstract class _$DataConsentNotifier
    extends $AsyncNotifier<DataConsentSnapshot> {
  late final _$args = ref.$arg as String;
  String get idAgente => _$args;

  FutureOr<DataConsentSnapshot> build(String idAgente);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<DataConsentSnapshot>, DataConsentSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DataConsentSnapshot>, DataConsentSnapshot>,
              AsyncValue<DataConsentSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
