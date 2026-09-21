import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_employment_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/api/empleo_api.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/document_type.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_request.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

final class MyDataEmploymentRepositoryImpl implements MyDataEmploymentRepository {
  MyDataEmploymentRepositoryImpl({required final Dio dio}) : _api = EmpleoApi(dio);

  final EmpleoApi _api;

  @override
  Future<EmploymentDemand?> loadDemand({
    required final String citizenId,
    required final String documentNumber,
    final String? givenName,
    final String? firstSurname,
    final String? secondSurname,
  }) async {
    final payload = await _rawResponse(
      () => _api.demandanteEmpleoFechaActual(
        citizenId: citizenId,
        body: _jobSeekerRequest(
          documentNumber: documentNumber,
          givenName: givenName,
          firstSurname: firstSurname,
          secondSurname: secondSurname,
        ),
      ),
    );

    if (payload == null) {
      return null;
    }

    final decoded = _decodePayload(payload);
    final root = _asStringMap(decoded);
    final body = root == null ? null : _asStringMap(_decodePayload(root['body']));
    final data = body ?? root ?? _collectMaps(decoded).firstOrNull;
    if (data == null) {
      return null;
    }

    final status = _statusLabel(
      _firstString(data, const ['inscrito', 'estado', 'situacion', 'situación']),
    );
    final uninterruptedRegistrationDate = _parseDate(
      _firstString(data, const ['ultimainscrip', 'ultimaInscrip', 'fechaInscripcion', 'fecha_inscripcion']),
    );

    // `resul` es el código de resultado de la consulta, no el estado de la
    // demanda. Por ejemplo, `resul: 1` + "Titular no identificado" + campos
    // nulos significa que no hay una demanda activa; tratar ese 1 como un
    // booleano fabricaba el estado «Activa».
    if (status == null && uninterruptedRegistrationDate == null) {
      return null;
    }

    final demand = EmploymentDemand(
      status: status,
      uninterruptedRegistrationDate: uninterruptedRegistrationDate,
      message: _firstString(data, const ['mensaje', 'literalError', 'descripcion']),
    );

    return demand;
  }

