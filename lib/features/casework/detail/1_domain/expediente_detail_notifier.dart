import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/3_data/expediente_detail_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expediente_detail_notifier.g.dart';

/// Owns the async load of an [ExpedienteDetail] keyed by [numexp]
/// (STORY-35).
///
/// One notifier instance per `numexp` — Riverpod's family semantics
/// keep navigation between detail pages cheap and isolated.
@riverpod
class ExpedienteDetailNotifier extends _$ExpedienteDetailNotifier {
  @override
  Future<ExpedienteDetail> build(final String numexp) async {
    final repo = ref.watch(expedienteDetailRepositoryProvider);
    return repo.loadByNumber(numexp);
  }

  /// Re-fetches the detail. Surfaces loading then either data or error.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<ExpedienteDetail>(
      () => ref.read(expedienteDetailRepositoryProvider).loadByNumber(numexp),
    );
  }
}
