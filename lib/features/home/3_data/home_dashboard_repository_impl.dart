import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_block_id.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_dashboard_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_widget_summary.dart';
import 'package:jccm_espacio_ciudadano/features/home/1_domain/home_dashboard_repository.dart';

/// In-memory mock implementation used while the backend dashboard endpoint
/// is being built (canon §13, no real network call yet).
///
/// The mock is deterministic and intentionally produces a mix of:
/// - **loaded** blocks (with non-null `count`/`headline`),
/// - one **empty** block,
/// - one **error** block (per-block partial failure),
///
/// so the UI exercises every state defined in `core/ui_states/` without
/// touching real data sources. Replace with a real Dio-backed implementation
/// when the dashboard endpoint is delivered.
final class HomeDashboardRepositoryImpl implements HomeDashboardRepository {
  const HomeDashboardRepositoryImpl({
    final Duration latency = const Duration(milliseconds: 250),
    final DateTime Function() clock = DateTime.now,
  }) : _latency = latency,
       _clock = clock;

  final Duration _latency;
  final DateTime Function() _clock;

  @override
  Future<HomeDashboardSnapshot> loadDashboard() async {
    if (_latency > Duration.zero) {
      await Future<void>.delayed(_latency);
    }
    final now = _clock();

    return HomeDashboardSnapshot(
      blocks: <HomeWidgetSummary>[
        HomeWidgetSummary(
          blockId: HomeBlockId.education,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 3,
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.employment,
          loadState: HomeBlockLoadState.empty,
          lastUpdatedAt: now,
        ),
        const HomeWidgetSummary(
          blockId: HomeBlockId.socialWelfare,
          loadState: HomeBlockLoadState.error,
          errorMessage: 'load_failed',
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.stateAffairs,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 5,
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.agenda,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 2,
        ),
        // ── Personal widgets ───────────────────────────────────────────────
        HomeWidgetSummary(
          blockId: HomeBlockId.upcomingEvents,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 2,
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.casework,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 4,
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.notifications,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 7,
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.digitalCards,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 2,
        ),
        HomeWidgetSummary(
          blockId: HomeBlockId.recommendations,
          loadState: HomeBlockLoadState.loaded,
          lastUpdatedAt: now,
          count: 3,
        ),
      ],
    );
  }
}
