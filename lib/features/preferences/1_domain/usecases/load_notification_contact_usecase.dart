import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';

sealed class LoadNotificationContactResult {
  const LoadNotificationContactResult();
}

final class LoadNotificationContactSuccess extends LoadNotificationContactResult {
  const LoadNotificationContactSuccess(this.contact);
  final NotificationContact? contact;
}

final class LoadNotificationContactFailed extends LoadNotificationContactResult {
  const LoadNotificationContactFailed(this.message, {this.cause});
  final String message;
  final Object? cause;
}

final class LoadNotificationContactUsecase {
  const LoadNotificationContactUsecase(this._repository);

  final NotificationContactRepository _repository;

  Future<LoadNotificationContactResult> execute({required final String citizenId}) async {
    try {
      final contact = await _repository.loadContact(citizenId: citizenId);
      return LoadNotificationContactSuccess(contact);
    } on Object catch (error) {
      // En PRE el cliente generado puede propagar el 404 del recurso
      // `/contacto` después de que lo haya clasificado el interceptor global.
      // Para este recurso no es un fallo: significa que el ciudadano aún no
      // está dado de alta en Notifica y debe mostrarse el formulario de alta.
      if (_isNotRegistered(error)) {
        return const LoadNotificationContactSuccess(null);
      }
      return LoadNotificationContactFailed(_messageFor(error), cause: error);
    }
  }

  bool _isNotRegistered(final Object error) {
    if (error is DioException && error.response?.statusCode == 404) {
      return true;
    }
    final appError = error is DioException ? error.error : error;
    return appError is NotFoundError || (appError is NetworkError && appError.statusCode == 404);
  }

  String _messageFor(final Object error) {
    final appError = error is DioException ? error.error : error;
    return switch (appError) {
      UnauthorizedError() => 'No tienes permisos para consultar tus datos de contacto.',
      NetworkError(:final statusCode) when statusCode == 403 => 'No tienes permisos para consultar tus datos de contacto.',
      NetworkError() => 'No hemos podido cargar tus datos de contacto. Inténtalo de nuevo más tarde.',
      _ => 'No hemos podido cargar tus datos de contacto. Inténtalo de nuevo más tarde.',
    };
  }
}
