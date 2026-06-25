import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';

final class NotificationContactRepositoryImpl implements NotificationContactRepository {
  NotificationContactRepositoryImpl({required final Dio dio}) : _api = CiudadanosApi(withGeneratedApiCompat(dio), standardSerializers);

  final CiudadanosApi _api;

  @override
  Future<NotificationContact?> loadContact({required final String citizenId}) async {
    final storedContact = await _loadStoredContact(citizenId: citizenId);
    return _visibleContact(storedContact);
  }

  Future<NotificationContact?> _loadStoredContact({required final String citizenId}) async {
    try {
      final response = await _api.obtenerCiudadano(
        id: citizenId,
        extra: {
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
        },
        validateStatus: (final status) => status != null && (status < 400 || status == 404),
      );
      if (response.statusCode == 404) {
        return null;
      }
      return _storedContactFromDto(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<NotificationContact> saveContact({
    required final String citizenId,
    required final String dni,
    required final NotificationContact contact,
  }) async {
    final existingContact = await _loadStoredContact(citizenId: citizenId);
    if (existingContact == null) {
      final data = _toJson(dni, contact);
      return _createContact(citizenId: citizenId, data: data, fallback: contact);
    }

    final data = _toJson(dni, contact, idTercero: existingContact.idTercero);
    final fallback = contact.copyWith(idTercero: existingContact.idTercero);
    try {
      return await _updateContact(citizenId: citizenId, data: data, fallback: fallback);
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) {
        rethrow;
      }
      return _createContact(citizenId: citizenId, data: _toJson(dni, contact), fallback: contact);
    }
  }

  Future<NotificationContact> _createContact({
    required final String citizenId,
    required final Map<String, dynamic> data,
    required final NotificationContact fallback,
  }) async {
    final request = _requestDto(data);
    try {
      final response = await _api.registrarCiudadano(
        id: citizenId,
        terceroN2Dto: request,
        extra: {
          generatedApiRequestDataExtraKey: data,
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
        },
      );
      return _storedContactFromDto(response.data) ?? fallback;
    } on DioException {
      rethrow;
    }
  }

  Future<NotificationContact> _updateContact({
    required final String citizenId,
    required final Map<String, dynamic> data,
    required final NotificationContact fallback,
  }) async {
    final request = _requestDto(data);
    try {
      final response = await _api.modificarCiudadano(
        id: citizenId,
        terceroN2Dto: request,
        extra: {
          generatedApiRequestDataExtraKey: data,
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
        },
      );
      return _storedContactFromDto(response.data) ?? fallback;
    } on DioException {
      rethrow;
    }
  }

  Map<String, dynamic> _toJson(
    final String dni,
    final NotificationContact contact, {
    final int? idTercero,
  }) {
    final phone = _digitsOnly(contact.phone);
    final data = <String, dynamic>{
      'dni': _emptyToNull(dni),
      'email': _emptyToNull(contact.email),
      'telefono': phone == null ? null : int.tryParse(phone),
    };
    if (idTercero != null) {
      data['idTercero'] = idTercero;
    }
    return data;
  }

  TerceroN2Dto _requestDto(final Map<String, dynamic> data) {
    return TerceroN2Dto((final builder) {
      builder
        ..dni = data['dni'] as String?
        ..email = data['email'] as String?
        ..idTercero = data['idTercero'] as int?
        ..telefono = data['telefono'] as int?;
    });
  }

  NotificationContact? _storedContactFromDto(final TerceroN2Dto? data) {
    if (data == null) {
      return null;
    }
    final phone = data.telefono?.toString();
    if (data.idTercero == null && phone == null && data.email == null) {
      return null;
    }
    return NotificationContact(
      idTercero: data.idTercero,
      phone: phone,
      email: _emptyToNull(data.email),
    );
  }

  NotificationContact? _visibleContact(final NotificationContact? contact) {
    if (contact == null || !contact.hasAnyContact) {
      return null;
    }
    return contact;
  }

  String? _digitsOnly(final String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '');
    return _emptyToNull(digits);
  }

  String? _emptyToNull(final String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
