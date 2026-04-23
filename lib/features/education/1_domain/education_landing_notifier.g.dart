// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_landing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the Educación landing state (STORY-23). Mock-backed in Sprint 3.

@ProviderFor(EducationLandingNotifier)
const educationLandingProvider = EducationLandingNotifierProvider._();

/// Owns the Educación landing state (STORY-23). Mock-backed in Sprint 3.
final class EducationLandingNotifierProvider
    extends
        $AsyncNotifierProvider<EducationLandingNotifier, EducationSnapshot> {
  /// Owns the Educación landing state (STORY-23). Mock-backed in Sprint 3.
  const EducationLandingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationLandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationLandingNotifierHash();

  @$internal
  @override
  EducationLandingNotifier create() => EducationLandingNotifier();
}

String _$educationLandingNotifierHash() =>
    r'48cc118d89f73d63029e720ef7b81bd87af1e1ff';

/// Owns the Educación landing state (STORY-23). Mock-backed in Sprint 3.

abstract class _$EducationLandingNotifier
    extends $AsyncNotifier<EducationSnapshot> {
  FutureOr<EducationSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<EducationSnapshot>, EducationSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EducationSnapshot>, EducationSnapshot>,
              AsyncValue<EducationSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
