import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_block_id.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_dashboard_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_widget_summary.dart';
import 'package:jccm_espacio_ciudadano/features/home/1_domain/home_dashboard_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/home/1_domain/home_dashboard_repository.dart';
import 'package:jccm_espacio_ciudadano/features/home/3_data/home_dashboard_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/home/3_data/home_repository_provider.dart';

void main() {
  group('HomeDashboardNotifier', () {
    test('hydrates a snapshot with mixed per-block load states', () async {
      final fixedClock = DateTime(2026, 5, 4, 10, 30);
      final container = ProviderContainer(
        overrides: [
          homeDashboardRepositoryProvider.overrideWith(
            (final ref) => HomeDashboardRepositoryImpl(
              latency: Duration.zero,
              clock: () => fixedClock,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final snapshot = await container.read(homeDashboardProvider.future);

      // All canonical block ids must be present.
      expect(
        snapshot.blocks.map((final HomeWidgetSummary b) => b.blockId).toSet(),
        equals(HomeBlockId.values.toSet()),
      );

      // Mock contract: at least one block of each non-loading state to
      // exercise the UI states (canon §16 partial-error tolerance).
      final loaded = snapshot.blocks.where(
        (final HomeWidgetSummary b) => b.loadState == HomeBlockLoadState.loaded,
      );
      final empty = snapshot.blocks.where(
        (final HomeWidgetSummary b) => b.loadState == HomeBlockLoadState.empty,
      );
      final errored = snapshot.blocks.where(
        (final HomeWidgetSummary b) => b.loadState == HomeBlockLoadState.error,
      );

      expect(loaded, isNotEmpty);
      expect(empty.length, 1);
      expect(errored.length, 1);

      // Loaded blocks expose a fresh timestamp; errored blocks must not.
      expect(loaded.first.lastUpdatedAt, equals(fixedClock));
      expect(errored.first.lastUpdatedAt, isNull);
    });

    test('refresh re-fetches the snapshot from the repository', () async {
      var calls = 0;
      final repo = _CountingHomeDashboardRepository(onLoad: () => calls++);

      final container = ProviderContainer(
        overrides: [
          homeDashboardRepositoryProvider.overrideWith((final ref) => repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeDashboardProvider.future);
      expect(calls, 1);

      await container.read(homeDashboardProvider.notifier).refresh();
      expect(calls, 2);
    });
  });
}

class _CountingHomeDashboardRepository implements HomeDashboardRepository {
  _CountingHomeDashboardRepository({required this.onLoad});

  final void Function() onLoad;
  final HomeDashboardRepositoryImpl _delegate = const HomeDashboardRepositoryImpl(latency: Duration.zero);

  @override
  Future<HomeDashboardSnapshot> loadDashboard() {
    onLoad();
    return _delegate.loadDashboard();
  }
}
