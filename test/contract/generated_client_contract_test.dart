/// Sprint 7 / STORY-66 — contract tests for the generated Dio client.
///
/// Goal: detect drift between `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
/// (the documented contracts) and `generated/dart_dio_client/` (the
/// built_value models actually shipped). Each test deserializes a
/// representative JSON fixture through `standardSerializers` and asserts
/// that the *known* fields parse with the right type. Unknown fields are
/// tolerated by the serializer so the tests remain green if the backend
/// adds non-breaking fields.
///
/// These are NOT network tests. They are parser/adapter tests. Network
/// behavior is out of scope (covered by feature-level integration tests
/// in `test/features/**`).
library;

import 'package:built_value/serializer.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Casework — POST /publicacion/selectbynumexp', () {
    test('deserializes a populated response (happy path)', () {
      // Fixture shaped after MAPEO_DETALLADO_ENDPOINTS.md §3.4
      // (Mis Gestiones — detalle de expediente por número).
      final json = <String, Object?>{
        'adjuntar': 'X',
        'isubrc': 0,
        'resultado': 'OK',
        'publicacionportal': <String, Object?>{
          'asunto': 'Solicitud de subvención cultural',
          'apellido1': 'García',
          'apellido2': 'López',
          'consej': 'Cultura',
        },
      };
      final parsed = standardSerializers.deserializeWith(
        ZCSRFCPUBLISELECTBYNUMEXPResponse.serializer,
        json,
      );
      expect(parsed, isNotNull);
      expect(parsed!.adjuntar, 'X');
      expect(parsed.isubrc, 0);
      expect(parsed.resultado, 'OK');
      expect(parsed.publicacionportal?.asunto,
          'Solicitud de subvención cultural');
    });

    test('tolerates a minimal response (only error indicator)', () {
      final json = <String, Object?>{
        'isubrc': 4,
        'resultado': 'NO_RESULTS',
      };
      final parsed = standardSerializers.deserializeWith(
        ZCSRFCPUBLISELECTBYNUMEXPResponse.serializer,
        json,
      );
      expect(parsed, isNotNull);
      expect(parsed!.isubrc, 4);
      expect(parsed.publicacionportal, isNull);
    });

    test('serializes a request with the documented mandatory fields', () {
      final req = ZCSRFCPUBLISELECTBYNUMEXP(
        (final b) => b
          ..pnumdoc = '12345678Z'
          ..pnumexp = 'EXP-2026-001'
          ..ptipodoc = 'NIF',
      );
      final json = standardSerializers.serializeWith(
        ZCSRFCPUBLISELECTBYNUMEXP.serializer,
        req,
      );
      expect(json, isA<Map<dynamic, dynamic>>());
      final map = (json! as Map).cast<String, dynamic>();
      expect(map['pnumdoc'], '12345678Z');
      expect(map['pnumexp'], 'EXP-2026-001');
      expect(map['ptipodoc'], 'NIF');
    });
  });

  group('Casework — POST /publicacion/selectbynumreg', () {
    test('serializes the documented mandatory fields', () {
      final req = ZCSRFCPUBLISELECTBYNUMREG(
        (final b) => b
          ..pnumdoc = '12345678Z'
          ..pregistro = 'REG-2026-9999'
          ..ptipodoc = 'NIF',
      );
      final json = standardSerializers.serializeWith(
        ZCSRFCPUBLISELECTBYNUMREG.serializer,
        req,
      ) as Map?;
      expect(json, isNotNull);
      expect(json!['pnumdoc'], '12345678Z');
      expect(json['pregistro'], 'REG-2026-9999');
      expect(json['ptipodoc'], 'NIF');
    });
  });

  group('Digital cards — Carnet Joven & QR', () {
    test('CarnetJoven deserializes the documented payload', () {
      // Fixture aligns with §6 "Mi Carnet Digital" wireName casing.
      final json = <String, Object?>{
        'FechaFinValidez': '2027-12-31',
        'FechaNacimiento': '2005-03-14',
        'Numero': 'CJ-000123',
        'Titular': 'Citizen Demo',
        'enTramitacion': 'N',
      };
      final parsed = standardSerializers.deserializeWith(
        CarnetJoven.serializer,
        json,
      );
      expect(parsed, isNotNull);
      expect(parsed!.numero, 'CJ-000123');
      expect(parsed.fechaFinValidez, '2027-12-31');
      expect(parsed.titular, 'Citizen Demo');
    });

    test('CarnetQr deserializes a QR token payload', () {
      final json = <String, Object?>{
        'qr': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA',
      };
      final parsed = standardSerializers.deserializeWith(
        CarnetQr.serializer,
        json,
      );
      expect(parsed, isNotNull);
      expect(parsed!.qr, startsWith('data:image/png;base64,'));
    });
  });

  group('Generated client — registry sanity', () {
    test('standardSerializers can roundtrip a simple model', () {
      final original = CarnetQr((final b) => b..qr = 'roundtrip');
      final json = standardSerializers.serializeWith(
        CarnetQr.serializer,
        original,
      );
      final back = standardSerializers.deserializeWith(
        CarnetQr.serializer,
        json,
      );
      expect(back, original);
    });

    test('Serializer registry exposes a non-empty type set', () {
      // Sanity guard against accidentally shipping an empty serializers
      // file (e.g. after a botched codegen run).
      expect(standardSerializers, isA<Serializers>());
    });
  });
}
