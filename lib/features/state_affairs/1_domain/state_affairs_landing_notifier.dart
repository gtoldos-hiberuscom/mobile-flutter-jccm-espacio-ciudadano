import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/state_affairs_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/3_data/state_affairs_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state_affairs_landing_notifier.g.dart';

/// Owns the Estado y otros temas de interés landing state (STORY-26).
///
/// Loads a [StateAffairsSnapshot] from the repository on `build()` and
/// exposes a [refresh] hook for `RefreshIndicator`. Per-section status
/// is encoded in the snapshot itself, so individual UI cards can render
/// loading / empty / error independently.
@riverpod
class StateAffairsLandingNotifier extends _$StateAffairsLandingNotifier {
  @override
  Future<StateAffairsSnapshot> build() async {
    final repo = ref.watch(stateAffairsRepositoryProvider);
    return repo.loadSnapshot();
  }

  /// Forces a fresh fetch of the landing snapshot.
  Future<void> refresh() async {
    state = const AsyncValue<StateAffairsSnapshot>.loading();
    state = await AsyncValue.guard<StateAffairsSnapshot>(
      () => ref.read(stateAffairsRepositoryProvider).loadSnapshot(),
    );
  }
}
