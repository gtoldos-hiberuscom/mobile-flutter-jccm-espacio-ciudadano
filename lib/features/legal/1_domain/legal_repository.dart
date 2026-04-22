import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';

/// Domain contract for accessing legal documents.
///
/// Concrete implementations live in `3_data/`. This abstraction keeps
/// the domain and presentation layers free of infrastructure concerns.
abstract interface class LegalRepository {
  /// Returns the [LegalDocument] for [type].
  ///
  /// Content is bundled — the call is synchronous and always succeeds.
  LegalDocument getDocument(final LegalDocumentType type);
}
