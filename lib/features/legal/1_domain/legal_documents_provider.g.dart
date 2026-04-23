// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for the legal-documents repository.
///
/// `keepAlive: true` because the catalog is immutable and shared across
/// every legal route (terms, privacy, accessibility, legal notice).

@ProviderFor(legalDocumentsRepository)
const legalDocumentsRepositoryProvider = LegalDocumentsRepositoryProvider._();

/// DI composition for the legal-documents repository.
///
/// `keepAlive: true` because the catalog is immutable and shared across
/// every legal route (terms, privacy, accessibility, legal notice).

final class LegalDocumentsRepositoryProvider
    extends
        $FunctionalProvider<
          LegalDocumentsRepository,
          LegalDocumentsRepository,
          LegalDocumentsRepository
        >
    with $Provider<LegalDocumentsRepository> {
  /// DI composition for the legal-documents repository.
  ///
  /// `keepAlive: true` because the catalog is immutable and shared across
  /// every legal route (terms, privacy, accessibility, legal notice).
  const LegalDocumentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'legalDocumentsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$legalDocumentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LegalDocumentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LegalDocumentsRepository create(Ref ref) {
    return legalDocumentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LegalDocumentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LegalDocumentsRepository>(value),
    );
  }
}

String _$legalDocumentsRepositoryHash() =>
    r'd66508ba9a762944ebc753b0e5ca5bb729d46d9e';
