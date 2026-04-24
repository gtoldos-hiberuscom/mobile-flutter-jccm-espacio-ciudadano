// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employmentRepository)
const employmentRepositoryProvider = EmploymentRepositoryProvider._();

final class EmploymentRepositoryProvider extends $FunctionalProvider<EmploymentRepository, EmploymentRepository, EmploymentRepository> with $Provider<EmploymentRepository> {
  const EmploymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmploymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmploymentRepository create(Ref ref) {
    return employmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmploymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmploymentRepository>(value),
    );
  }
}

String _$employmentRepositoryHash() => r'f5a8dbb084208397913bfac15abc3e100d73df7b';
