import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_dashboard_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/home/3_data/home_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_dashboard_notifier.g.dart';

/// Riverpod async notifier that owns the authenticated home dashboard state.
///
/// ## Lifecycle
/// - On `build()`, asks the home dashboard repository for a snapshot and
///   exposes it as `AsyncValue.data`.
/// - The repository encodes per-block load outcomes inside the snapshot so
///   one failing block never causes the whole notifier to enter
///   `AsyncValue.error` (canon §16, partial-error tolerance).
///
/// ## Why not keepAlive?
/// The home dashboard should rebuild on each navigation back to it so
/// timestamps and counters stay fresh — `keepAlive: false` (the default
/// from `@riverpod`) is exactly the right semantic here.
@riverpod
class HomeDashboardNotifier extends _$HomeDashboardNotifier {
  @override
  Future<HomeDashboardSnapshot> build() async {
    final repo = ref.watch(homeDashboardRepositoryProvider);
    return repo.loadDashboard();
  }

  /// Forces a fresh fetch of the dashboard snapshot.
  ///
  /// Used by pull-to-refresh and by per-block retry actions on partial errors.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(homeDashboardRepositoryProvider).loadDashboard(),
    );
  }
}
