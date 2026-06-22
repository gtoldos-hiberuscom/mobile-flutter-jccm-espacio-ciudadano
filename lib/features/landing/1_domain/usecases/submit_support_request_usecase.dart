import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';

sealed class SubmitSupportRequestResult {
  const SubmitSupportRequestResult();
}

final class SubmitSupportRequestSuccess extends SubmitSupportRequestResult {
  const SubmitSupportRequestSuccess();
}

final class SubmitSupportRequestFailed extends SubmitSupportRequestResult {
  const SubmitSupportRequestFailed(this.message, {this.cause});

  final String message;
  final Object? cause;
}

final class SubmitSupportRequestUsecase {
  const SubmitSupportRequestUsecase(this._repository);

  final SupportRepository _repository;

  Future<SubmitSupportRequestResult> execute(final SupportRequest request) async {
    try {
      await _repository.submitSupportRequest(request);
      return const SubmitSupportRequestSuccess();
    } on Object catch (error) {
      return SubmitSupportRequestFailed(_messageFor(error), cause: error);
    }
  }

  String _messageFor(final Object error) {
    final appError = error is DioException ? error.error : error;
    return switch (appError) {
      UnauthorizedError() => 'No tienes permisos para enviar el formulario de soporte.',
      NetworkError(:final statusCode) when statusCode == 400 => 'No hemos podido validar los datos introducidos.',
      NetworkError(:final statusCode) when statusCode == 403 => 'No tienes permisos para enviar el formulario de soporte.',
      NetworkError() => 'No hemos podido enviar tu solicitud. Inténtalo de nuevo más tarde.',
      _ => 'No hemos podido enviar tu solicitud. Inténtalo de nuevo más tarde.',
    };
  }
}
