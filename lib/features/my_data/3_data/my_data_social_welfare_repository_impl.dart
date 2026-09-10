

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/dependency_care_status.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/disability_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/large_family_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/parking_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/thermal_spa_award.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_social_welfare_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/api/bienestar_social_api.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_request.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

final class MyDataSocialWelfareRepositoryImpl implements MyDataSocialWelfareRepository {
  MyDataSocialWelfareRepositoryImpl({required final Dio dio}) : _api = BienestarSocialApi(dio);

  final BienestarSocialApi _api;

  @override
  Future<LargeFamilyTitle?> loadLargeFamilyTitle({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final response = await _rawResponse(
      () => _api.familiaNumerosa(
        citizenId: citizenId,
        body: intermediacionRequest(documentNumber),
      ),
    );
    if (response == null) {
      return null;
    }

    final payload = _decodePayload(response);
    _throwIfLargeFamilyQueryFailed(payload);
    return _parseLargeFamilyTitle(payload);
  }

  @override
  Future<DisabilityTitle?> loadDisabilityTitle({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final response = await _rawResponse(
      () => _api.discapacidad(
        citizenId: citizenId,
        body: intermediacionRequest(documentNumber),
      ),
    );
    if (response == null) {
      return null;
    }

    return _parseDisabilityTitle(_decodePayload(response));
  }

  @override
  Future<ThermalSpaAward?> loadThermalSpaAward({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final response = await _rawResponse(
      () => _api.termalismo(
        citizenId: citizenId,
        body: intermediacionRequest(documentNumber),
      ),
    );
    if (response == null) {
      return null;
    }

    return _parseThermalSpaAward(_decodePayload(response));
  }

  @override
  Future<DependencyCareStatus?> loadDependencyCareStatus({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final response = await _rawResponse(
      () => _api.atencionDependencia(
        citizenId: citizenId,
        body: intermediacionRequest(documentNumber),
      ),
    );
    if (response == null) {
      return null;
    }

    return _parseDependencyCareStatus(_decodePayload(response));
  }

  @override
  Future<ParkingCard?> loadParkingCard({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final response = await _rawResponse(
      () => _api.tarjetaEstacionamiento(
        citizenId: citizenId,
        body: intermediacionRequest(documentNumber),
      ),
    );
    if (response == null) {
      return null;
    }

    return _parseParkingCard(_decodePayload(response));
  }

  /// Tres estados: 404 → `null`, rechazo de autorización → excepción tipada,
  /// resto de errores → se propagan. Ver [intermediacionRawResponse].
  Future<Object?> _rawResponse(final Future<Object?> Function() fetch) => intermediacionRawResponse(fetch);

  void _throwIfLargeFamilyQueryFailed(final Object? payload) {
    for (final map in _collectMaps(payload)) {
      final resultValue = map['codestado'] ?? map['resul'];
      if (resultValue == null) {
        continue;
      }
      final result = resultValue.toString().trim();
      if (result.isEmpty || result == '0') {
        return;
      }
      final message = map['mensaje']?.toString().trim();
      throw StateError(
        message == null || message.isEmpty ? 'El servicio de familia numerosa no devolvió una respuesta válida.' : message,
      );
    }
  }

  LargeFamilyTitle? _parseLargeFamilyTitle(final Object? payload) {
    final maps = _collectMaps(payload);
    if (maps.isEmpty) {
      return null;
    }

    final titleMap = maps.firstWhere(
      _looksLikeTitle,
      orElse: () => maps.first,
    );

    final titleNumber = _firstString(titleMap, const [
      'numero_titulo',
      'numeroTitulo',
      'numTitulo',
      'nutitulo',
      'titulo',
    ]);
    final category = _firstString(titleMap, const ['categoria', 'category']);
    final hasTitle = titleNumber != null || category != null;
    if (!hasTitle) {
      return null;
    }

    return LargeFamilyTitle(
      region: _regionName(_firstString(titleMap, const ['codigo_comunidad_automa', 'codigoComunidadAutoma', 'comunidadAutonoma', 'comaut', 'ccaa'])),
      titleNumber: titleNumber ?? '',
      category: _normalizeCategory(category),
      isValid: _parseBool(_firstString(titleMap, const ['titulo_vigente', 'tituloVigente', 'vigente'])) ?? true,
      issueDate: _parseDate(_firstString(titleMap, const ['fecha_efecto', 'fechaEfecto', 'fechaExpedicion', 'fecexpedi', 'fecha_validez_desde', 'fechaValidezDesde'])),
      expiryDate: _parseDate(_firstString(titleMap, const ['fecha_caducidad', 'fechaCaducidad', 'feccaduci', 'fecha_validez_hasta', 'fechaValidezHasta'])),
      childrenCount: _firstInt(titleMap, const ['numero_hijos', 'numeroHijos', 'numhij', 'hijos']),
      beneficiaries: _parseBeneficiaries(maps),
    );
  }

  DisabilityTitle? _parseDisabilityTitle(final Object? payload) {
    final maps = _collectMaps(payload);
    if (maps.isEmpty) {
      return null;
    }

    final titleMap = maps.firstWhere(
      _looksLikeDisabilityTitle,
      orElse: () => maps.first,
    );

    final degree = _firstInt(titleMap, const [
      'grado_discapacidad',
      'gradoDiscapacidad',
      'grado_disc',
      'grado',
      'porcentajeDiscapacidad',
      'porcentaje_discapacidad',
    ]);
    final fileNumber = _firstString(titleMap, const [
      'numero_expediente',
      'numeroExpediente',
      'numero_expte',
      'expediente',
      'numExpediente',
    ]);
    final hasTitle = degree != null || fileNumber != null;
    if (!hasTitle) {
      return null;
    }

    return DisabilityTitle(
      degreePercent: degree,
      effectiveDate: _parseDate(_firstString(titleMap, const ['fecha_efectos', 'fechaEfectos', 'fecha_efecto', 'fechaEfecto'])),
      hasPermanentValidity: _parseBool(_firstString(titleMap, const ['validez_definitiva', 'validezDefinitiva', 'definitivo'])),
      fileNumber: fileNumber ?? '',
      birthDate: _parseDate(_firstString(titleMap, const ['fecha_nacimiento', 'fechaNacimiento'])),
      hasReducedMobility: _parseBool(_firstString(titleMap, const ['procede_movilidad', 'procedeMovilidad', 'movilidadReducida'])),
      hasThirdPersonAssistance: _parseBool(_firstString(titleMap, const ['reconocido_concurso_tercera_persona', 'reconocidoConcursoTerceraPersona', 'terceraPersona', 'procede_atp_bvd'])),
      royalDecree: _normalizeRoyalDecree(
        _firstString(titleMap, const [
          'real_decreto',
          'realDecreto',
          'real_decreto_grado',
          'realDecretoGrado',
          'normativa',
        ]),
      ),
    );
  }

  ThermalSpaAward? _parseThermalSpaAward(final Object? payload) {
    final maps = _collectMaps(payload);
    if (maps.isEmpty) {
      return null;
    }

    final awardMap = maps.firstWhere(
      _looksLikeThermalSpaAward,
      orElse: () => maps.first,
    );

    final name = _firstString(awardMap, const [
      'nombre_balneario',
      'nombreBalneario',
      'NombreBalneario',
      'balneario',
      'Balneario',
      'denominacion_balneario',
      'denominacionBalneario',
      'nombre',
    ]);
    if (name == null) {
      return null;
    }

    return ThermalSpaAward(
      name: name,
      startDate: _parseDate(
        _firstString(awardMap, const [
          'fecha_desde',
          'fechaDesde',
          'fecha_inicio',
          'fechaInicio',
          'FechaInicio',
          'FechaEntrada',
          'fec_desde',
          'fecDesde',
        ]),
      ),
      endDate: _parseDate(
        _firstString(awardMap, const [
          'fecha_hasta',
          'fechaHasta',
          'fecha_fin',
          'fechaFin',
          'FechaFin',
          'FechaSalida',
          'fec_hasta',
          'fecHasta',
        ]),
      ),
    );
  }

  DependencyCareStatus? _parseDependencyCareStatus(final Object? payload) {
    final maps = _collectMaps(payload);
    if (maps.isEmpty) {
      return null;
    }

    final statusMap = maps.firstWhere(
      _looksLikeDependencyCareStatus,
      orElse: () => maps.first,
    );

    final requestDate = _parseDate(_firstString(statusMap, const ['fecha_solicitud', 'fechaSolicitud', 'FechasEntrada', 'FechaSolicitud', 'fec_solicitud', 'fecSolicitud']));
    final resolutionDate = _parseDate(_firstString(statusMap, const ['fecha_resolucion', 'fechaResolucion', 'FechaResolucion', 'fec_resolucion', 'fecResolucion']));
    final degree = _firstString(statusMap, const ['grado_reconocido', 'gradoReconocido', 'GradoReconocido', 'grado', 'grado_dep', 'gradoDependencia']);
    final baremo = _firstString(statusMap, const ['baremo', 'Baremo', 'puntuacion_baremo', 'puntuacionBaremo']);
    final benefits = _parseDependencyBenefits(maps);

    final hasStatus = requestDate != null || resolutionDate != null || degree != null || baremo != null || benefits.isNotEmpty;
    if (!hasStatus) {
      return null;
    }

    return DependencyCareStatus(
      requestDate: requestDate,
      resolutionDate: resolutionDate,
      recognizedDegree: _normalizeDependencyDegree(degree),
      baremo: baremo ?? '',
      benefits: benefits,
    );
  }

  ParkingCard? _parseParkingCard(final Object? payload) {
    final maps = _collectMaps(payload);
    if (maps.isEmpty) {
      return null;
    }

    final cardMap = maps.firstWhere(
      _looksLikeParkingCard,
      orElse: () => maps.first,
    );

    final code = _firstString(cardMap, const [
      'codigo_tarjeta',
      'codigoTarjeta',
      'CodigoTarjeta',
      'IDTarjeta',
      'cod_tarjeta',
      'codTarjeta',
      'numero_tarjeta',
      'numeroTarjeta',
      'NumeroTarjeta',
      'tarjeta',
    ]);
    final modality = _firstString(cardMap, const [
      'modalidad',
      'Modalidad',
      'tipo_modalidad',
      'tipoModalidad',
      'TipoModalidad',
    ]);
    final hasCard = code != null || modality != null;
    if (!hasCard) {
      return null;
    }

    return ParkingCard(
      cardCode: code ?? '',
      modality: modality ?? '',
      validFrom: _parseDate(
        _firstString(cardMap, const [
          'fecha_vigencia_desde',
          'fechaVigenciaDesde',
          'FechaVigenciaDesde',
          'FechaVigencia_Desde',
          'fecha_desde',
          'fechaDesde',
          'FechaDesde',
        ]),
      ),
      validUntil: _parseDate(
        _firstString(cardMap, const [
          'fecha_vigencia_hasta',
          'fechaVigenciaHasta',
          'FechaVigenciaHasta',
          'FechaVigencia_Hasta',
          'fecha_hasta',
          'fechaHasta',
          'FechaHasta',
        ]),
      ),
    );
  }

  bool _looksLikeTitle(final Map<String, Object?> map) {
    return _firstString(map, const ['numero_titulo', 'numeroTitulo', 'numTitulo', 'nutitulo']) != null || _firstString(map, const ['categoria', 'titulo_vigente', 'tituloVigente', 'vigente']) != null;
  }

  bool _looksLikeDisabilityTitle(final Map<String, Object?> map) {
    return _firstInt(map, const ['grado_discapacidad', 'gradoDiscapacidad', 'grado_disc', 'grado']) != null || _firstString(map, const ['numero_expediente', 'numeroExpediente', 'numero_expte', 'expediente']) != null;
  }

  bool _looksLikeThermalSpaAward(final Map<String, Object?> map) {
    return _firstString(map, const ['nombre_balneario', 'nombreBalneario', 'NombreBalneario', 'balneario', 'Balneario', 'denominacion_balneario', 'nombre']) != null;
  }

  bool _looksLikeDependencyCareStatus(final Map<String, Object?> map) {
    return _firstString(map, const ['fecha_solicitud', 'fechaSolicitud', 'FechasEntrada', 'FechaSolicitud', 'grado_reconocido', 'gradoReconocido', 'GradoReconocido', 'baremo', 'Baremo']) != null;
  }

  bool _looksLikeParkingCard(final Map<String, Object?> map) {
    return _firstString(map, const ['codigo_tarjeta', 'codigoTarjeta', 'CodigoTarjeta', 'IDTarjeta', 'cod_tarjeta', 'numero_tarjeta', 'numeroTarjeta', 'NumeroTarjeta', 'modalidad', 'Modalidad']) != null;
  }

  List<DependencyCareBenefit> _parseDependencyBenefits(final List<Map<String, Object?>> maps) {
    final benefits = <DependencyCareBenefit>[];
    for (final map in maps) {
      final name = _firstString(map, const ['prestacion', 'Prestacion', 'nombre_prestacion', 'nombrePrestacion', 'NombrePrestacion', 'descripcion_prestacion', 'descripcionPrestacion', 'DescripcionPrestacion']);
      final category = _firstString(map, const ['tipo_prestacion', 'tipoPrestacion', 'TipoPrestacion', 'servicio', 'Servicio', 'categoria', 'Categoria', 'codigo_servicio', 'codigoServicio', 'CodigoServicio']);
      final resolutionDate = _parseDate(_firstString(map, const ['fecha_resolucion_prestacion', 'fechaResolucionPrestacion', 'FechaResolucionPrestacion', 'fecha_resolucion', 'fechaResolucion', 'FechaResolucion']));
      final effectiveDate = _parseDate(_firstString(map, const ['fecha_efecto', 'fechaEfecto', 'FechaEfecto', 'fecha_efectos', 'fechaEfectos', 'FechaEfectos']));
      final amount = _firstString(map, const ['importe', 'Importe', 'importe_euros', 'importeEuros', 'ImporteEuros', 'cuantia', 'Cuantia', 'cantidad', 'Cantidad']);

      if (name == null && category == null && amount == null) {
        continue;
      }

      benefits.add(
        DependencyCareBenefit(
          category: category ?? '',
          name: name ?? '',
          resolutionDate: resolutionDate,
          effectiveDate: effectiveDate,
          amount: amount ?? '',
        ),
      );
    }
    return benefits;
  }

  List<LargeFamilyBeneficiary> _parseBeneficiaries(final List<Map<String, Object?>> maps) {
    final beneficiaries = <LargeFamilyBeneficiary>[];
    for (final map in maps) {
      final document = _firstString(map, const ['documentacion', 'documento', 'numeroDocumento', 'numdoc', 'dni']);
      final name = _fullName(map);
      final birthDate = _parseDate(_firstString(map, const ['fecha_nacimiento', 'fechaNacimiento', 'fecnac']));
      final holder = _parseBool(_firstString(map, const ['titular', 'esTitular']));

      if (document == null && name == null && birthDate == null && holder == null) {
        continue;
      }

      beneficiaries.add(
        LargeFamilyBeneficiary(
          documentNumber: document ?? '',
          birthDate: birthDate,
          fullName: name ?? '',
          isHolder: holder ?? false,
        ),
      );
    }
    return beneficiaries;
  }

  String? _fullName(final Map<String, Object?> map) {
    final explicit = _firstString(map, const ['nombreCompleto', 'nombre_completo', 'fullName']);
    if (explicit != null) {
      return explicit;
    }
    final parts = [
      _firstString(map, const ['nombre']),
      _firstString(map, const ['apellido1', 'primerApellido']),
      _firstString(map, const ['apellido2', 'segundoApellido']),
    ].nonNulls.map((final value) => value.trim()).where((final value) => value.isNotEmpty).toList(growable: false);
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' ');
  }

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

  List<Map<String, Object?>> _collectMaps(final Object? value) {
    final maps = <Map<String, Object?>>[];

    void visit(final Object? node) {
      switch (node) {
        case final Map<String, dynamic> map:
          maps.add(map);
          map.values.forEach(visit);
          final datos = map['datos'];
          if (datos is String) {
            visit(_decodePayload(datos));
          }
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

  int? _firstInt(final Map<String, Object?> map, final List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is int) {
        return value;
      }
      final parsed = int.tryParse(value?.toString().trim() ?? '');
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }

  bool? _parseBool(final String? value) {
    if (value == null) {
      return null;
    }
    return switch (value.trim().toLowerCase()) {
      's' || 'si' || 'sí' || 'true' || '1' || 'vigente' => true,
      'n' || 'no' || 'false' || '0' => false,
      _ => null,
    };
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
    final textMonthMatch = RegExp(r'^(\d{1,2})-([A-Za-z]{3})-(\d{2}|\d{4})$', caseSensitive: false).firstMatch(trimmed);
    if (textMonthMatch != null) {
      final day = int.tryParse(textMonthMatch.group(1)!);
      final month = const {
        'JAN': 1,
        'FEB': 2,
        'MAR': 3,
        'APR': 4,
        'MAY': 5,
        'JUN': 6,
        'JUL': 7,
        'AUG': 8,
        'SEP': 9,
        'OCT': 10,
        'NOV': 11,
        'DEC': 12,
      }[textMonthMatch.group(2)!.toUpperCase()];
      final parsedYear = int.tryParse(textMonthMatch.group(3)!);
      if (day != null && month != null && parsedYear != null) {
        final year = parsedYear < 100 ? 2000 + parsedYear : parsedYear;
        return DateTime(year, month, day);
      }
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
    return DateTime(year, month, day);
  }

  String _regionName(final String? raw) {
    if (raw == null) {
      return 'Castilla-La Mancha';
    }
    return switch (raw.trim().toUpperCase()) {
      '8' || '08' || '13' || 'CLM' || 'CASTILLA-LA MANCHA' => 'Castilla-La Mancha',
      _ => raw,
    };
  }

  String _normalizeCategory(final String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return '';
    }
    final lower = raw.trim().toLowerCase();
    return lower.substring(0, 1).toUpperCase() + lower.substring(1);
  }

  String _normalizeRoyalDecree(final String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return '';
    }
    return switch (raw.trim()) {
      '1' => 'Real Decreto 1971/1999, de 23 de diciembre, de procedimiento para el reconocimiento, declaración y calificación del grado de minusvalía.',
      _ => raw.trim(),
    };
  }

  String _normalizeDependencyDegree(final String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return '';
    }
    final trimmed = raw.trim();
    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'Grado $trimmed';
    }
    return trimmed;
  }

}
