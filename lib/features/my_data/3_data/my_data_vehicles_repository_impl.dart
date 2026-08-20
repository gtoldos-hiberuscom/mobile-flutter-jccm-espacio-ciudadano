import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_vehicles_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/api/vehiculos_api.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/document_type.dart';

final class MyDataVehiclesRepositoryImpl implements MyDataVehiclesRepository {
  MyDataVehiclesRepositoryImpl({required final Dio dio}) : _api = VehiculosApi(dio);

  final VehiculosApi _api;

  @override
  Future<List<Vehicle>> loadVehicles({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final payload = await _loadRawVehicles(citizenId, documentNumber);
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

  /// Cuerpo `DTDGTLISTADOVEHICULOSREQ`.
  ///
  /// El tipo se deduce del documento: estaba fijado a `NIF`, lo que rompía la
  /// consulta para NIE y CIF. Mismo fallo que había en educación.
  ///
  /// El cliente ya devuelve `null` en 404 y la carga cruda en el resto.
  Future<Object?> _loadRawVehicles(final String citizenId, final String documentNumber) async {
    try {
      return await _api.listado(
        citizenId: citizenId,
        body: {
          'tipodoc': documentTypeOf(documentNumber),
          'docu': documentNumber,
        },
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      final rawData = error.response?.data;
      if (rawData == null) {
        rethrow;
      }
      return rawData;
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
