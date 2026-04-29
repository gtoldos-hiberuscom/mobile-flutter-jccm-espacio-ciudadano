import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';

/// Domain abstraction for loading an expediente detail (STORY-35).
///
/// The implementation lives in `3_data/` and is wired through DI in
/// `expediente_detail_repository_provider.dart`.
abstract interface class ExpedienteDetailRepository {
  /// Loads the expediente identified by [numexp] (administrative number)
  /// and its associated metadata + file list.
  ///
  /// Throws when the backend cannot resolve the expediente — the
  /// presentation layer maps the failure to an error state widget.
  Future<ExpedienteDetail> loadByNumber(final String numexp);
}
