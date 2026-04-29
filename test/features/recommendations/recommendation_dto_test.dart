import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendation_dto.dart';

void main() {
  group('RecommendationDto.fromJson', () {
    test('returns null for non-map input', () {
      expect(RecommendationDto.fromJson(null), isNull);
      expect(RecommendationDto.fromJson('not a map'), isNull);
      expect(RecommendationDto.fromJson(42), isNull);
      expect(RecommendationDto.fromJson(<int>[1, 2, 3]), isNull);
    });

    test('returns null when both id and title are missing', () {
      expect(
        RecommendationDto.fromJson(<String, Object?>{'foo': 'bar'}),
        isNull,
      );
    });

    test('parses canonical English keys', () {
      final dto = RecommendationDto.fromJson(<String, Object?>{
        'id': 'r-1',
        'title': 'Some title',
        'summary': 'A summary',
        'lifeEventId': 'le-edu',
        'lifeEventLabel': 'Educación',
        'responsibleUnit': 'SESCAM',
        'deadlineLabel': '30 días',
        'publishedAt': '2026-04-01T10:00:00Z',
        'isImmediateProcessing': true,
        'detailUri': 'https://example.com/r-1',
      });
      expect(dto, isNotNull);
      final entity = dto!.toEntity();
      expect(entity.id, 'r-1');
      expect(entity.title, 'Some title');
      expect(entity.summary, 'A summary');
      expect(entity.lifeEventId, 'le-edu');
      expect(entity.lifeEventLabel, 'Educación');
      expect(entity.responsibleUnit, 'SESCAM');
      expect(entity.deadlineLabel, '30 días');
      expect(entity.publishedAt, isNotNull);
      expect(entity.isImmediateProcessing, isTrue);
      expect(entity.detailUri, Uri.parse('https://example.com/r-1'));
    });

    test('falls back to backend (Spanish) keys when English keys missing', () {
      final dto = RecommendationDto.fromJson(<String, Object?>{
        'idTramite': 42,
        'nombreTramite': 'Backend title',
        'descripcion': 'desc',
        'idHecho': 7,
        'nombreHecho': 'Familia',
        'nombreUnidadResponsable': 'Bienestar Social',
        'plazo': '15 días',
        'fechaPublicacion': '2026-03-15',
        'inmediato': 'si',
        'urlDetalle': 'https://example.com/x',
      });
      expect(dto, isNotNull);
      final entity = dto!.toEntity();
      expect(entity.id, '42');
      expect(entity.title, 'Backend title');
      expect(entity.summary, 'desc');
      expect(entity.lifeEventId, '7');
      expect(entity.lifeEventLabel, 'Familia');
      expect(entity.responsibleUnit, 'Bienestar Social');
      expect(entity.isImmediateProcessing, isTrue);
      expect(entity.publishedAt?.year, 2026);
    });

    test('tolerates missing optional fields without throwing', () {
      final dto = RecommendationDto.fromJson(<String, Object?>{
        'id': 'r-x',
        'title': 'Minimal',
      });
      expect(dto, isNotNull);
      final entity = dto!.toEntity();
      expect(entity.summary, isNull);
      expect(entity.lifeEventId, isNull);
      expect(entity.responsibleUnit, isNull);
      expect(entity.deadlineLabel, isNull);
      expect(entity.publishedAt, isNull);
      expect(entity.isImmediateProcessing, isFalse);
      expect(entity.detailUri, isNull);
    });

    test('tolerates wrong types: collapses to null instead of throwing', () {
      final dto = RecommendationDto.fromJson(<String, Object?>{
        'id': 'r-y',
        'title': 'Wrong types',
        'summary': <int>[1, 2],
        'isImmediateProcessing': 'maybe',
        'publishedAt': 'not-a-date',
        'detailUri': 12345,
      });
      expect(dto, isNotNull);
      final entity = dto!.toEntity();
      expect(entity.summary, isNull);
      expect(entity.publishedAt, isNull);
      // Falls back to default `false` because "maybe" is unparseable.
      expect(entity.isImmediateProcessing, isFalse);
      // Numeric → string → tryParse('12345') yields a relative URI; that's
      // acceptable, the contract only forbids throwing.
      expect(entity.detailUri, isNotNull);
    });

    test('coerces numeric / boolean primitives to string', () {
      final dto = RecommendationDto.fromJson(<String, Object?>{
        'id': 99,
        'title': true, // unusual, but the parser must not throw
      });
      expect(dto, isNotNull);
      expect(dto!.id, '99');
      expect(dto.title, 'true');
    });
  });

  group('parseRecommendations', () {
    test('null → empty list', () {
      expect(parseRecommendations(null), isEmpty);
    });

    test('list of maps → parsed entries, dropping invalid ones', () {
      final result = parseRecommendations(<Object?>[
        <String, Object?>{'id': 'a', 'title': 'A'},
        'garbage',
        <String, Object?>{'no': 'id'},
        <String, Object?>{'id': 'b', 'title': 'B'},
      ]);
      expect(result.map((final r) => r.id), <String>['a', 'b']);
    });

    test('single map → single-element list', () {
      final result = parseRecommendations(<String, Object?>{
        'id': 'solo',
        'title': 'Solo',
      });
      expect(result, hasLength(1));
      expect(result.single.id, 'solo');
    });

    test('envelope with `data` key → unwraps and parses', () {
      final result = parseRecommendations(<String, Object?>{
        'data': <Object?>[
          <String, Object?>{'id': 'x', 'title': 'X'},
        ],
      });
      expect(result, hasLength(1));
      expect(result.single.id, 'x');
    });

    test('garbage input → empty list, never throws', () {
      expect(parseRecommendations(42), isEmpty);
      expect(parseRecommendations('foo'), isEmpty);
      expect(parseRecommendations(true), isEmpty);
    });
  });
}
