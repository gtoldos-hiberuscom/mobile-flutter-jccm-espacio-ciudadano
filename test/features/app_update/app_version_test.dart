import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';

void main() {
  group('AppVersion.parse', () {
    test('parsea x.y.z', () {
      expect(AppVersion.parse('1.2.3'), const AppVersion(1, 2, 3));
    });

    test('ignora el número de build', () {
      expect(AppVersion.parse('0.1.8+10'), const AppVersion(0, 1, 8));
    });

    test('tolera espacios alrededor', () {
      expect(AppVersion.parse('  3.0.1 '), const AppVersion(3, 0, 1));
    });

    test('rechaza cualquier otra forma', () {
      for (final raw in ['1.2', '1.2.3.4', 'a.b.c', '', '-1.0.0', '1.0.0-beta', '1..0']) {
        expect(() => AppVersion.parse(raw), throwsFormatException, reason: '"$raw" debería ser inválida');
      }
    });
  });

  group('AppVersion.tryParse', () {
    test('devuelve null con null o inválido', () {
      expect(AppVersion.tryParse(null), isNull);
      expect(AppVersion.tryParse('x'), isNull);
    });

    test('devuelve la versión cuando es válida', () {
      expect(AppVersion.tryParse('2.5.0'), const AppVersion(2, 5, 0));
    });
  });

  group('comparación', () {
    test('compara numéricamente, no como texto', () {
      expect(const AppVersion(1, 2, 0) < const AppVersion(1, 10, 0), isTrue);
      expect(const AppVersion(0, 9, 9) < const AppVersion(1, 0, 0), isTrue);
      expect(const AppVersion(1, 0, 1) > const AppVersion(1, 0, 0), isTrue);
    });

    test('<= y >= incluyen la igualdad', () {
      const v = AppVersion(1, 0, 0);
      expect(v <= const AppVersion(1, 0, 0), isTrue);
      expect(v >= const AppVersion(1, 0, 0), isTrue);
      expect(v < const AppVersion(1, 0, 0), isFalse);
    });

    test('ordena una lista', () {
      final versions = [const AppVersion(1, 10, 0), const AppVersion(1, 2, 0), const AppVersion(0, 1, 8)]..sort();
      expect(versions, [const AppVersion(0, 1, 8), const AppVersion(1, 2, 0), const AppVersion(1, 10, 0)]);
    });
  });

  test('igualdad, hash y toString', () {
    expect(const AppVersion(1, 2, 3), const AppVersion(1, 2, 3));
    expect(const AppVersion(1, 2, 3).hashCode, const AppVersion(1, 2, 3).hashCode);
    expect(const AppVersion(1, 2, 3), isNot(const AppVersion(1, 2, 4)));
    expect(const AppVersion(1, 2, 3).toString(), '1.2.3');
  });
}
