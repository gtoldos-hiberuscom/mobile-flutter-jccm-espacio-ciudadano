import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';

sealed class SaveNotificationContactResult {
  const SaveNotificationContactResult();
}

final class SaveNotificationContactSuccess extends SaveNotificationContactResult {
  const SaveNotificationContactSuccess(this.contact);
  final NotificationContact contact;
}

enum SaveNotificationContactFailureReason { unauthorized, invalidData, unavailable }

final class SaveNotificationContactFailed extends SaveNotificationContactResult {
  const SaveNotificationContactFailed(this.reason, {this.cause});
  final SaveNotificationContactFailureReason reason;
  final Object? cause;
}

final class SaveNotificationContactUsecase {
  const SaveNotificationContactUsecase(this._repository);

  final NotificationContactRepository _repository;

  Future<SaveNotificationContactResult> execute({
    required final String citizenId,
    required final String dni,
    required final NotificationContact contact,
  }) async {
    try {
      final savedContact = await _repository.saveContact(
        citizenId: citizenId,
        dni: dni,
        contact: contact,
      );
      return SaveNotificationContactSuccess(savedContact);
    } on Object catch (error) {
      return SaveNotificationContactFailed(_reasonFor(error), cause: error);
    }
  }

  SaveNotificationContactFailureReason _reasonFor(final Object error) {
    final appError = error is DioException ? error.error : error;
    return switch (appError) {
      UnauthorizedError() => SaveNotificationContactFailureReason.unauthorized,
      NetworkError(:final statusCode) when statusCode == 400 => SaveNotificationContactFailureReason.invalidData,
      NetworkError(:final statusCode) when statusCode == 403 => SaveNotificationContactFailureReason.unauthorized,
      _ => SaveNotificationContactFailureReason.unavailable,
    };
  }
}
