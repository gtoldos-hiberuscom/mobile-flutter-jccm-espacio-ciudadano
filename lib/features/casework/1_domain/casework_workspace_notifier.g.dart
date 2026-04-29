// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casework_workspace_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the "Mis gestiones" workspace state (STORY-34). Loads the three
/// tabs in parallel so each section surfaces its own loading / empty /
/// error state independently.

@ProviderFor(CaseworkWorkspaceNotifier)
const caseworkWorkspaceProvider = CaseworkWorkspaceNotifierProvider._();

/// Owns the "Mis gestiones" workspace state (STORY-34). Loads the three
/// tabs in parallel so each section surfaces its own loading / empty /
/// error state independently.
final class CaseworkWorkspaceNotifierProvider extends $AsyncNotifierProvider<CaseworkWorkspaceNotifier, CaseworkSnapshot> {
  /// Owns the "Mis gestiones" workspace state (STORY-34). Loads the three
  /// tabs in parallel so each section surfaces its own loading / empty /
  /// error state independently.
  const CaseworkWorkspaceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caseworkWorkspaceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caseworkWorkspaceNotifierHash();

  @$internal
  @override
  CaseworkWorkspaceNotifier create() => CaseworkWorkspaceNotifier();
}

String _$caseworkWorkspaceNotifierHash() => r'bee280350417ed0fa8e7ecb9a2901baf8d22415f';

/// Owns the "Mis gestiones" workspace state (STORY-34). Loads the three
/// tabs in parallel so each section surfaces its own loading / empty /
/// error state independently.

abstract class _$CaseworkWorkspaceNotifier extends $AsyncNotifier<CaseworkSnapshot> {
  FutureOr<CaseworkSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CaseworkSnapshot>, CaseworkSnapshot>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<CaseworkSnapshot>, CaseworkSnapshot>, AsyncValue<CaseworkSnapshot>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
