import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/state_affairs_snapshot.dart';

/// Domain contract for the Estado y otros temas de interés landing
/// (STORY-26).
///
/// Implementations live in `3_data/`. No Flutter / Dio / Riverpod imports
/// allowed (canon §13). Per-section failures should be encoded inside the
/// returned [StateAffairsSnapshot] so the UI can render partial data.
///
// TODO(STORY-26): the Sprint-3 implementation returns mocked data
/// only. Real wiring against `/ine/datos-residencia/{numDocumento}`,
/// `/catastro/datos-catastrales/{numDocumento}` and
/// `/dgt/lista-vehiculos/{numDocumento}` is owned by a follow-up story.
abstract interface class StateAffairsRepository {
  Future<StateAffairsSnapshot> loadSnapshot();
}
