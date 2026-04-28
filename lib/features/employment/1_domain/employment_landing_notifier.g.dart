// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_landing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the Empleo landing state (STORY-24). Mock-backed in Sprint 3.

@ProviderFor(EmploymentLandingNotifier)
const employmentLandingProvider = EmploymentLandingNotifierProvider._();

/// Owns the Empleo landing state (STORY-24). Mock-backed in Sprint 3.
final class EmploymentLandingNotifierProvider extends $AsyncNotifierProvider<EmploymentLandingNotifier, EmploymentSnapshot> {
  /// Owns the Empleo landing state (STORY-24). Mock-backed in Sprint 3.
  const EmploymentLandingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employmentLandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employmentLandingNotifierHash();

  @$internal
  @override
  EmploymentLandingNotifier create() => EmploymentLandingNotifier();
}

String _$employmentLandingNotifierHash() => r'12fb52b48b05796ceefcd5e82280a0942348313f';

/// Owns the Empleo landing state (STORY-24). Mock-backed in Sprint 3.

abstract class _$EmploymentLandingNotifier extends $AsyncNotifier<EmploymentSnapshot> {
  FutureOr<EmploymentSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<EmploymentSnapshot>, EmploymentSnapshot>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<EmploymentSnapshot>, EmploymentSnapshot>, AsyncValue<EmploymentSnapshot>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
