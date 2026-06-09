import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';

final class NotificationContactRepositoryImpl implements NotificationContactRepository {
  const NotificationContactRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<NotificationContact?> loadContact({required final String citizenId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/api/v1/ciudadanos/$citizenId/contacto');
      return _mapContact(response.data);
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
    final data = _toJson(dni, contact);
    final existingContact = await loadContact(citizenId: citizenId);
    if (existingContact == null) {
      return _createContact(citizenId: citizenId, data: data, fallback: contact);
    }

    try {
      return await _updateContact(citizenId: citizenId, data: data, fallback: contact);
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) {
        rethrow;
      }
      return _createContact(citizenId: citizenId, data: data, fallback: contact);
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

  Map<String, dynamic> _toJson(final String dni, final NotificationContact contact) {
    final phone = _digitsOnly(contact.phone);
    return <String, dynamic>{
      'dni': _emptyToNull(dni),
      'email': _emptyToNull(contact.email),
      'telefono': phone == null ? null : int.tryParse(phone),
    };
  }

  NotificationContact? _mapContact(final Map<String, dynamic>? data) {
    final payload = _payload(data);
    if (payload == null || payload.isEmpty) {
      return null;
    }
    final phone = _string(payload['telefono']);
    final email = _string(payload['email']);
    final contact = NotificationContact(phone: phone, email: email);
    return contact.hasAnyContact ? contact : null;
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

  String? _digitsOnly(final String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '');
    return _emptyToNull(digits);
  }

  String? _emptyToNull(final String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
