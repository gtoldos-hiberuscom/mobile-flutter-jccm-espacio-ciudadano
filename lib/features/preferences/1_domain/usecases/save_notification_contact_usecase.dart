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

final class SaveNotificationContactFailed extends SaveNotificationContactResult {
  const SaveNotificationContactFailed(this.message, {this.cause});
  final String message;
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
      return SaveNotificationContactFailed(_messageFor(error), cause: error);
    }
  }

  String _messageFor(final Object error) {
    final appError = error is DioException ? error.error : error;
    return switch (appError) {
      UnauthorizedError() => 'No tienes permisos para guardar estos datos de contacto.',
      NetworkError(:final statusCode) when statusCode == 400 => 'No hemos podido validar los datos introducidos.',
      NetworkError(:final statusCode) when statusCode == 403 => 'No tienes permisos para guardar estos datos de contacto.',
      NetworkError() => 'No hemos podido guardar los datos de contacto. Inténtalo de nuevo más tarde.',
      _ => 'No hemos podido guardar los datos de contacto. Inténtalo de nuevo más tarde.',
    };
  }
}
