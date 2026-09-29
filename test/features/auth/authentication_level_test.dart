import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';

void main() {
  group('AuthenticationLevelReading.parse', () {
    test('reads the canonical eIDAS literals documented by the client', () {
      expect(AuthenticationLevelReading.parse('low'), const KnownAuthenticationLevel(AuthenticationLevel.low, 'low'));
      expect(
        AuthenticationLevelReading.parse('substantial'),
        const KnownAuthenticationLevel(AuthenticationLevel.substantial, 'substantial'),
      );
      expect(AuthenticationLevelReading.parse('high'), const KnownAuthenticationLevel(AuthenticationLevel.high, 'high'));
    });

    test('ignores case and surrounding whitespace', () {
      final reading = AuthenticationLevelReading.parse('  SUBSTANTIAL ');

      expect(reading, isA<KnownAuthenticationLevel>());
      expect((reading as KnownAuthenticationLevel).level, AuthenticationLevel.substantial);
    });

    test('keeps the raw literal exactly as Cerbero wrote it', () {
      final reading = AuthenticationLevelReading.parse(' Substantial ') as KnownAuthenticationLevel;

      expect(reading.raw, 'Substantial');
    });

    test('reads the eIDAS URN form', () {
      expect(
        AuthenticationLevelReading.parse('http://eidas.europa.eu/loa/high'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.high),
      );
    });

    test('reads the Spanish names used in the ENS column', () {
      expect(
        AuthenticationLevelReading.parse('bajo'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.low),
      );
      expect(
        AuthenticationLevelReading.parse('medio'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.substantial),
      );
      expect(
        AuthenticationLevelReading.parse('alto'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.high),
      );
    });

    test('reads the 2/3/4 numbering of the Cl@ve levels table', () {
      expect(
        AuthenticationLevelReading.parse('2'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.low),
      );
      expect(
        AuthenticationLevelReading.parse('3'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.substantial),
      );
      expect(
        AuthenticationLevelReading.parse('4'),
        isA<KnownAuthenticationLevel>().having((final r) => r.level, 'level', AuthenticationLevel.high),
      );
    });

    test('reports an unrecognised literal without losing it', () {
      expect(AuthenticationLevelReading.parse('enhanced'), const UnknownAuthenticationLevel('enhanced'));
    });

    test('reports a missing claim for null, non-strings and blanks', () {
      expect(AuthenticationLevelReading.parse(null), const MissingAuthenticationLevel());
      expect(AuthenticationLevelReading.parse(3), const MissingAuthenticationLevel());
      expect(AuthenticationLevelReading.parse('   '), const MissingAuthenticationLevel());
    });
  });

  group('AuthenticationLevelReading.meets', () {
    test('accepts the required level and anything above it', () {
      expect(
        const KnownAuthenticationLevel(AuthenticationLevel.substantial, 'substantial').meets(AuthenticationLevel.substantial),
        isTrue,
      );
      expect(
        const KnownAuthenticationLevel(AuthenticationLevel.high, 'high').meets(AuthenticationLevel.substantial),
        isTrue,
      );
    });

    test('rejects a level below the required one', () {
      expect(
        const KnownAuthenticationLevel(AuthenticationLevel.low, 'low').meets(AuthenticationLevel.substantial),
        isFalse,
      );
    });

    // El requisito dice, literalmente, que un claim ausente o desconocido no
    // concede acceso. Es la única regla de seguridad de este fichero, así que
    // se prueba aparte en vez de darla por implícita en las de arriba.
    test('never grants access when the level is unknown or missing', () {
      for (final minimum in AuthenticationLevel.values) {
        expect(const UnknownAuthenticationLevel('enhanced').meets(minimum), isFalse);
        expect(const MissingAuthenticationLevel().meets(minimum), isFalse);
      }
    });
  });

  group('AuthenticationLevel.rank', () {
    test('orders the scale low < substantial < high', () {
      expect(AuthenticationLevel.low.rank, lessThan(AuthenticationLevel.substantial.rank));
      expect(AuthenticationLevel.substantial.rank, lessThan(AuthenticationLevel.high.rank));
    });
  });

  group('value equality', () {
    // Sin esto, cada refresco de token notificaría a los providers que observan
    // el nivel aunque el nivel no haya cambiado.
    test('two readings of the same literal are equal', () {
      expect(AuthenticationLevelReading.parse('low'), AuthenticationLevelReading.parse('low'));
      expect(
        AuthenticationLevelReading.parse('low').hashCode,
        AuthenticationLevelReading.parse('low').hashCode,
      );
      expect(AuthenticationLevelReading.parse(null), AuthenticationLevelReading.parse(''));
    });

    test('different readings are not equal', () {
      expect(AuthenticationLevelReading.parse('low'), isNot(AuthenticationLevelReading.parse('substantial')));
      expect(AuthenticationLevelReading.parse('enhanced'), isNot(AuthenticationLevelReading.parse(null)));
    });
  });
}
