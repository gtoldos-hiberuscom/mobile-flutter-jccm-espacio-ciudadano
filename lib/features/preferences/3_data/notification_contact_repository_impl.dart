import 'dart:convert';

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
    final storedContact = await _loadStoredContact(citizenId: _documentIdentifier(citizenId));
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
      return _storedContactFromDto(response.data) ?? _storedContactFromRaw(response.extra[generatedApiRawResponseDataExtraKey]);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      final parsed = _storedContactFromRaw(error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey]);
      if (parsed != null) {
        return parsed;
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
    final normalizedCitizenId = _documentIdentifier(citizenId);
    final normalizedDni = _documentIdentifier(dni);
    final existingContact = await _loadStoredContact(citizenId: normalizedCitizenId);
    if (existingContact == null) {
      final data = _toJson(normalizedDni, contact);
      return _createContact(citizenId: normalizedCitizenId, data: data, fallback: contact);
    }

    final data = _toJson(normalizedDni, contact, idTercero: existingContact.idTercero);
    final fallback = contact.copyWith(idTercero: existingContact.idTercero);
    try {
      return await _updateContact(citizenId: normalizedCitizenId, data: data, fallback: fallback);
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) {
        rethrow;
      }
      return _createContact(citizenId: normalizedCitizenId, data: _toJson(normalizedDni, contact), fallback: contact);
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
      return _storedContactFromDto(response.data) ?? _storedContactFromRaw(response.extra[generatedApiRawResponseDataExtraKey]) ?? fallback;
    } on DioException catch (error) {
      final parsed = _storedContactFromRaw(error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey]);
      if (parsed != null) {
        return parsed;
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
          generatedApiRequestDataExtraKey: data,
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
        },
      );
      return _storedContactFromDto(response.data) ?? _storedContactFromRaw(response.extra[generatedApiRawResponseDataExtraKey]) ?? fallback;
    } on DioException catch (error) {
      final parsed = _storedContactFromRaw(error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey]);
      if (parsed != null) {
        return parsed;
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
        ..dni = data['dni'] as String? ?? ''
        ..email = data['email'] as String? ?? ''
        ..idTercero = data['idTercero'] as int?
        ..telefono = data['telefono'] as int?;
    });
  }

  NotificationContact? _storedContactFromDto(final TerceroN2Dto? data) {
    if (data == null) {
      return null;
    }
    final phone = data.telefono?.toString();
    return NotificationContact(
      idTercero: data.idTercero,
      phone: phone,
      email: _emptyToNull(data.email),
    );
  }

  NotificationContact? _storedContactFromRaw(final Object? data) {
    final payload = _decode(data);
    final payloadMap = _asMap(payload);
    final contactMap = _asMap(payloadMap?['body']) ?? payloadMap;
    if (contactMap == null) {
      return null;
    }
    final idTercero = _int(contactMap, 'idTercero');
    final phone = _phone(contactMap['telefono']);
    final email = _string(contactMap, 'email');
    if (idTercero == null && phone == null && email == null) {
      return null;
    }
    return NotificationContact(
      idTercero: idTercero,
      phone: phone,
      email: email,
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

  String _documentIdentifier(final String value) {
    final normalized = value.trim().toUpperCase();
    final segments = normalized.split(RegExp(r'[/\\:]')).where((final segment) => segment.isNotEmpty).toList(growable: false);
    return segments.isEmpty ? normalized : segments.last;
  }

  Object? _decode(final Object? raw) {
    Object? current = raw;
    for (var i = 0; i < 3; i++) {
      if (current is! String) {
        return current;
      }
      final trimmed = current.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        current = jsonDecode(trimmed);
      } on FormatException {
        return trimmed;
      }
    }
    return current;
  }

  Map<String, Object?>? _asMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return {
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  int? _int(final Map<String, Object?> map, final String key) {
    return switch (map[key]) {
      final int value => value,
      final num value => value.toInt(),
      final String value => int.tryParse(value),
      _ => null,
    };
  }

  String? _phone(final Object? value) {
    return switch (value) {
      final int phone => phone.toString(),
      final num phone => phone.toInt().toString(),
      final String phone => _emptyToNull(phone),
      _ => null,
    };
  }

  String? _string(final Map<String, Object?> map, final String key) {
    final value = map[key];
    if (value is String) {
      return _emptyToNull(value);
    }
    return null;
  }
}
