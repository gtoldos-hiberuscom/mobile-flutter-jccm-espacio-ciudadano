import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';

/// Domain contract for the "Mis gestiones" workspace (STORY-34) and the
/// search experience (STORY-39).
///
/// Sprint-4 implementation returns mocked data. Real wiring against
/// `/publicacion/selectbynif`, `/publicacion/selectbynifentrada`,
/// `/publicacion/selectbynifsalida`, `/publicacion/selectbynumexp` and
/// `/publicacion/selectbynumreg` is deferred to a follow-up data-layer
/// story.
abstract interface class CaseworkRepository {
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab);

  /// Search expedientes / registros associated to a NIF / NIE / pasaporte
  /// (STORY-39, endpoint `/publicacion/selectbynif`).
  Future<List<CaseworkItem>> searchByNif(final String identification);

  /// Search by número de expediente (STORY-39, endpoint
  /// `/publicacion/selectbynumexp`).
  Future<List<CaseworkItem>> searchByExpedienteNumber(final String number);

  /// Search by número de registro (STORY-39, endpoint
  /// `/publicacion/selectbynumreg`).
  Future<List<CaseworkItem>> searchByRegistroNumber(final String number);
}
