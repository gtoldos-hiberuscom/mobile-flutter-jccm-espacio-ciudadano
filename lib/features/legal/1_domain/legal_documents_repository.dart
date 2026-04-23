import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';

/// Domain contract for the catalog of bundled legal/static documents.
///
/// Synchronous because the content ships with the binary — STORY-61
/// requires offline-first behaviour for static content (canon §22).
abstract interface class LegalDocumentsRepository {
  /// Returns every bundled document.
  List<LegalDocument> all();

  /// Returns the document for [id] or null when missing.
  LegalDocument? findById(final LegalDocumentId id);
}
