// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and exposes the detail of a registro entrada / salida
/// (STORY-36) as an `AsyncValue<RegistroDetail>`.
///
/// The notifier is keyed by `(numreg, kind)` so each detail screen owns
/// its own state and side effects stay isolated per route instance.

@ProviderFor(RegistroDetailNotifier)
const registroDetailProvider = RegistroDetailNotifierFamily._();

/// Loads and exposes the detail of a registro entrada / salida
/// (STORY-36) as an `AsyncValue<RegistroDetail>`.
///
/// The notifier is keyed by `(numreg, kind)` so each detail screen owns
/// its own state and side effects stay isolated per route instance.
final class RegistroDetailNotifierProvider extends $AsyncNotifierProvider<RegistroDetailNotifier, RegistroDetail> {
  /// Loads and exposes the detail of a registro entrada / salida
  /// (STORY-36) as an `AsyncValue<RegistroDetail>`.
  ///
  /// The notifier is keyed by `(numreg, kind)` so each detail screen owns
  /// its own state and side effects stay isolated per route instance.
  const RegistroDetailNotifierProvider._({
    required RegistroDetailNotifierFamily super.from,
    required (String, RegistroKind) super.argument,
  }) : super(
         retry: null,
         name: r'registroDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$registroDetailNotifierHash();

  @override
  String toString() {
    return r'registroDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RegistroDetailNotifier create() => RegistroDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is RegistroDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$registroDetailNotifierHash() => r'cbf79b3f036b0ae994a20c5a5515b33cfc07de24';

/// Loads and exposes the detail of a registro entrada / salida
/// (STORY-36) as an `AsyncValue<RegistroDetail>`.
///
/// The notifier is keyed by `(numreg, kind)` so each detail screen owns
/// its own state and side effects stay isolated per route instance.

final class RegistroDetailNotifierFamily extends $Family with $ClassFamilyOverride<RegistroDetailNotifier, AsyncValue<RegistroDetail>, RegistroDetail, FutureOr<RegistroDetail>, (String, RegistroKind)> {
  const RegistroDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'registroDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads and exposes the detail of a registro entrada / salida
  /// (STORY-36) as an `AsyncValue<RegistroDetail>`.
  ///
  /// The notifier is keyed by `(numreg, kind)` so each detail screen owns
  /// its own state and side effects stay isolated per route instance.

  RegistroDetailNotifierProvider call(String numreg, RegistroKind kind) => RegistroDetailNotifierProvider._(argument: (numreg, kind), from: this);

  @override
  String toString() => r'registroDetailProvider';
}

/// Loads and exposes the detail of a registro entrada / salida
/// (STORY-36) as an `AsyncValue<RegistroDetail>`.
///
/// The notifier is keyed by `(numreg, kind)` so each detail screen owns
/// its own state and side effects stay isolated per route instance.

abstract class _$RegistroDetailNotifier extends $AsyncNotifier<RegistroDetail> {
  late final _$args = ref.$arg as (String, RegistroKind);
  String get numreg => _$args.$1;
  RegistroKind get kind => _$args.$2;

  FutureOr<RegistroDetail> build(String numreg, RegistroKind kind);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<RegistroDetail>, RegistroDetail>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<RegistroDetail>, RegistroDetail>, AsyncValue<RegistroDetail>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
