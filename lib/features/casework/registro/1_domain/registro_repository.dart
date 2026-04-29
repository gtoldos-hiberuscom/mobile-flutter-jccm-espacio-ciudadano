import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';

/// Domain abstraction over `/publicacion/selectbynumreg` for STORY-36.
///
/// The presentation layer depends only on this interface — concrete
/// HTTP datasources live in `3_data/` and are wired through Riverpod.
abstract class RegistroRepository {
  /// Loads the detail of a registro identified by [numreg] and [kind].
  ///
  /// Throws when the registro is not available so the presentation layer
  /// can render the standard error UI through `core/ui_states/`.
  Future<RegistroDetail> loadByNumber({
    required final String numreg,
    required final RegistroKind kind,
  });
}
