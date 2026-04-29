import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_inbox_result.dart';

/// Repository abstraction for the citizen signature workspace
/// (STORY-45).
///
/// Implementations live under `3_data/`. The domain layer must depend
/// only on this abstraction (canon §12). Implementations are required
/// to translate transport / SDK errors into typed failures — raw
/// `DioException` instances must never leak above this layer.
abstract interface class SignatureRepository {
  /// Loads the inbox: documents pending to sign + already signed
  /// history. Backed in production by `POST /afirma/milistardocumentosreq`
  /// and `POST /publicacion/midocfirmados`.
  Future<SignatureInboxResult> loadInbox();

  /// Validates the citizen certificate (or VEC fallback). Backed in
  /// production by `POST /afirma/mivecreq`.
  Future<CertificateValidation> validateCertificate();

  /// Returns the historical list of already-signed documents for the
  /// citizen. Backed in production by `POST /publicacion/midocfirmados`.
  Future<List<SignatureDocument>> loadSignedHistory();
}
