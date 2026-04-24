import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/sescam/sescam_payload_parser.dart';

void main() {
  group('SescamCitasParser', () {
    const parser = SescamCitasParser();

    test('returns empty error for null/blank', () {
      expect(parser.parse(null).error?.kind, SescamParseErrorKind.empty);
      expect(parser.parse('   ').error?.kind, SescamParseErrorKind.empty);
    });

    test('parses a json object envelope with citas', () {
      const raw = '''
      {"estado":"OK","mensaje":"ok","citas":[
        {"id":"c1","fecha":"2026-05-12","hora":"09:30","centro":"Toledo",
         "servicio":"Cardio","profesional":"Dra. R","tipo":"primera",
         "justificante":{"url":"https://x/y.pdf","mime":"application/pdf"}}
      ]}
      ''';
      final res = parser.parse(raw);
      expect(res.isOk, isTrue);
      expect(res.value!.citas, hasLength(1));
      final c = res.value!.citas.first;
      expect(c.id, 'c1');
      expect(c.fecha, DateTime(2026, 5, 12));
      expect(c.justificante?.url, 'https://x/y.pdf');
    });

    test('maps server estado=KO to serverEnvelopeKo error', () {
      final res = parser.parse('{"estado":"KO","mensaje":"down"}');
      expect(res.isOk, isFalse);
      expect(res.error!.kind, SescamParseErrorKind.serverEnvelopeKo);
      expect(res.error!.reason, 'down');
    });

    test('parses a json array of citas', () {
      const raw = '[{"fecha":"2026-05-12","centro":"X"},{"fecha":"2026-05-13"}]';
      final res = parser.parse(raw);
      expect(res.isOk, isTrue);
      expect(res.value!.citas, hasLength(2));
    });

    test('parses line-separated payload', () {
      const raw = '2026-05-12;09:30;Toledo;Cardio;Dra. R\n2026-05-13;10:00;Albacete;Trauma';
      final res = parser.parse(raw);
      expect(res.isOk, isTrue);
      expect(res.value!.citas, hasLength(2));
      expect(res.value!.citas.first.centro, 'Toledo');
    });

    test('returns unknownShape for arbitrary text', () {
      final res = parser.parse('hello world this is not a payload');
      expect(res.isOk, isFalse);
      expect(res.error!.kind, SescamParseErrorKind.unknownShape);
    });

    test('parses dd/MM/yyyy fallback', () {
      const raw = '[{"fecha":"12/05/2026"}]';
      final res = parser.parse(raw);
      expect(res.value!.citas.first.fecha, DateTime(2026, 5, 12));
    });
  });

  group('SescamCipParser', () {
    const parser = SescamCipParser();

    test('parses json envelope', () {
      const raw =
          '{"estado":"OK","cip":"ABCD12345678","titular":"María","centroSalud":"CS Toledo"}';
      final res = parser.parse(raw);
      expect(res.isOk, isTrue);
      expect(res.value!.cip, 'ABCD12345678');
      expect(res.value!.titular, 'María');
    });

    test('parses bare CIP string', () {
      final res = parser.parse('abcd12345678');
      expect(res.isOk, isTrue);
      expect(res.value!.cip, 'ABCD12345678');
    });

    test('returns unknownShape for garbage', () {
      final res = parser.parse('not-a-cip');
      expect(res.isOk, isFalse);
      expect(res.error!.kind, SescamParseErrorKind.unknownShape);
    });

    test('returns serverKo on KO envelope', () {
      final res = parser.parse('{"estado":"KO","mensaje":"upstream"}');
      expect(res.error!.kind, SescamParseErrorKind.serverEnvelopeKo);
    });
  });

  test('feature flag defaults to disabled', () {
    expect(kSescamLiveParsingEnabled, isFalse);
  });
}
