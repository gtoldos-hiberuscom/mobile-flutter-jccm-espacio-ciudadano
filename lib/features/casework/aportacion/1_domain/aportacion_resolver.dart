import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_search_query.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aportacion_resolver.g.dart';

/// Thin wrapper over [CaseworkRepository] that returns at most one
/// [CaseworkItem] for an aportación search (STORY-37).
///
/// Lives in `1_domain` rather than `3_data` so the wizard does not
/// extend the repository contract — STORY-37 reuses the existing
/// `selectbynumexp` and `selectbynumreg` endpoints exposed by
/// [CaseworkRepository].
class AportacionResolver {
  const AportacionResolver(this._repository);

  final CaseworkRepository _repository;

  /// Resolves the first match for [query]. Returns `null` when no
  /// expediente or registro matches the input. Repository errors are
  /// propagated unchanged so the notifier can map them to the
  /// appropriate domain failure.
  Future<CaseworkItem?> resolve(final AportacionSearchQuery query) async {
    final results = switch (query) {
      AportacionSearchByExpediente(:final numexp) => await _repository.searchByExpedienteNumber(numexp),
      AportacionSearchByRegistro(:final numreg) => await _repository.searchByRegistroNumber(numreg),
    };
    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }
}

/// DI composition for [AportacionResolver]. Tests override this provider
/// to inject deterministic repository responses.
@riverpod
AportacionResolver aportacionResolver(final Ref ref) => AportacionResolver(ref.watch(caseworkRepositoryProvider));
