import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';

void main() {
  group('JwtDecoder.decodePayload', () {
    test('keeps claims not modeled by JwtClaims', () {
      final payload = base64Url.encode(
        utf8.encode('{"sub":"citizen","representative_claim":"company"}'),
      );

      expect(
        JwtDecoder.decodePayload('header.$payload.signature'),
        {'sub': 'citizen', 'representative_claim': 'company'},
      );
    });

    test('returns an empty map for a malformed token', () {
      expect(JwtDecoder.decodePayload('not-a-jwt'), isEmpty);
    });
  });

  group('JwtClaims.normalizedPersonIdentifier', () {
    test('normalizes the document identifier for ciudadanos endpoints', () {
      final claims = _claims(personIdentifier: '  99999999r ');

      expect(claims.normalizedPersonIdentifier, '99999999R');
    });

    test('returns null when the document identifier is unavailable', () {
      final claims = _claims();

      expect(claims.normalizedPersonIdentifier, isNull);
    });

    test('extracts the document from an eIDAS person identifier', () {
      final claims = _claims(personIdentifier: 'ES/ES/99999999r');

      expect(claims.normalizedPersonIdentifier, '99999999R');
    });

    test('extracts the document from a namespaced person identifier', () {
      final claims = _claims(personIdentifier: 'urn:oid:person:99999999r');

      expect(claims.normalizedPersonIdentifier, '99999999R');
    });
  });

  group('JwtClaims.identificationDocumentType', () {
    test('recognizes a DNI', () {
      expect(
        _claims(personIdentifier: '12345678Z').identificationDocumentType,
        IdentificationDocumentType.dni,
      );
    });

    test('recognizes a NIE', () {
      expect(
        _claims(personIdentifier: 'X1234567L').identificationDocumentType,
        IdentificationDocumentType.nie,
      );
    });

    test('recognizes a legal entity NIF', () {
      expect(
        _claims(personIdentifier: 'A12345678').identificationDocumentType,
        IdentificationDocumentType.legalEntityNif,
      );
    });

    test('uses other for an unknown identifier format', () {
      expect(
        _claims(personIdentifier: 'FOREIGN-123').identificationDocumentType,
        IdentificationDocumentType.other,
      );
    });
  });

  group('JwtClaims.fullName', () {
    test('joins given name and both surnames', () {
      expect(
        JwtClaims.fromMap(const {'given_name': ' Juan ', 'first_surname': 'García', 'second_surname': 'López'}).fullName,
        'Juan García López',
      );
    });

    test('skips missing surname parts', () {
      expect(JwtClaims.fromMap(const {'given_name': 'Juan', 'first_surname': 'García'}).fullName, 'Juan García');
    });

    test('falls back to the name claim', () {
      expect(JwtClaims.fromMap(const {'name': 'Juan García López'}).fullName, 'Juan García López');
    });

    test('returns null when the token carries no name', () {
      expect(JwtClaims.fromMap(const {}).fullName, isNull);
    });
  });

  group('JwtClaims representation', () {
    test('uses the represented agent as the effective request-body identity', () {
      final claims = JwtClaims.fromMap(const {
        'idAgente': 'PER4856936',
        'idagente_representado': 'PJU0349051',
        'nombreRepresentado': 'ENTIDAD DE PRUEBAS 01',
        'nifRepresentado': 'Q0000000J',
        'clasificacionCertificado': '11',
      });

      expect(claims.isRepresentative, isTrue);
      expect(claims.effectiveAgentId, 'PJU0349051');
      expect(claims.effectivePersonIdentifier, 'Q0000000J');
      expect(claims.effectiveDisplayName, 'ENTIDAD DE PRUEBAS 01');
      expect(claims.representedName, 'ENTIDAD DE PRUEBAS 01');
      expect(claims.representedNif, 'Q0000000J');
      expect(claims.certificateClassification, '11');
    });

    test('uses the authenticated agent for a normal certificate', () {
      final claims = JwtClaims.fromMap(const {
        'idAgente': 'PER9998003',
        'PersonIdentifier': '99999999R',
      });

      expect(claims.isRepresentative, isFalse);
      expect(claims.effectiveAgentId, 'PER9998003');
      expect(claims.effectivePersonIdentifier, '99999999R');
      expect(claims.effectiveDisplayName, isNull);
    });

    test('does not treat the Cl@ve representative scope as an active representation', () {
      final claims = JwtClaims.fromMap(const {
        'scope': 'openid profile clave_representado offline_access',
      });

      expect(claims.isRepresentative, isFalse);
    });
  });

  group('JwtClaims authentication level', () {
    // Los dos ejemplos del documento funcional de citas hospitalarias, con los
    // identificadores sustituidos: lo que importa es la forma del token y la
    // pareja authNLevel/idpSelected.
    test('reads the level and the identity provider from a Cl@ve PIN token', () {
      final claims = JwtClaims.fromMap(const {
        'authNLevel': 'low',
        'idpSelected': 'SEGSOC',
      });

      expect(claims.authNLevelRaw, 'low');
      expect(claims.idpSelected, 'SEGSOC');
    });

    test('reads the level from a certificate token', () {
      final claims = JwtClaims.fromMap(const {
        'authNLevel': 'substantial',
        'idpSelected': 'AFIRMA',
      });

      expect(claims.authNLevelRaw, 'substantial');
      expect(claims.idpSelected, 'AFIRMA');
    });

    test('leaves the level null when the token does not carry the claim', () {
      final claims = JwtClaims.fromMap(const {'sub': 'citizen'});

      expect(claims.authNLevelRaw, isNull);
      expect(claims.idpSelected, isNull);
    });
  });

  group('JwtClaims.identifiesSamePersonAs', () {
    // El caso que hace que comparar `sub` no valga: elevar el nivel cambia de
    // proveedor de identidad, y con él el sujeto, sin cambiar de ciudadano.
    test('matches the same document across different subjects', () {
      final before = JwtClaims.fromMap(const {'sub': 'seg-social-subject', 'PersonIdentifier': '99999999R'});
      final after = JwtClaims.fromMap(const {'sub': 'afirma-subject', 'PersonIdentifier': '99999999r'});

      expect(before.identifiesSamePersonAs(after), isTrue);
    });

    test('rejects a different document', () {
      final before = JwtClaims.fromMap(const {'PersonIdentifier': '99999999R'});
      final after = JwtClaims.fromMap(const {'PersonIdentifier': '00000000T'});

      expect(before.identifiesSamePersonAs(after), isFalse);
    });

    test('falls back to sub_alt when there is no document', () {
      final before = JwtClaims.fromMap(const {'sub_alt': 'PER9999927'});
      final after = JwtClaims.fromMap(const {'sub_alt': 'PER9999927'});

      expect(before.identifiesSamePersonAs(after), isTrue);
    });

    test('refuses to claim a match when either side has no identifier', () {
      final identified = JwtClaims.fromMap(const {'PersonIdentifier': '99999999R'});
      final anonymous = JwtClaims.fromMap(const {'sub': 'citizen'});

      expect(identified.identifiesSamePersonAs(anonymous), isFalse);
      expect(anonymous.identifiesSamePersonAs(identified), isFalse);
      expect(anonymous.identifiesSamePersonAs(anonymous), isFalse);
    });

    test('treats entering or leaving a representation as a different identity', () {
      final own = JwtClaims.fromMap(const {'PersonIdentifier': 'Q0000000J'});
      final representing = JwtClaims.fromMap(const {
        'PersonIdentifier': '99999999R',
        'idagente_representado': 'PJU0349051',
        'nifRepresentado': 'Q0000000J',
      });

      expect(own.identifiesSamePersonAs(representing), isFalse);
    });
  });
}

JwtClaims _claims({final String? personIdentifier}) {
  return JwtClaims(
    exp: 0,
    iat: 0,
    iss: '',
    aud: const [],
    sub: '',
    personIdentifier: personIdentifier,
  );
}