  @override
  Future<List<EmploymentOfferRegistration>> loadOfferRegistrations({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final payload = await _rawResponse(
      () => _api.ofertasEmpleo(
        citizenId: citizenId,
        body: intermediacionRequest(documentNumber),
      ),
    );

    if (payload == null) {
      return const [];
    }

    return _parseOfferRegistrations(_decodePayload(payload));
  }

  /// Cuerpo `DTSEPESVDIDEFAREQ`.
  ///
  /// A diferencia de intermediación, aquí el contrato no pide `tipo`, `idaut`
  /// ni `proc`. Los datos del titular se omiten cuando el token no los informa
  /// en vez de viajar vacíos: un campo obligatorio en blanco es más difícil de
  /// diagnosticar que uno ausente.
  ///
  /// Los nombres de campo son los del OpenAPI de la fachada
  /// (`nombretitular`, `apellido1TITULAR`, `apellido2TITULAR`), no los de la
  /// documentación del gateway (`nombre_titular`, `apellido1_titular`,
  /// `apellido2_titular`). El gateway sólo reescribe el identificador del path y
  /// reenvía el resto tal cual, así que quien vincula el cuerpo es la fachada, y
  /// su contrato está generado desde el código. Ver `EmpleoApi.jobOffersOperation`,
  /// donde la misma discrepancia se resolvió del mismo lado con una prueba
  /// directa. Si esto fuera al revés el fallo sería silencioso —los campos se
  /// ignorarían, que es lo que pasaba antes de migrar—, no un error.
  Map<String, Object?> _jobSeekerRequest({
    required final String documentNumber,
    required final String? givenName,
    required final String? firstSurname,
    required final String? secondSurname,
  }) {
    final holderName = _trimmedOrNull(givenName);
    final holderFirstSurname = _trimmedOrNull(firstSurname);
    final holderSecondSurname = _trimmedOrNull(secondSurname);

    return {
      'tipodoc': documentTypeOf(documentNumber),
      'docu': documentNumber,
      'nombretitular': ?holderName,
      'apellido1TITULAR': ?holderFirstSurname,
      'apellido2TITULAR': ?holderSecondSurname,
    };
  }

  String? _trimmedOrNull(final String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  List<EmploymentOfferRegistration> _parseOfferRegistrations(final Object? payload) {
    final specificData = <Object?>[];

    void findSpecificData(final Object? node) {
      switch (node) {
        case final Map<dynamic, dynamic> map:
          for (final entry in map.entries) {
            if (entry.key.toString().toLowerCase() == 'datosespecificos') {
              specificData.add(_decodePayload(entry.value));
            } else {
              findSpecificData(entry.value);
            }
          }
        case final List<dynamic> list:
          list.forEach(findSpecificData);
      }
    }

    findSpecificData(payload);
    final candidates = specificData.expand(_collectMaps);
    final offers = <EmploymentOfferRegistration>[];

    for (final data in candidates) {
      final title = _firstString(data, const [
        'nombreOfertaEmpleo',
        'titulo',
        'denominacion',
        'descripcion',
        'nombreOferta',
        'oferta',
        'puesto',
      ]);
      final registrationDate = _parseDate(
        _firstString(data, const ['fechaInscripcion', 'fechainscrip', 'fecha_inscripcion']),
      );
      final publicationDate = _parseDate(
        _firstString(data, const ['fechaPublicacion', 'fechapublicacion', 'fecha_publicacion']),
      );
      final selectionEndDate = _parseDate(
        _firstString(data, const [
          'fechaFinalizacionProceso',
          'fechaFinSeleccion',
          'fechafinseleccion',
          'fechaFin',
          'fechafin',
          'fecha_cierre',
        ]),
      );
      final applicationStatus = _firstString(data, const [
        'estadoCandidatura',
        'estadocandidatura',
        'estado',
        'situacion',
      ]);

      if (title == null || title.isEmpty) {
        continue;
      }
      offers.add(
        EmploymentOfferRegistration(
          title: title,
          publicationDate: publicationDate,
          registrationDate: registrationDate,
          selectionEndDate: selectionEndDate,
          applicationStatus: applicationStatus,
        ),
      );
    }

    return offers;
  }

  /// Tres estados: 404 → `null`, rechazo de autorización → excepción tipada,
  /// resto de errores → se propagan. Ver [intermediacionRawResponse].
  Future<Object?> _rawResponse(final Future<Object?> Function() fetch) => intermediacionRawResponse(fetch);

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

  List<Map<String, Object?>> _collectMaps(final Object? value) {
    final maps = <Map<String, Object?>>[];

    void visit(final Object? node) {
      switch (node) {
        case final Map<String, Object?> map:
          maps.add(map);
          map.values.forEach(visit);
        case final Map<dynamic, dynamic> map:
          final normalized = <String, Object?>{
            for (final entry in map.entries)
              if (entry.key != null) entry.key.toString(): entry.value,
          };
          maps.add(normalized);
          normalized.values.forEach(visit);
        case final List<dynamic> list:
          list.forEach(visit);
      }
    }

    visit(value);
    return maps;
  }

  Map<String, Object?>? _asStringMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return <String, Object?>{
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  String? _firstString(final Map<String, Object?> map, final List<String> keys) {
    for (final key in keys) {
      final value = _valueForKey(map, key);
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value is num) {
        return value.toString();
      }
      if (value is bool) {
        return value.toString();
      }
    }
    return null;
  }

  Object? _valueForKey(final Map<String, Object?> map, final String key) {
    final lowerKey = key.toLowerCase();
    for (final entry in map.entries) {
      if (entry.key.toLowerCase() == lowerKey) {
        return entry.value;
      }
    }
    return null;
  }

  DateTime? _parseDate(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return iso;
    }

    final compact = RegExp(r'^(\d{4})(\d{2})(\d{2})$').firstMatch(trimmed);
    if (compact != null) {
      return DateTime(
        int.parse(compact.group(1)!),
        int.parse(compact.group(2)!),
        int.parse(compact.group(3)!),
      );
    }

    final match = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})').firstMatch(trimmed);
    if (match == null) {
      return null;
    }

    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (day == null || month == null || year == null) {
      return null;
    }
    if (month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }
    return DateTime(year, month, day);
  }

  /// `null` cuando el backend no informa el estado: fabricar «Activa» por
  /// defecto convertía cualquier cuerpo inesperado en una demanda activa falsa.
  String? _statusLabel(final String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    final upper = normalized.toUpperCase();
    if (upper == 'S' || upper == 'SI' || upper == 'SÍ' || upper == 'TRUE' || upper == '1') {
      return 'Activa';
    }
    if (upper == 'N' || upper == 'NO' || upper == 'FALSE' || upper == '0') {
      return 'No Inscrito';
    }
    return normalized;
  }
}
