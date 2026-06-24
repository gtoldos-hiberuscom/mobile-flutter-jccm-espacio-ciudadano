import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';

final class NotificationContactRepositoryImpl implements NotificationContactRepository {
  const NotificationContactRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<NotificationContact?> loadContact({required final String citizenId}) async {
    final storedContact = await _loadStoredContact(citizenId: citizenId);
    return _visibleContact(storedContact);
  }

  Future<NotificationContact?> _loadStoredContact({required final String citizenId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/ciudadanos/$citizenId/contacto',
      options: Options(
        validateStatus: (final status) => status != null && (status < 400 || status == 404),
      ),
    );
    if (response.statusCode == 404) {
      return null;
    }
    return _storedContact(response.data);
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
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/ciudadanos/$citizenId/contacto',
      data: data,
    );
    return _mapContact(response.data) ?? fallback;
  }

  Future<NotificationContact> _updateContact({
    required final String citizenId,
    required final Map<String, dynamic> data,
    required final NotificationContact fallback,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/api/v1/ciudadanos/$citizenId/contacto',
      data: data,
    );
    return _mapContact(response.data) ?? fallback;
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

  NotificationContact? _mapContact(final Map<String, dynamic>? data) {
    final contact = _storedContact(data);
    return _visibleContact(contact);
  }

  NotificationContact? _storedContact(final Map<String, dynamic>? data) {
    final payload = _payload(data);
    if (payload == null || payload.isEmpty) {
      return null;
    }
    final idTercero = _int(payload['idTercero']);
    final phone = _string(payload['telefono']);
    final email = _string(payload['email']);
    if (idTercero == null && phone == null && email == null) {
      return null;
    }
    return NotificationContact(idTercero: idTercero, phone: phone, email: email);
  }

  NotificationContact? _visibleContact(final NotificationContact? contact) {
    if (contact == null || !contact.hasAnyContact) {
      return null;
    }
    return contact;
  }

  Map<String, dynamic>? _payload(final Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final body = data['body'];
    if (body is Map<String, dynamic>) {
      return body;
    }
    return data;
  }

  String? _string(final Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  int? _int(final Object? value) {
    if (value is int) {
      return value;
    }
    final text = _string(value);
    return text == null ? null : int.tryParse(text);
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
