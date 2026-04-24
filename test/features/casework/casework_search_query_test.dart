import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_query.dart';

void main() {
  group('CaseworkSearchQuery.validate', () {
    test('reports noInputProvided when every field is empty', () {
      const q = CaseworkSearchQuery.empty;
      final v = q.validate();
      expect(v.isValid, isFalse);
      expect(v.generalError, CaseworkSearchValidationError.noInputProvided);
      expect(v.errors, isEmpty);
    });

    test('also rejects whitespace-only inputs', () {
      const q = CaseworkSearchQuery(
        identification: '   ',
        expedienteNumber: '\t',
        registroNumber: '  ',
      );
      expect(q.validate().generalError,
          CaseworkSearchValidationError.noInputProvided);
    });

    test('accepts a valid NIF', () {
      const q = CaseworkSearchQuery(identification: '12345678Z');
      expect(q.validate().isValid, isTrue);
      expect(q.firstFilledField, CaseworkSearchField.identification);
    });

    test('accepts a valid NIE', () {
      const q = CaseworkSearchQuery(identification: 'X1234567A');
      expect(q.validate().isValid, isTrue);
    });

    test('accepts a valid pasaporte', () {
      const q = CaseworkSearchQuery(identification: 'AB12345');
      expect(q.validate().isValid, isTrue);
    });

    test('rejects a malformed identification', () {
      const q = CaseworkSearchQuery(identification: '1234');
      final v = q.validate();
      expect(v.isValid, isFalse);
      expect(v.errors[CaseworkSearchField.identification],
          CaseworkSearchValidationError.invalidIdentification);
    });

    test('accepts an expediente number with letters/digits/dashes/slashes',
        () {
      const q = CaseworkSearchQuery(expedienteNumber: 'EXP/2025/00123');
      expect(q.validate().isValid, isTrue);
      expect(q.firstFilledField, CaseworkSearchField.expedienteNumber);
    });

    test('rejects an expediente number with forbidden characters', () {
      const q = CaseworkSearchQuery(expedienteNumber: 'EXP 2025#1');
      final v = q.validate();
      expect(v.isValid, isFalse);
      expect(v.errors[CaseworkSearchField.expedienteNumber],
          CaseworkSearchValidationError.invalidNumberFormat);
    });

    test('accepts a registro number with the same alphabet', () {
      const q = CaseworkSearchQuery(registroNumber: 'REG/E/45612');
      expect(q.validate().isValid, isTrue);
      expect(q.firstFilledField, CaseworkSearchField.registroNumber);
    });

    test(
        'identification takes precedence over the other fields when several '
        'are filled', () {
      const q = CaseworkSearchQuery(
        identification: '12345678Z',
        expedienteNumber: 'EXP/2025/00123',
      );
      expect(q.firstFilledField, CaseworkSearchField.identification);
      expect(q.effectiveField, CaseworkSearchField.identification);
    });

    test('effectiveField is null while validation fails', () {
      const q = CaseworkSearchQuery(identification: '1234');
      expect(q.effectiveField, isNull);
    });
  });
}
