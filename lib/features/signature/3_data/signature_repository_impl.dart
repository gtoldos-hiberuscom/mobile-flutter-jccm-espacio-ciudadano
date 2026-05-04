import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document_status.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_inbox_result.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_repository.dart';

/// Mock implementation of [SignatureRepository] for STORY-45.
///
/// Returns a deterministic catalog: 3 pending documents, 1 expired
/// document and 2 already-signed documents. Certificate validation
/// returns one of [CertificateValidationState.valid],
/// [CertificateValidationState.vecAvailable] or
/// [CertificateValidationState.expired] cycling through a counter so
/// widget snapshots and tests can assert each branch deterministically
/// (the counter resets per repository instance).
///
/// Real Dio wiring is deferred — see endpoints listed in STORY-45 and
/// the EPIC-6 contract strategy notes.
// TODO(future-sprint): replace mock with Dio-backed datasources bound
// to /afirma/milistardocumentosreq, /afirma/mivecreq and
// /publicacion/midocfirmados once the contract value-sets are
// confirmed by backend.
final class SignatureRepositoryImpl implements SignatureRepository {
  SignatureRepositoryImpl({
    this.forceInboxError = false,
    this.forceCertificateError = false,
    this.fixedCertificateState,
  });

  /// When `true` every call to [loadInbox] throws — used by tests to
  /// exercise the global error surface.
  final bool forceInboxError;

  /// When `true` every call to [validateCertificate] throws — used by
  /// tests to exercise the certificate banner error branch.
  final bool forceCertificateError;

  /// When set, [validateCertificate] always returns the matching
  /// state. When `null` the impl cycles through valid → vecAvailable
  /// → expired so each branch is observable in dev / snapshots.
  final CertificateValidationState? fixedCertificateState;

  int _certificateCounter = 0;

  static final List<SignatureDocument> _pendingCatalog = _buildPendingCatalog();
  static final List<SignatureDocument> _signedCatalog = _buildSignedCatalog();

  @override
  Future<SignatureInboxResult> loadInbox() async {
    if (forceInboxError) {
      throw StateError('mock: forced inbox error');
    }
    return SignatureInboxResult(
      pending: List<SignatureDocument>.unmodifiable(_pendingCatalog),
      signed: List<SignatureDocument>.unmodifiable(_signedCatalog),
      fetchedAt: DateTime(2026, 5, 4, 10),
    );
  }

  @override
  Future<List<SignatureDocument>> loadSignedHistory() async {
    if (forceInboxError) {
      throw StateError('mock: forced signed history error');
    }
    return List<SignatureDocument>.unmodifiable(_signedCatalog);
  }

  @override
  Future<CertificateValidation> validateCertificate() async {
    if (forceCertificateError) {
      throw StateError('mock: forced certificate validation error');
    }
    final state = fixedCertificateState ?? _cycleStates[_certificateCounter++ % _cycleStates.length];
    switch (state) {
      case CertificateValidationState.valid:
        return CertificateValidation(
          state: state,
          holderName: 'Ciudadano de Prueba',
          expiresAt: DateTime(2027, 1, 31),
        );
      case CertificateValidationState.vecAvailable:
        return const CertificateValidation(
          state: CertificateValidationState.vecAvailable,
          holderName: 'Ciudadano de Prueba',
        );
      case CertificateValidationState.expired:
        return CertificateValidation(
          state: CertificateValidationState.expired,
          holderName: 'Ciudadano de Prueba',
          expiresAt: DateTime(2025, 12),
        );
      case CertificateValidationState.missing:
      case CertificateValidationState.invalid:
      case CertificateValidationState.unknown:
        return CertificateValidation(state: state);
    }
  }

  static const List<CertificateValidationState> _cycleStates = <CertificateValidationState>[
    CertificateValidationState.valid,
    CertificateValidationState.vecAvailable,
    CertificateValidationState.expired,
  ];

  static List<SignatureDocument> _buildPendingCatalog() {
    final reference = DateTime(2026, 5, 4, 10);
    return <SignatureDocument>[
      SignatureDocument(
        id: 'SIG-0001',
        title: 'Solicitud de subvención de comedor escolar',
        organismoEmisor: 'Consejería de Educación',
        fechaCreacion: reference.subtract(const Duration(days: 1)),
        expedienteRef: 'EDU/2026/000123',
        sizeBytes: 245_678,
        status: SignatureDocumentStatus.pendiente,
      ),
      SignatureDocument(
        id: 'SIG-0002',
        title: 'Renovación de tarjeta sanitaria',
        organismoEmisor: 'Consejería de Sanidad',
        fechaCreacion: reference.subtract(const Duration(days: 3)),
        expedienteRef: 'SAN/2026/000045',
        sizeBytes: 102_400,
        status: SignatureDocumentStatus.pendiente,
      ),
      SignatureDocument(
        id: 'SIG-0003',
        title: 'Declaración trimestral IRPF',
        organismoEmisor: 'Consejería de Hacienda',
        fechaCreacion: reference.subtract(const Duration(days: 5)),
        expedienteRef: 'HAC/2026/000901',
        sizeBytes: 1_543_200,
        status: SignatureDocumentStatus.pendiente,
      ),
      SignatureDocument(
        id: 'SIG-0004',
        title: 'Convenio formación profesional (caducado)',
        organismoEmisor: 'Servicio Público de Empleo',
        fechaCreacion: reference.subtract(const Duration(days: 45)),
        expedienteRef: 'SEPE/2026/000007',
        sizeBytes: 312_000,
        status: SignatureDocumentStatus.expirado,
      ),
    ];
  }

  static List<SignatureDocument> _buildSignedCatalog() {
    final reference = DateTime(2026, 5, 4, 10);
    return <SignatureDocument>[
      SignatureDocument(
        id: 'SIG-9001',
        title: 'Acuse de recibo de notificación electrónica',
        organismoEmisor: 'Consejería de Hacienda',
        fechaCreacion: reference.subtract(const Duration(days: 30)),
        expedienteRef: 'HAC/2026/000456',
        sizeBytes: 88_120,
        status: SignatureDocumentStatus.firmado,
      ),
      SignatureDocument(
        id: 'SIG-9002',
        title: 'Solicitud de cita previa firmada',
        organismoEmisor: 'Consejería de Sanidad',
        fechaCreacion: reference.subtract(const Duration(days: 60)),
        expedienteRef: 'SAN/2026/000012',
        sizeBytes: 76_800,
        status: SignatureDocumentStatus.firmado,
      ),
    ];
  }
}
