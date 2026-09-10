import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';

void main() {
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
