import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/1_domain/registro_repository.dart';

/// Mock implementation of [RegistroRepository] for STORY-36.
///
/// Returns deterministic detalles per `(numreg, kind)` so the UI can
/// showcase loaded / empty / error states without a backend.
///
/// Sprint 5 implementation only — replace with the real Dio-backed
/// datasource hitting `/publicacion/selectbynumreg` in a later story.
// TODO(future-sprint): replace mock with Dio-backed datasource.
final class RegistroRepositoryImpl implements RegistroRepository {
  const RegistroRepositoryImpl();

  @override
  Future<RegistroDetail> loadByNumber({
    required final String numreg,
    required final RegistroKind kind,
  }) async {
    final detail = _detalles[_keyOf(numreg, kind)];
    if (detail == null) {
      throw StateError('mock: registro $numreg ($kind) not found');
    }
    return detail;
  }

  static String _keyOf(final String numreg, final RegistroKind kind) =>
      '${kind.token}:${numreg.toUpperCase()}';

  static final Map<String, RegistroDetail> _detalles = <String, RegistroDetail>{
    _keyOf('REG/E/45612', RegistroKind.entrada): RegistroDetail(
      id: 'reg-e-45612',
      numero: 'REG/E/45612',
      fecha: DateTime(2025, 6, 12, 9, 30),
      kind: RegistroKind.entrada,
      consejeriaDestino: 'Consejería de Educación, Cultura y Deportes',
      asunto: 'Solicitud de admisión en ciclos formativos',
      oficina: 'Oficina de Registro de Toledo',
      observaciones: 'Documentación presentada presencialmente.',
      ficheros: const <RegistroFichero>[
        RegistroFichero(
          id: 'fic-1',
          nombre: 'solicitud-admision.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 184320,
          descargaRef: 'mock://reg-e-45612/solicitud-admision.pdf',
        ),
        RegistroFichero(
          id: 'fic-2',
          nombre: 'anexo-i.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 92160,
          descargaRef: 'mock://reg-e-45612/anexo-i.pdf',
        ),
      ],
    ),
    _keyOf('REG/E/22001', RegistroKind.entrada): RegistroDetail(
      id: 'reg-e-22001',
      numero: 'REG/E/22001',
      fecha: DateTime(2025, 3, 4, 11, 5),
      kind: RegistroKind.entrada,
      consejeriaDestino: 'Consejería de Hacienda, Administraciones Públicas y Transformación Digital',
      asunto: 'Aportación de documentación tributaria',
      oficina: 'Oficina de Registro de Ciudad Real',
      ficheros: const <RegistroFichero>[
        RegistroFichero(
          id: 'fic-1',
          nombre: 'modelo-200.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 256000,
          descargaRef: 'mock://reg-e-22001/modelo-200.pdf',
        ),
      ],
    ),
    _keyOf('REG/E/00000', RegistroKind.entrada): RegistroDetail(
      id: 'reg-e-00000',
      numero: 'REG/E/00000',
      fecha: DateTime(2024, 11, 20, 8),
      kind: RegistroKind.entrada,
      consejeriaDestino: 'Consejería de Sanidad',
      asunto: 'Solicitud sin ficheros adjuntos',
      oficina: 'Oficina de Registro de Cuenca',
      ficheros: const <RegistroFichero>[],
    ),
    _keyOf('REG/S/12044', RegistroKind.salida): RegistroDetail(
      id: 'reg-s-12044',
      numero: 'REG/S/12044',
      fecha: DateTime(2025, 5, 22, 16, 15),
      kind: RegistroKind.salida,
      consejeriaDestino: 'Consejería de Bienestar Social',
      asunto: 'Resolución de ayudas de comedor escolar',
      oficina: 'Oficina de Registro de Albacete',
      observaciones: 'Notificación enviada al domicilio fiscal.',
      ficheros: const <RegistroFichero>[
        RegistroFichero(
          id: 'fic-1',
          nombre: 'resolucion-ayuda.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 143360,
          descargaRef: 'mock://reg-s-12044/resolucion-ayuda.pdf',
        ),
      ],
    ),
    _keyOf('REG/S/30007', RegistroKind.salida): RegistroDetail(
      id: 'reg-s-30007',
      numero: 'REG/S/30007',
      fecha: DateTime(2025, 1, 9, 10, 45),
      kind: RegistroKind.salida,
      consejeriaDestino: 'Consejería de Desarrollo Sostenible',
      asunto: 'Comunicación de resolución de subvención',
      oficina: 'Oficina de Registro de Guadalajara',
      ficheros: const <RegistroFichero>[
        RegistroFichero(
          id: 'fic-1',
          nombre: 'comunicacion.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 102400,
          descargaRef: 'mock://reg-s-30007/comunicacion.pdf',
        ),
      ],
    ),
    _keyOf('REG/S/00000', RegistroKind.salida): RegistroDetail(
      id: 'reg-s-00000',
      numero: 'REG/S/00000',
      fecha: DateTime(2024, 12, 1, 13, 20),
      kind: RegistroKind.salida,
      consejeriaDestino: 'Consejería de Agricultura, Ganadería y Desarrollo Rural',
      asunto: 'Notificación sin ficheros adjuntos',
      oficina: 'Oficina de Registro de Toledo',
      ficheros: const <RegistroFichero>[],
    ),
  };
}
