import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_vehicles_repository.dart';

final class MyDataVehiclesRepositoryImpl implements MyDataVehiclesRepository {
  const MyDataVehiclesRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Vehicle>> loadVehicles({
    required final String documentNumber,
  }) async {
    final Response<String> response;
    try {
      response = await _dio.post<String>(
        '/api/v1/dgt/lista-vehiculos/${Uri.encodeComponent(documentNumber)}',
        data: {
          'docu': documentNumber,
          'tipodoc': 'NIF',
        },
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      rethrow;
    }

    final payload = response.data;
    if (payload == null || payload.trim().isEmpty) {
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

  dynamic _decodePayload(final String payload) {
    try {
      return jsonDecode(payload);
    } on Exception {
      return null;
    }
  }
}
