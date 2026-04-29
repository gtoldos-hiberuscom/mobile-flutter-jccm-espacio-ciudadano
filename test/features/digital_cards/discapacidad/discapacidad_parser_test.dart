import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_parser.dart';

void main() {
  group('DiscapacidadParser.parsePayload', () {
    test('structured map happy path → grado + holder + available', () {
      final card = DiscapacidadParser.parsePayload(<String, dynamic>{
        'grado': 65,
        'holderName': 'Antonio Pérez Soto',
        'vigente': true,
        'expiryDate': '2027-04-21T00:00:00.000',
      });
      expect(card.grado, 65);
      expect(card.holderName, 'Antonio Pérez Soto');
      expect(card.status, DigitalCardStatus.available);
      expect(card.parseFailure, isNull);
      expect(card.expiryDate, DateTime(2027, 4, 21));
    });

    test('bare-string "Grado 65 - Vigente" → grado=65 + available', () {
      final card = DiscapacidadParser.parsePayload('Grado 65 - Vigente');
      expect(card.grado, 65);
      expect(card.gradoLabel, 'Grado 65 - Vigente');
      expect(card.status, DigitalCardStatus.available);
      expect(card.parseFailure, isNull);
    });

    test('bare-string with "caducado" token → grado parsed but status notValid', () {
      final card = DiscapacidadParser.parsePayload('Grado 33 - Caducado');
      expect(card.grado, 33);
      expect(card.status, DigitalCardStatus.notValid);
    });

    test('bare-string with "no vigente" token → status notValid', () {
      final card = DiscapacidadParser.parsePayload('Grado 75 (no vigente)');
      expect(card.grado, 75);
      expect(card.status, DigitalCardStatus.notValid);
    });

    test('nonsense input → notAvailable + payloadUnparseable', () {
      final card = DiscapacidadParser.parsePayload(42);
      expect(card.status, DigitalCardStatus.notAvailable);
      expect(card.grado, isNull);
      expect(card.gradoLabel, isNull);
      expect(card.parseFailure, DiscapacidadParseFailure.payloadUnparseable);
    });

    test('empty string → notAvailable + payloadUnparseable', () {
      final card = DiscapacidadParser.parsePayload('   ');
      expect(card.status, DigitalCardStatus.notAvailable);
      expect(card.parseFailure, DiscapacidadParseFailure.payloadUnparseable);
    });

    test('string without digits → notAvailable + missingGrado', () {
      final card = DiscapacidadParser.parsePayload('Sin información');
      expect(card.status, DigitalCardStatus.notAvailable);
      expect(card.grado, isNull);
      expect(card.parseFailure, DiscapacidadParseFailure.missingGrado);
    });

    test('map with vigente=false overrides positive grado', () {
      final card = DiscapacidadParser.parsePayload(<String, dynamic>{
        'grado': 65,
        'vigente': false,
      });
      expect(card.grado, 65);
      expect(card.status, DigitalCardStatus.notValid);
    });

    test('map without grado but with payloadString falls back to string parser', () {
      final card = DiscapacidadParser.parsePayload(<String, dynamic>{
        'holderName': 'Antonio Pérez Soto',
        'payloadString': 'Grado 65 - Vigente',
      });
      expect(card.holderName, 'Antonio Pérez Soto');
      expect(card.grado, 65);
      expect(card.status, DigitalCardStatus.available);
    });

    test('map with grado outside 1..100 → malformedGrado', () {
      final card = DiscapacidadParser.parsePayload(<String, dynamic>{
        'grado': 150,
      });
      expect(card.grado, isNull);
      expect(card.parseFailure, DiscapacidadParseFailure.malformedGrado);
      expect(card.status, DigitalCardStatus.notAvailable);
    });
  });
}
