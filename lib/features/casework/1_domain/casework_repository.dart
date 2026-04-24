import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';

/// Domain contract for the "Mis gestiones" workspace (STORY-34).
///
/// Sprint-4 implementation returns mocked data. Real wiring against
/// `/publicacion/selectbynif`, `/publicacion/selectbynifentrada` and
/// `/publicacion/selectbynifsalida` is deferred to a follow-up
/// data-layer story (STORY-39 will extend this contract with search).
abstract interface class CaseworkRepository {
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab);
}
