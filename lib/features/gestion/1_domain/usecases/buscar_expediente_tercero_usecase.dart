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

final class BuscarExpedienteTerceroFailed extends BuscarExpedienteTerceroResult {
  BuscarExpedienteTerceroFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Localiza el expediente de un tercero por número de registro o por código
/// identificador (número de expediente). Asume que el llamador ya validó que
/// exactamente uno de los dos viene informado.
final class BuscarExpedienteTerceroUsecase {
  const BuscarExpedienteTerceroUsecase(this._repository);

  final GestionExpedienteRepository _repository;

  Future<BuscarExpedienteTerceroResult> execute({
    required final String documentNumber,
    required final String tipodoc,
    final String? numRegistro,
    final String? numExpediente,
  }) async {
    try {
      final expediente = numRegistro != null
          ? await _repository.loadExpedienteByRegistro(documentNumber: documentNumber, numRegistro: numRegistro, tipodoc: tipodoc)
          : await _repository.loadExpedienteDetail(documentNumber: documentNumber, numexp: numExpediente!, tipodoc: tipodoc);
      return BuscarExpedienteTerceroSuccess(expediente: expediente);
    } on DioException catch (error) {
      return BuscarExpedienteTerceroFailed(message: _messageFor(error), cause: error);
    } on Object catch (error) {
      return BuscarExpedienteTerceroFailed(message: 'No hemos podido localizar el expediente. Inténtalo de nuevo más tarde.', cause: error);
    }
  }

  String _messageFor(final DioException error) {
    final appError = error.error;
    return switch (appError) {
      NotFoundError() => 'No hemos encontrado ningún expediente con esos datos. Revisa que sean correctos.',
      UnauthorizedError() => 'No tienes permisos para consultar este expediente.',
      NetworkError(:final statusCode) when statusCode == 404 => 'No hemos encontrado ningún expediente con esos datos. Revisa que sean correctos.',
      _ => 'No hemos podido localizar el expediente. Inténtalo de nuevo más tarde.',
    };
  }
}
