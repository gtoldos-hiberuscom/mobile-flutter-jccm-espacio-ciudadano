import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_estado.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_repository.dart';

/// Mock implementation of [ExpedienteDetailRepository] for STORY-35.
///
/// Returns two deterministic detalles keyed by the administrative
/// number so the UI can showcase the abierto / cerrado split without a
/// backend. Any other key throws [StateError] to drive the error state.
///
/// Sprint-5 placeholder — replace with the real Dio-backed
/// implementation hitting `/publicacion/selectbynumexp` in a later
/// sprint.
// TODO(future-sprint): replace mock with Dio-backed datasource.
final class ExpedienteDetailRepositoryImpl implements ExpedienteDetailRepository {
  const ExpedienteDetailRepositoryImpl();

  @override
  Future<ExpedienteDetail> loadByNumber(final String numexp) async {
    final detail = _fixtures[numexp];
    if (detail == null) {
      throw StateError('mock: no expediente fixture for "$numexp"');
    }
    return detail;
  }

  static final Map<String, ExpedienteDetail> _fixtures = <String, ExpedienteDetail>{
    'EXP/2025/00123': ExpedienteDetail(
      id: 'exp-2025-00123',
      numero: 'EXP/2025/00123',
      asuntoCodigo: 'AS-2025-00123',
      asunto: 'Solicitud de ayuda económica',
      consejeria: 'Consejería de Bienestar Social',
      oficinaTramitadora: 'Servicio Provincial de Toledo',
      procedimiento: 'Ayudas individuales 2025',
      fechaInicio: DateTime(2025, 3, 4),
      fechaUltimaActualizacion: DateTime(2025, 4, 18),
      estado: ExpedienteEstado.abierto,
      ficheros: <ExpedienteFichero>[
        ExpedienteFichero(
          id: 'fich-1',
          nombre: 'solicitud.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 184320,
          fechaSubida: DateTime(2025, 3, 4),
          descargaRef: 'ref://exp-2025-00123/solicitud',
        ),
        ExpedienteFichero(
          id: 'fich-2',
          nombre: 'justificante-renta.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 96512,
          fechaSubida: DateTime(2025, 3, 5),
          descargaRef: 'ref://exp-2025-00123/renta',
        ),
      ],
    ),
    'EXP/2025/00098': ExpedienteDetail(
      id: 'exp-2025-00098',
      numero: 'EXP/2025/00098',
      asuntoCodigo: 'AS-2025-00098',
      asunto: 'Reclamación responsabilidad patrimonial',
      consejeria: 'Consejería de Hacienda',
      oficinaTramitadora: 'Servicios Centrales',
      procedimiento: 'Responsabilidad patrimonial',
      fechaInicio: DateTime(2025, 1, 12),
      fechaUltimaActualizacion: DateTime(2025, 2, 28),
      estado: ExpedienteEstado.cerrado,
      ficheros: <ExpedienteFichero>[
        ExpedienteFichero(
          id: 'fich-1',
          nombre: 'resolucion.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 220160,
          fechaSubida: DateTime(2025, 2, 28),
          descargaRef: 'ref://exp-2025-00098/resolucion',
        ),
      ],
    ),
  };
}
