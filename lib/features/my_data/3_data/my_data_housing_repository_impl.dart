import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/housing_address.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_housing_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/api/vivienda_api.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/document_type.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

final class MyDataHousingRepositoryImpl implements MyDataHousingRepository {
  MyDataHousingRepositoryImpl({required final Dio dio}) : _api = ViviendaApi(dio);

  final ViviendaApi _api;

  @override
  Future<HousingAddress?> loadAddress({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final payload = await _rawResponse(
      () => _api.datosResidencia(
        citizenId: citizenId,
        // `DTINECDRFREQ` usa `tipodoc`, con la `o`.
        body: {
          'tipodoc': documentTypeOf(documentNumber),
          'docu': documentNumber,
        },
      ),
    );
    if (payload == null) {
      return null;
    }

    final decoded = _decodePayload(payload);
    final root = _asStringMap(decoded);
    final body = _asStringMap(root?['body']);
    final data = body ?? root ?? _collectMaps(decoded).firstOrNull;
    if (data == null) {
      return null;
    }

    final address = HousingAddress(
      address: _firstString(data, const ['domicilio', 'direccion', 'address']) ?? _composeAddress(data),
      postalCode: _firstString(data, const ['codpos', 'codigoPostal', 'codigo_postal', 'cp', 'postalCode']),
      municipality: _firstString(data, const ['denmun', 'municipio', 'poblacion']),
      province: _firstString(data, const ['denpro', 'provincia']),
      collectiveEntity: _firstString(data, const ['denencol', 'entidadColectiva', 'entidad_colectiva']),
      singleEntity: _firstString(data, const ['denensin', 'entidadSingular', 'entidad_singular']),
      populationUnit: _firstString(data, const ['dennuc', 'nucleo', 'nucleoDiseminado', 'nucleo_diseminado']),
      variationType: _firstString(data, const ['descvar', 'tipoVariacion', 'tipo_variacion']),
      variationDate: _parseDate(_firstString(data, const ['fecvar', 'fechaVariacion', 'fecha_variacion'])),
    );

    return address.hasData ? address : null;
  }

  @override
  Future<List<RealEstateProperty>> loadRealEstateProperties({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    final payload = await _rawResponse(
      () => _api.datosCatastrales(
        citizenId: citizenId,
        // `DTCTROCDATREQ` usa `tipdoc`, **sin** la `o`, a diferencia de los
        // otros DTO de intermediación. No es una errata: es el nombre del campo
        // en el OpenAPI de la fachada. La documentación del gateway lo escribe
        // `tipodoc` y se equivoca.
        body: {
          'tipdoc': documentTypeOf(documentNumber),
          'docu': documentNumber,
        },
      ),
    );

    if (payload == null) {
      return const [];
    }

    final decoded = _decodePayload(payload);
    final root = _asStringMap(decoded);
    final body = root == null ? null : _decodePayload(root['body']);
    final candidates = _propertyCandidateMaps(body ?? root ?? decoded);

    return candidates.map(_parseRealEstateProperty).where((final property) => property.hasData).toList(growable: false);
  }

  /// Tres estados: 404 → `null`, rechazo de autorización → excepción tipada,
  /// resto de errores → se propagan. Ver [intermediacionRawResponse].
  Future<Object?> _rawResponse(final Future<Object?> Function() fetch) => intermediacionRawResponse(fetch);

  String? _composeAddress(final Map<String, Object?> data) {
    final parts = [
      _firstString(data, const ['tipvia', 'tipoVia']),
      _firstString(data, const ['nomvia', 'nombreVia', 'via']),
      _firstString(data, const ['numres', 'numero']),
      _prefix('Bloque', _firstString(data, const ['blores', 'bloque'])),
      _prefix('Esc.', _firstString(data, const ['escres', 'escalera'])),
      _prefix('Planta', _firstString(data, const ['plares', 'planta'])),
      _prefix('Puerta', _firstString(data, const ['pueres', 'puerta'])),
    ].whereType<String>().where((final part) => part.trim().isNotEmpty).toList(growable: false);

    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' ');
  }

  List<Map<String, Object?>> _propertyCandidateMaps(final Object? value) {
    if (value is List<dynamic>) {
      return value.map(_asStringMap).whereType<Map<String, Object?>>().toList(growable: false);
    }

    final root = _asStringMap(value);
    if (root != null) {
      for (final key in const [
        'bienes',
        'bien',
        'inmuebles',
        'inmueble',
        'listaBienesInmuebles',
        'datosInmueble',
        'datosCatastrales',
        'datos_catastrales',
        'lista',
        'items',
        'result',
        'results',
      ]) {
        final nested = root[key] ?? root[key.toLowerCase()];
        final nestedMaps = _propertyCandidateMaps(nested);
        if (nestedMaps.isNotEmpty) {
          return nestedMaps;
        }
      }
    }

    final collectedMaps = _collectMaps(value);
    final wrappedRecords = collectedMaps.where((final map) => _cadastralRecordMap(map) != null).toList(growable: false);
    if (wrappedRecords.isNotEmpty) {
      return wrappedRecords;
    }

    return collectedMaps
        .where(
          (final map) => _firstString(map, const ['refcat', 'referenciaCatastral', 'referencia_catastral', 'refCatastral']) != null || _firstString(map, const ['valorCatastral', 'valor_catastral', 'valcat']) != null || _firstString(map, const ['direccion', 'domicilio', 'localizacion', 'ubicacion', 'ldt']) != null,
        )
        .toList(growable: false);
  }

  RealEstateProperty _parseRealEstateProperty(final Map<String, Object?> data) {
    final cadastralRecord = _cadastralRecordMap(data) ?? data;
    final fiscalData = _nestedMap(cadastralRecord, const ['debi']);
    final cadastreId = _nestedMap(cadastralRecord, const ['idine']);
    final finca = _nestedMap(data, const ['finca']);
    final infograf = _nestedMap(finca, const ['infgraf']);

    return RealEstateProperty(
      cadastralReference:
          _firstString(data, const [
            'refcat',
            'referenciaCatastral',
            'referencia_catastral',
            'refCatastral',
            'referencia',
            'rc',
          ]) ??
          _composeCadastralReference(_nestedMap(cadastreId, const ['rc'])),
      address:
          _firstString(cadastralRecord, const [
            'direccion',
            'domicilio',
            'localizacion',
            'ubicacion',
            'descripcionDireccion',
            'ldt',
          ]) ??
          _composeCadastralAddress(cadastralRecord),
      use: _firstString(fiscalData ?? data, const ['uso', 'luso', 'destino', 'usoPrincipal']),
      cadastralValue: _formatMoney(
        _firstString(fiscalData ?? data, const ['valorCatastral', 'valor_catastral', 'valor', 'valcat', 'vcat']),
      ),
      landValue: _formatMoney(
        _firstString(fiscalData ?? data, const ['valorSuelo', 'valor_suelo', 'valorsuelo', 'valsue', 'vsuelo', 'vcs']),
      ),
      constructionValue: _formatMoney(
        _firstString(fiscalData ?? data, const [
          'valorConstruccion',
          'valor_construccion',
          'valorConstrucción',
          'valcon',
          'vconstruccion',
          'vcc',
        ]),
      ),
      status: _firstString(data, const ['estado', 'situacion', 'situación', 'descripcionEstado', 'descEstado']),
      cartographyUrl: _normalizeUrl(_firstString(infograf ?? data, const ['igraf', 'cartografia', 'cartographyUrl', 'urlCartografia'])),
      holders: _parsePropertyHolders(data),
      kind: _parsePropertyKind(
        _firstString(data, const ['tipo', 'clase', 'naturaleza', 'tipoBien', 'tipoInmueble']) ?? _firstString(cadastreId ?? const <String, Object?>{}, const ['cn']),
      ),
    );
  }

  List<RealEstatePropertyHolder> _parsePropertyHolders(final Map<String, Object?> data) {
    final holdersRoot = _nestedMap(data, const ['listaTitulares']);
    final holdersValue = holdersRoot == null ? _valueForKey(data, 'titulares') : _valueForKey(holdersRoot, 'titular');
    final holderItems = holdersValue is List<dynamic>
        ? holdersValue
        : holdersValue == null
        ? const <Object?>[]
        : [holdersValue];

    return holderItems
        .map(_asStringMap)
        .whereType<Map<String, Object?>>()
        .map((final holder) {
          final person = _nestedMap(holder, const ['idpOut']);
          return RealEstatePropertyHolder(
            name: _firstString(person ?? holder, const ['nom', 'nombre', 'nombreCompleto', 'titular']),
            ownership: _firstString(holder, const ['lder', 'titularidad', 'propiedad', 'porcentaje']),
          );
        })
        .where((final holder) => holder.hasData)
        .toList(growable: false);
  }

  Map<String, Object?>? _cadastralRecordMap(final Map<String, Object?> data) {
    for (final key in const [
      'bienInmuebleRustico',
      'bienInmuebleRústico',
      'bienInmuebleUrbano',
      'bienInmueble',
      'inmueble',
    ]) {
      final nested = _nestedMap(data, [key]);
      if (nested != null) {
        return nested;
      }
    }
    return null;
  }

  String? _composeCadastralReference(final Map<String, Object?>? rc) {
    if (rc == null) {
      return null;
    }
    final parts = [
      _firstString(rc, const ['pc1']),
      _firstString(rc, const ['pc2']),
      _firstString(rc, const ['car']),
      _firstString(rc, const ['cc1']),
      _firstString(rc, const ['cc2']),
    ].whereType<String>().where((final part) => part.trim().isNotEmpty).toList(growable: false);

    if (parts.isEmpty) {
      return null;
    }
    return parts.join();
  }

  String? _composeCadastralAddress(final Map<String, Object?> data) {
    final streetParts = [
      _firstString(data, const ['tipvia', 'tipoVia', 'sigla', 'claseVia']),
      _firstString(data, const ['nomvia', 'nombreVia', 'via', 'calle']),
      _firstString(data, const ['numero', 'num', 'numres']),
    ].whereType<String>().where((final part) => part.trim().isNotEmpty).toList(growable: false);

    final locationParts = [
      _firstString(data, const ['codpos', 'codigoPostal', 'cp']),
      _firstString(data, const ['municipio', 'denmun', 'poblacion']),
      _firstString(data, const ['provincia', 'denpro']),
    ].whereType<String>().where((final part) => part.trim().isNotEmpty).toList(growable: false);

    if (streetParts.isEmpty && locationParts.isEmpty) {
      return null;
    }
    if (locationParts.isEmpty) {
      return streetParts.join(' ');
    }
    if (streetParts.isEmpty) {
      return locationParts.join(' ');
    }
    return '${streetParts.join(' ')} - ${locationParts.join(' ')}';
  }

  String? _formatMoney(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.contains('€')) {
      return trimmed;
    }
    final normalized = trimmed.contains(',') ? trimmed.replaceAll('.', '').replaceAll(',', '.') : trimmed;
    final numeric = num.tryParse(normalized);
    if (numeric == null) {
      return trimmed;
    }
    final fixed = numeric.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (final match) => '.',
    );
    return '$whole,${parts.last}€';
  }

  String? _normalizeUrl(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value.trim().replaceAll('&amp;', '&');
  }

  RealEstatePropertyKind _parsePropertyKind(final String? value) {
    final normalized = value?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return RealEstatePropertyKind.unknown;
    }
    if (normalized.startsWith('u') || normalized.contains('urban')) {
      return RealEstatePropertyKind.urban;
    }
    if (normalized.startsWith('r') || normalized.contains('rustic') || normalized.contains('rústic')) {
      return RealEstatePropertyKind.rustic;
    }
    return RealEstatePropertyKind.unknown;
  }

  String? _prefix(final String label, final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return '$label ${value.trim()}';
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

  Map<String, Object?>? _nestedMap(final Map<String, Object?>? map, final List<String> path) {
    Object? current = map;
    for (final key in path) {
      final currentMap = _asStringMap(current);
      if (currentMap == null) {
        return null;
      }
      current = _valueForKey(currentMap, key);
    }
    return _asStringMap(current);
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
}
