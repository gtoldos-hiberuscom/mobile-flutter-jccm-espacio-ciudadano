import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';

/// Manejo común de las respuestas de intermediación del recurso ciudadano.
///
/// Tres estados, nunca menos:
///
/// - **404** → `null`: el organismo no tiene datos del ciudadano.
/// - **Rechazo de autorización** (sobre con `codigo-respuesta` `412.00` o
///   `codigo-error` `3034`, venga como 2xx o dentro de un error HTTP) →
///   [MyDataAuthorizationRequired], para que la pantalla ofrezca autorizar.
/// - **Cualquier otro fallo** → la `DioException` se propaga. Interpretar un
///   error de transporte como «sin datos» es lo que fabricaba estados vacíos
///   (o afirmativos) falsos durante caídas del backend.
Future<Object?> intermediacionRawResponse(final Future<Object?> Function() fetch) async {
  final Object? data;
  try {
    data = await fetch();
  } on DioException catch (error) {
    if (error.response?.statusCode == 404) {
      return null;
    }
    final rawData = error.response?.data;
    if (rawData != null && isIntermediacionAuthorizationRequired(rawData)) {
      throw const MyDataAuthorizationRequired();
    }
    rethrow;
  }
  if (data != null && isIntermediacionAuthorizationRequired(data)) {
    throw const MyDataAuthorizationRequired();
  }
  return data;
}

/// `true` cuando el sobre expresa que la consulta requiere autorización
/// (cláusula sin aceptar): `codigo-respuesta` `412.00`, o `codigo-error`
/// `3034` dentro de `info-error.errores`.
bool isIntermediacionAuthorizationRequired(final Object? data) {
  final decoded = _decodePayload(data);
  if (decoded is! Map) {
    return false;
  }
  if (decoded['codigo-respuesta']?.toString() == '412.00') {
    return true;
  }
  final infoError = decoded['info-error'];
  if (infoError is! Map) {
    return false;
  }
  final errors = infoError['errores'];
  return errors is List && errors.whereType<Map<dynamic, dynamic>>().any((final error) => error['codigo-error']?.toString() == '3034');
}

/// Desempaqueta cargas que el backend entrega como JSON anidado en cadenas.
Object? _decodePayload(final Object? payload) {
  Object? current = payload;
  for (var i = 0; i < 4; i++) {
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
      return current;
    }
  }
  return current;
}
