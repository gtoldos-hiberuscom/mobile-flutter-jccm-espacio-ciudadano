import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';

/// Mock implementation of [CaseworkRepository] for STORY-34 / STORY-39.
///
/// Returns deterministic items per tab so the UI can showcase the
/// loaded / empty / error states without a backend.
///
/// Behaviour can be tuned via constructor flags:
/// - [forceEmptyTab]: returns an empty list for the given tab.
/// - [forceErrorTab]: throws a [StateError] when that tab is requested.
///
/// Sprint-4 implementation only — replace with the real Dio-backed
/// implementation hitting `/publicacion/selectbynif`,
/// `/publicacion/selectbynifentrada`, `/publicacion/selectbynifsalida`,
/// `/publicacion/selectbynumexp` and `/publicacion/selectbynumreg`
/// in a later story.
// TODO(future-sprint): replace mock search with Dio-backed datasource.
final class CaseworkRepositoryImpl implements CaseworkRepository {
  const CaseworkRepositoryImpl({this.forceEmptyTab, this.forceErrorTab});

  final CaseworkTab? forceEmptyTab;
  final CaseworkTab? forceErrorTab;

  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async {
    if (forceErrorTab == tab) {
      throw StateError('mock: forced error for tab $tab');
    }
    if (forceEmptyTab == tab) {
      return const <CaseworkItem>[];
    }
    switch (tab) {
      case CaseworkTab.expedientes:
        return _expedientes;
      case CaseworkTab.entradasRegistro:
        return _entradas;
      case CaseworkTab.salidasRegistro:
        return _salidas;
    }
  }

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async {
    // Deterministic mock: NIF search returns three items so the UI can
    // showcase the populated results state.
    final query = identification.trim().toUpperCase();
    if (query.isEmpty) {
      return const <CaseworkItem>[];
    }
    return List<CaseworkItem>.unmodifiable(_searchResultsByNif);
  }

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async {
    // Deterministic mock: expediente search returns zero items so the UI
    // can showcase the dedicated "no results found" state. The [number]
    // parameter is intentionally unused in the mock.
    return const <CaseworkItem>[];
  }

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(final String number) async {
    // Deterministic mock: registro search throws so the UI can showcase
    // the error state.
    throw StateError('mock: forced error for registro search ($number)');
  }

  static final List<CaseworkItem> _searchResultsByNif = <CaseworkItem>[
    CaseworkItem(
      id: 'search-exp-1',
      type: CaseworkTab.expedientes,
      number: 'EXP/2025/00123',
      date: DateTime(2025, 9, 14),
      organism: 'Consejería de Educación, Cultura y Deportes',
      subject: 'Solicitud de beca de comedor escolar 2025/2026',
      status: CaseworkItemStatus.enTramite,
    ),
    CaseworkItem(
      id: 'search-reg-e-1',
      type: CaseworkTab.entradasRegistro,
      number: 'REG/E/45612',
      date: DateTime(2025, 11, 4),
      organism: 'Registro Electrónico Común',
      subject: 'Aportación de documentación al expediente EXP/2025/00123',
      status: CaseworkItemStatus.finalizado,
    ),
    CaseworkItem(
      id: 'search-reg-s-1',
      type: CaseworkTab.salidasRegistro,
      number: 'REG/S/12044',
      date: DateTime(2025, 11, 18),
      organism: 'Consejería de Educación, Cultura y Deportes',
      subject: 'Notificación de requerimiento de subsanación',
      status: CaseworkItemStatus.pendiente,
    ),
  ];

  static final List<CaseworkItem> _expedientes = <CaseworkItem>[
    CaseworkItem(
      id: 'exp-1',
      type: CaseworkTab.expedientes,
      number: 'EXP/2025/00123',
      date: DateTime(2025, 9, 14),
      organism: 'Consejería de Educación, Cultura y Deportes',
      subject: 'Solicitud de beca de comedor escolar 2025/2026',
      status: CaseworkItemStatus.enTramite,
    ),
    CaseworkItem(
      id: 'exp-2',
      type: CaseworkTab.expedientes,
      number: 'EXP/2025/00098',
      date: DateTime(2025, 6, 2),
      organism: 'Consejería de Bienestar Social',
      subject: 'Reconocimiento del grado de discapacidad',
      status: CaseworkItemStatus.finalizado,
    ),
    CaseworkItem(
      id: 'exp-3',
      type: CaseworkTab.expedientes,
      number: 'EXP/2025/00077',
      date: DateTime(2025, 4, 21),
      organism: 'SESCAM',
      subject: 'Reintegro de gastos farmacéuticos',
      status: CaseworkItemStatus.pendiente,
    ),
    CaseworkItem(
      id: 'exp-4',
      type: CaseworkTab.expedientes,
      number: 'EXP/2024/01244',
      date: DateTime(2024, 12, 19),
      organism: 'Consejería de Hacienda',
      subject: 'Devolución de tasas administrativas',
      status: CaseworkItemStatus.rechazado,
    ),
  ];

  static final List<CaseworkItem> _entradas = <CaseworkItem>[
    CaseworkItem(
      id: 'reg-e-1',
      type: CaseworkTab.entradasRegistro,
      number: 'REG/E/45612',
      date: DateTime(2025, 11, 4),
      organism: 'Registro Electrónico Común',
      subject: 'Aportación de documentación al expediente EXP/2025/00123',
      status: CaseworkItemStatus.finalizado,
    ),
    CaseworkItem(
      id: 'reg-e-2',
      type: CaseworkTab.entradasRegistro,
      number: 'REG/E/45301',
      date: DateTime(2025, 10, 12),
      organism: 'Oficina de Asistencia en Materia de Registros — Toledo',
      subject: 'Recurso de reposición a tasa devengada',
      status: CaseworkItemStatus.enTramite,
    ),
    CaseworkItem(
      id: 'reg-e-3',
      type: CaseworkTab.entradasRegistro,
      number: 'REG/E/44980',
      date: DateTime(2025, 8, 27),
      organism: 'Registro Electrónico Común',
      subject: 'Solicitud genérica — actualización de datos personales',
      status: CaseworkItemStatus.finalizado,
    ),
  ];

  static final List<CaseworkItem> _salidas = <CaseworkItem>[
    CaseworkItem(
      id: 'reg-s-1',
      type: CaseworkTab.salidasRegistro,
      number: 'REG/S/12044',
      date: DateTime(2025, 11, 18),
      organism: 'Consejería de Educación, Cultura y Deportes',
      subject: 'Notificación de requerimiento de subsanación',
      status: CaseworkItemStatus.pendiente,
    ),
    CaseworkItem(
      id: 'reg-s-2',
      type: CaseworkTab.salidasRegistro,
      number: 'REG/S/11987',
      date: DateTime(2025, 9, 30),
      organism: 'Consejería de Bienestar Social',
      subject: 'Resolución favorable de reconocimiento',
      status: CaseworkItemStatus.finalizado,
    ),
    CaseworkItem(
      id: 'reg-s-3',
      type: CaseworkTab.salidasRegistro,
      number: 'REG/S/11820',
      date: DateTime(2025, 7, 4),
      organism: 'SESCAM',
      subject: 'Comunicación de inicio de procedimiento',
      status: CaseworkItemStatus.enTramite,
    ),
  ];
}
