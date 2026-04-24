import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/3_data/registro_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registro_detail_notifier.g.dart';

/// Loads and exposes the detail of a registro entrada / salida
/// (STORY-36) as an `AsyncValue<RegistroDetail>`.
///
/// The notifier is keyed by `(numreg, kind)` so each detail screen owns
/// its own state and side effects stay isolated per route instance.
@riverpod
class RegistroDetailNotifier extends _$RegistroDetailNotifier {
  @override
  Future<RegistroDetail> build(final String numreg, final RegistroKind kind) {
    final repo = ref.watch(registroRepositoryProvider);
    return repo.loadByNumber(numreg: numreg, kind: kind);
  }

  /// Reloads the detail surface — used by the error retry CTA.
  Future<void> refresh() async {
    state = const AsyncValue<RegistroDetail>.loading();
    state = await AsyncValue.guard<RegistroDetail>(
      () => ref.read(registroRepositoryProvider).loadByNumber(
            numreg: numreg,
            kind: kind,
          ),
    );
  }
}
