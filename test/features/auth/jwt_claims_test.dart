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
