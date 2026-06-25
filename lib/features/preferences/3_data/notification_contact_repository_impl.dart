import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';

final class NotificationContactRepositoryImpl implements NotificationContactRepository {
  NotificationContactRepositoryImpl({required final Dio dio}) : _api = CiudadanosApi(_withGeneratedApiCompat(dio), standardSerializers);

  final CiudadanosApi _api;

  static const _rawResponseExtraKey = 'generated_api.raw_response_data';
  static const _requestDataExtraKey = 'generated_api.request_data';

  @override
  Future<NotificationContact?> loadContact({required final String citizenId}) async {
    final storedContact = await _loadStoredContact(citizenId: citizenId);
    return _visibleContact(storedContact);
  }

  Future<NotificationContact?> _loadStoredContact({required final String citizenId}) async {
    try {
      final response = await _api.obtenerCiudadano(
        id: citizenId,
        validateStatus: (final status) => status != null && (status < 400 || status == 404),
      );
      if (response.statusCode == 404) {
        return null;
      }
      return _storedContactFromResponse(response);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      final storedContact = _storedContactFromRaw(error.response?.data);
      if (storedContact != null) {
        return storedContact;
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
          _requestDataExtraKey: data,
        },
      );
      return _storedContactFromResponse(response) ?? fallback;
    } on DioException catch (error) {
      final storedContact = _storedContactFromRaw(error.response?.data);
      if (storedContact != null) {
        return storedContact;
      }
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
          _requestDataExtraKey: data,
        },
      );
      return _storedContactFromResponse(response) ?? fallback;
    } on DioException catch (error) {
      final storedContact = _storedContactFromRaw(error.response?.data);
      if (storedContact != null) {
        return storedContact;
      }
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

  NotificationContact? _storedContactFromResponse(final Response<TerceroN2Dto> response) {
    final contact = _storedContactFromDto(response.data);
    if (contact != null) {
      return contact;
    }
    return _storedContactFromRaw(response.extra[_rawResponseExtraKey]);
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

  NotificationContact? _storedContactFromRaw(final Object? data) {
    final payload = _payload(data);
    if (payload == null) {
      return null;
    }
    return _storedContact(payload);
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

  Map<String, dynamic>? _payload(final Object? data) {
    if (data == null) {
      return null;
    }
    if (data is! Map) {
      return null;
    }
    final map = data is Map<String, dynamic> ? data : <String, dynamic>{for (final entry in data.entries) '${entry.key}': entry.value};
    final body = data['body'];
    if (body is Map<String, dynamic>) {
      return body;
    }
    if (body is Map) {
      return <String, dynamic>{for (final entry in body.entries) '${entry.key}': entry.value};
    }
    return map;
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

Dio _withGeneratedApiCompat(final Dio dio) {
  if (dio.interceptors.any((final interceptor) => interceptor is _GeneratedApiCompatInterceptor)) {
    return dio;
  }
  dio.interceptors.insert(0, const _GeneratedApiCompatInterceptor());
  return dio;
}

final class _GeneratedApiCompatInterceptor extends Interceptor {
  const _GeneratedApiCompatInterceptor();

  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    final requestData = options.extra[NotificationContactRepositoryImpl._requestDataExtraKey];
    if (requestData is Map<String, dynamic>) {
      options.data = requestData;
    }
    handler.next(options);
  }

  @override
  void onResponse(final Response<dynamic> response, final ResponseInterceptorHandler handler) {
    response.extra.putIfAbsent(
      NotificationContactRepositoryImpl._rawResponseExtraKey,
      () => response.data,
    );
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    err.response?.extra.putIfAbsent(
      NotificationContactRepositoryImpl._rawResponseExtraKey,
      () => err.response?.data,
    );
    handler.next(err);
  }
}
