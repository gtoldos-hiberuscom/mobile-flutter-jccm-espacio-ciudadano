import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/legal/1_domain/legal_documents_repository.dart';
import 'package:jccm_espacio_ciudadano/features/legal/3_data/legal_documents_repository_impl.dart';

/// DI composition for the legal-documents repository.
///
/// `keepAlive: true` because the catalog is immutable and shared across
/// every legal route (terms, privacy, accessibility, legal notice).
final legalDocumentsRepositoryProvider = Provider<LegalDocumentsRepository>((final ref) => const LegalDocumentsRepositoryImpl());
