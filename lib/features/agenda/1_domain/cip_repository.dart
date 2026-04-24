import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/cip_summary.dart';

/// Domain contract for retrieving the citizen's CIP / tarjeta sanitaria
/// summary (STORY-31).
///
/// Co-located inside the agenda feature on purpose: per the TASK-71
/// surface decision (CIP_REUSE) salud owns the CIP and renders it as a
/// read-only mini-card both on the agenda screen and on the home
/// "Salud" entry point. No wallet semantics are exposed here.
///
/// Implementations live in `3_data/`. No Flutter / Dio / Riverpod
/// imports allowed (canon §13). Errors during a fetch must be encoded
/// inside the returned [CipSummary.loadState] so the notifier can
/// render partial states without entering `AsyncValue.error`.
abstract interface class CipRepository {
  /// Resolves a fresh CIP summary for the currently authenticated user.
  Future<CipSummary> loadCip();
}
