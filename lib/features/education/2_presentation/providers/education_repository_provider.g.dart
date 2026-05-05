// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [EducationRepository].
///
/// [currentAuthUserProvider] is watched so the repository is recreated
/// whenever the authenticated user changes (login / logout).

@ProviderFor(educationRepository)
const educationRepositoryProvider = EducationRepositoryProvider._();

/// DI composition for [EducationRepository].
///
/// [currentAuthUserProvider] is watched so the repository is recreated
/// whenever the authenticated user changes (login / logout).

final class EducationRepositoryProvider
    extends
        $FunctionalProvider<
          EducationRepository,
          EducationRepository,
          EducationRepository
        >
    with $Provider<EducationRepository> {
  /// DI composition for [EducationRepository].
  ///
  /// [currentAuthUserProvider] is watched so the repository is recreated
  /// whenever the authenticated user changes (login / logout).
  const EducationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'educationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$educationRepositoryHash();

  @$internal
  @override
  $ProviderElement<EducationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EducationRepository create(Ref ref) {
    return educationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EducationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EducationRepository>(value),
    );
  }
}

String _$educationRepositoryHash() =>
    r'd61ca94148576599512a3f50b2d5247f42e90d26';
