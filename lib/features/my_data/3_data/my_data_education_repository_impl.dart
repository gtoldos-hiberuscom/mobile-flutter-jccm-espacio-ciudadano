import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_education_repository.dart';

final class MyDataEducationRepositoryImpl implements MyDataEducationRepository {
  const MyDataEducationRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<UniversityTitle>> loadUniversityTitles({
    required final String documentNumber,
  }) async {
    final Response<String> response;
    try {
      response = await _dio.post<String>(
        '/api/v1/educacion/titulos-universitarios/${Uri.encodeComponent(documentNumber)}',
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
    final Response<String> response;
    try {
      response = await _dio.post<String>(
        '/api/v1/educacion/titulos-no-universitarios/${Uri.encodeComponent(documentNumber)}',
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

  dynamic _decodePayload(final String payload) {
    try {
      return jsonDecode(payload);
    } on Exception {
      return null;
    }
  }
}
