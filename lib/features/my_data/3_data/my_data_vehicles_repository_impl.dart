import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_vehicles_repository.dart';

final class MyDataVehiclesRepositoryImpl implements MyDataVehiclesRepository {
  MyDataVehiclesRepositoryImpl({required final Dio dio}) : _api = DgtApi(withGeneratedApiCompat(dio), standardSerializers);

  final DgtApi _api;

  @override
  Future<List<Vehicle>> loadVehicles({
    required final String documentNumber,
  }) async {
    final payload = await _loadRawVehicles(documentNumber);
    if (payload == null) {
      return const [];
    }

    final body = _asStringMap(_asStringMap(_decodePayload(payload))?['body']);

    // The API returns 'listavehiculos' which contains 'vehiculo' array
    // Structure: { "listavehiculos": { "vehiculo": [...] } }
    final listavehiculosObj = _asStringMap(body?['listavehiculos']);

    // If listavehiculos is null, return empty list
    if (listavehiculosObj == null) {
      return const [];
    }

    // Get the 'vehiculo' array from inside 'listavehiculos'
    final elementos = _asList(listavehiculosObj['vehiculo']);

    final vehicles = <Vehicle>[];
    for (final raw in elementos) {
      final element = _asStringMap(raw);
      if (element == null) {
        continue;
      }

      final vehicle = _extractVehicle(element);
      if (vehicle != null) {
        vehicles.add(vehicle);
      }
    }

    return vehicles;
  }

  Future<Object?> _loadRawVehicles(final String documentNumber) async {
    final data = {
      'docu': documentNumber,
      'tipodoc': 'NIF',
    };
    try {
      final response = await _api.getListaVehiculos(
        numDocumento: documentNumber,
        dtdgtlistadovehiculosreqBody: DTDGTLISTADOVEHICULOSREQ(
          (final builder) => builder
            ..docu = documentNumber
            ..tipodoc = 'NIF',
        ),
        extra: {
          generatedApiRequestDataExtraKey: data,
          generatedApiDecodeStringResponseExtraKey: true,
        },
        validateStatus: (final status) => status != null && status < 500,
      );
      if (response.statusCode == 404) {
        return null;
      }
      return response.extra[generatedApiRawResponseDataExtraKey] ?? response.data;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      final rawData = error.response?.extra[generatedApiRawResponseDataExtraKey] ?? error.response?.data;
      if (rawData != null) {
        return rawData;
      }
      rethrow;
    }
  }

  Vehicle? _extractVehicle(final Map<String, Object?> raw) {
    // matricula = license plate (ej: "1234ABC", "9876-KPV")
    final licensePlate = _firstString(raw, const ['matricula', 'matric']);

    if (licensePlate == null) {
      return null;
    }

    return Vehicle(licensePlate: licensePlate);
  }

  String? _firstString(final Map<String, Object?> map, final List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) {
        continue;
      }
      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  List<Object?> _asList(final Object? value) {
    if (value is List) {
      return value;
    }
    if (value == null) {
      return const [];
    }
    return [value];
  }

  Map<String, Object?>? _asStringMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return value.cast<String, Object?>();
    }
    return null;
  }

  Object? _decodePayload(final Object? payload) {
    Object? current = payload;
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
}
