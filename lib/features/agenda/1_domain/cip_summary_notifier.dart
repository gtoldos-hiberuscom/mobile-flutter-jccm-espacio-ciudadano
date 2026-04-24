import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/cip_summary.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/cip_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cip_summary_notifier.g.dart';

/// Riverpod async notifier that owns the CIP / tarjeta sanitaria
/// summary surfaced by the home salud entry point and by the agenda
/// page header (STORY-31).
///
/// ## Lifecycle
/// - On `build()`, asks the [cipRepositoryProvider] for a fresh
///   [CipSummary] and exposes it as `AsyncValue.data`.
/// - The repository encodes parse / empty / error outcomes inside the
///   summary's [CipLoadState] so the notifier stays in `data` and the
///   UI keeps partial-error tolerance (canon §16).
///
/// ## Why not keepAlive?
/// The snapshot should refresh on every navigation back so the
/// `lastUpdatedAt` stamp stays meaningful — `keepAlive: false` (the
/// default from `@riverpod`) is exactly the right semantic.
@riverpod
class CipSummaryNotifier extends _$CipSummaryNotifier {
  @override
  Future<CipSummary> build() async => ref.watch(cipRepositoryProvider).loadCip();

  /// Forces a fresh fetch of the CIP summary.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(cipRepositoryProvider).loadCip(),
    );
  }
}
