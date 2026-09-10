import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class BuscarExpedienteTerceroResult {}

final class BuscarExpedienteTerceroSuccess extends BuscarExpedienteTerceroResult {
  BuscarExpedienteTerceroSuccess({required this.expediente});

  final Expediente expediente;
}

enum BuscarExpedienteTerceroFailureReason { notFound, unauthorized, unavailable }

final class BuscarExpedienteTerceroFailed extends BuscarExpedienteTerceroResult {
  BuscarExpedienteTerceroFailed({required this.reason, this.cause});

  final BuscarExpedienteTerceroFailureReason reason;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Localiza el expediente de un tercero por número de registro o por código
/// identificador (número de expediente). Asume que el llamador ya validó que
/// exactamente uno de los dos viene informado.
final class BuscarExpedienteTerceroUsecase {
  const BuscarExpedienteTerceroUsecase(this._repository);

  final GestionExpedienteRepository _repository;

  /// [citizenId] identifica al ciudadano autenticado (path `/ciudadanos/{sid}`);
  /// [documentNumber] es el documento del titular del expediente, que puede ser
  /// un tercero.
  Future<BuscarExpedienteTerceroResult> execute({
    required final String citizenId,
    required final String documentNumber,
    required final String tipodoc,
    final String? numRegistro,
    final String? numExpediente,
  }) async {
    try {
      final expediente = numRegistro != null ? await _repository.loadExpedienteByRegistro(citizenId: citizenId, documentNumber: documentNumber, numRegistro: numRegistro, tipodoc: tipodoc) : await _repository.loadExpedienteDetail(citizenId: citizenId, documentNumber: documentNumber, numexp: numExpediente!, tipodoc: tipodoc);
      return BuscarExpedienteTerceroSuccess(expediente: expediente);
    } on DioException catch (error) {
      return BuscarExpedienteTerceroFailed(reason: _reasonFor(error), cause: error);
    } on StateError catch (error) {
      // El repositorio lanza StateError cuando el backend responde 200 con
      // "No hay publicaciones para los parametros introducidos" (isubrc: 1):
      // es un "no encontrado" de negocio, no un fallo técnico.
      return BuscarExpedienteTerceroFailed(reason: BuscarExpedienteTerceroFailureReason.notFound, cause: error);
    } on Object catch (error) {
      return BuscarExpedienteTerceroFailed(reason: BuscarExpedienteTerceroFailureReason.unavailable, cause: error);
    }
  }

  BuscarExpedienteTerceroFailureReason _reasonFor(final DioException error) {
    final appError = error.error;
    return switch (appError) {
      NotFoundError() => BuscarExpedienteTerceroFailureReason.notFound,
      UnauthorizedError() => BuscarExpedienteTerceroFailureReason.unauthorized,
      NetworkError(:final statusCode) when statusCode == 404 => BuscarExpedienteTerceroFailureReason.notFound,
      _ => BuscarExpedienteTerceroFailureReason.unavailable,
    };
  }
}
