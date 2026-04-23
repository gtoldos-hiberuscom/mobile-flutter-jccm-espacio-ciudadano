import 'package:jccm_espacio_ciudadano/features/legal/1_domain/legal_documents_repository.dart';
import 'package:jccm_espacio_ciudadano/features/legal/3_data/legal_documents_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'legal_documents_provider.g.dart';

/// DI composition for the legal-documents repository.
///
/// `keepAlive: true` because the catalog is immutable and shared across
/// every legal route (terms, privacy, accessibility, legal notice).
@Riverpod(keepAlive: true)
LegalDocumentsRepository legalDocumentsRepository(final Ref ref) =>
    const LegalDocumentsRepositoryImpl();
