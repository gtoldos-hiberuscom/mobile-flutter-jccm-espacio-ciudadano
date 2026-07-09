import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_education_repository.dart';

final class MyDataEducationRepositoryImpl implements MyDataEducationRepository {
  MyDataEducationRepositoryImpl({required final Dio dio}) : _api = EducacionApi(withGeneratedApiCompat(dio), standardSerializers);

  final EducacionApi _api;

  @override
  Future<List<UniversityTitle>> loadUniversityTitles({
    required final String documentNumber,
  }) async {
    final payload = await _loadRawUniversityTitles(documentNumber);
    if (payload == null) {
      return const [];
    }

    final body = _asStringMap(_asStringMap(_decodePayload(payload))?['body']);
    final elementos = _asList(body?['elemento']);

    final titles = <UniversityTitle>[];
    for (final raw in elementos) {
      final element = _asStringMap(raw);
      if (element == null) {
        continue;
      }

      final title = _extractUniversityTitle(element);
      if (title != null) {
        titles.add(title);
      }
    }

    return titles;
  }

  @override
  Future<List<NonUniversityTitle>> loadNonUniversityTitles({
    required final String documentNumber,
  }) async {
    final payload = await _loadRawNonUniversityTitles(documentNumber);
    if (payload == null) {
      return const [];
    }

    final body = _asStringMap(_asStringMap(_decodePayload(payload))?['body']);
    final elementos = _asList(body?['elemento']);

    final titles = <NonUniversityTitle>[];
    for (final raw in elementos) {
      final element = _asStringMap(raw);
      if (element == null) {
        continue;
      }

      final title = _extractNonUniversityTitle(element);
      if (title != null) {
        titles.add(title);
      }
    }

    return titles;
  }

  Future<Object?> _loadRawUniversityTitles(final String documentNumber) {
    final data = _requestData(documentNumber);
    return _rawResponse(
      () => _api.getTitulosUniversitarios(
        numDocumento: documentNumber,
        dtedutuoreqBody: DTEDUTUOREQ(
          (final builder) => builder
            ..docu = documentNumber
            ..tipodoc = 'NIF',
        ),
        extra: _generatedExtra(data),
        validateStatus: (final status) => status != null && status < 500,
      ),
    );
  }

  Future<Object?> _loadRawNonUniversityTitles(final String documentNumber) {
    final data = _requestData(documentNumber);
    return _rawResponse(
      () => _api.getTitulosNoUniversitarios(
        numDocumento: documentNumber,
        dtedutnureqBody: DTEDUTNUREQ(
          (final builder) => builder
            ..docu = documentNumber
            ..tipodoc = 'NIF',
        ),
        extra: _generatedExtra(data),
        validateStatus: (final status) => status != null && status < 500,
      ),
    );
  }

  Map<String, Object?> _requestData(final String documentNumber) => {
    'docu': documentNumber,
    'tipodoc': 'NIF',
  };

  Map<String, dynamic> _generatedExtra(final Map<String, Object?> data) => {
    generatedApiRequestDataExtraKey: data,
    generatedApiDecodeStringResponseExtraKey: true,
  };

  Future<Object?> _rawResponse(final Future<Response<Respuesta>> Function() fetch) async {
    try {
      final response = await fetch();
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

  UniversityTitle? _extractUniversityTitle(final Map<String, Object?> raw) {
    // nomcar = nombre de la carrera (ej: "Licenciado en Filología Hispánica")
    final titleName = _firstString(raw, const ['nomcar', 'titulacion', 'tipotit']);

    // univers = universidad (ej: "Universidad de Barcelona")
    final universityName = _firstString(raw, const ['univers', 'universidad', 'centro']);

    if (titleName == null || universityName == null) {
      return null;
    }

    // numtit = número de título (ej: "1988000333")
    final titleNumber =
        _firstString(raw, const [
          'numtit',
          'nordlib',
          'numlib',
          'reguniv',
          'nregnac',
          'nregmec',
          'nregaut',
        ]) ??
        '';

    // fecfin = fecha finalización (ej: "01/06/2000")
    final completionDate = _parseDate(_firstString(raw, const ['fecfin']));

    // fecexpedicion = fecha expedición (ej: "08/05/2008")
    final expeditionDate = _parseDate(_firstString(raw, const ['fecexpedicion', 'fecexp']));

    return UniversityTitle(
      titleNumber: titleNumber,
      titleName: titleName,
      universityName: universityName,
      completionDate: completionDate,
      expeditionDate: expeditionDate,
    );
  }

  NonUniversityTitle? _extractNonUniversityTitle(final Map<String, Object?> raw) {
    // titulacion = nombre del título (ej: "Nivel básico del idioma alemán...")
    final titleName = _firstString(raw, const ['titulacion', 'tipotit']);

    // centro = centro educativo (ej: "Escuela Oficial de idiomas de Ciudad Real")
    final centerName = _firstString(raw, const ['centro']);

    if (titleName == null || centerName == null) {
      return null;
    }

    // numlib = número de libro (ej: "23")
    final book = _firstString(raw, const ['numlib']);

    // nordlib = número de orden (ej: "23")
    final order = _firstString(raw, const ['nordlib']);

    // numfol = número de folio (ej: "106")
    final folio = _firstString(raw, const ['numfol']);

    // provtit = provincia (ej: "Ciudad Real")
    final province = _firstString(raw, const ['provtit', 'provincia']);

    // fecfin = fecha finalización (ej: "01/06/2000")
    final completionDate = _parseDate(_firstString(raw, const ['fecfin']));

    // fecexp = fecha expedición (ej: "08/11/2001")
    final expeditionDate = _parseDate(_firstString(raw, const ['fecexp', 'fecexpedicion']));

    return NonUniversityTitle(
      titleName: titleName,
      centerName: centerName,
      book: book,
      order: order,
      folio: folio,
      province: province,
      completionDate: completionDate,
      expeditionDate: expeditionDate,
    );
  }

  DateTime? _parseDate(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();

    // Try ISO format first
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return iso;
    }

    // Try dd/MM/yyyy or dd-MM-yyyy format
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
