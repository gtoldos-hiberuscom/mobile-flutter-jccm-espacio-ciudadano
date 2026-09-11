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

enum SubmitSupportRequestFailureReason { unauthorized, invalidData, unavailable }

final class SubmitSupportRequestFailed extends SubmitSupportRequestResult {
  const SubmitSupportRequestFailed(this.reason, {this.cause});

  final SubmitSupportRequestFailureReason reason;
  final Object? cause;
}

final class SubmitSupportRequestUsecase {
  const SubmitSupportRequestUsecase(this._repository);

  final SupportRepository _repository;

  Future<SubmitSupportRequestResult> execute(final SupportRequest request, {final String? idAgente}) async {
    try {
      await _repository.submitSupportRequest(request, idAgente: idAgente);
      return const SubmitSupportRequestSuccess();
    } on Object catch (error) {
      return SubmitSupportRequestFailed(_reasonFor(error), cause: error);
    }
  }

  SubmitSupportRequestFailureReason _reasonFor(final Object error) {
    final appError = error is DioException ? error.error : error;
    return switch (appError) {
      UnauthorizedError() => SubmitSupportRequestFailureReason.unauthorized,
      NetworkError(:final statusCode) when statusCode == 400 => SubmitSupportRequestFailureReason.invalidData,
      NetworkError(:final statusCode) when statusCode == 403 => SubmitSupportRequestFailureReason.unauthorized,
      _ => SubmitSupportRequestFailureReason.unavailable,
    };
  }
}
