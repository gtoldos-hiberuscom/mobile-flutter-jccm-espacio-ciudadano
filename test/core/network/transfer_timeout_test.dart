import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/transfer_timeout.dart';

void main() {
  group('payloadTransferTimeout', () {
    const base = Duration(seconds: 10);

    test('un cuerpo vacío se queda en el timeout general', () {
      expect(payloadTransferTimeout(payloadBytes: 0, baseTimeout: base), base);
      expect(payloadTransferTimeout(payloadBytes: -1, baseTimeout: base), base);
    });

    test('suma el tiempo de transferencia al timeout general', () {
      // 1 MB al ritmo asumido de 128 kB/s = 8 s.
      expect(
        payloadTransferTimeout(payloadBytes: 1024 * 1024, baseTimeout: base),
        const Duration(seconds: 18),
      );
    });

    test('redondea hacia arriba: nunca deja un plazo por debajo de lo necesario', () {
      expect(
        payloadTransferTimeout(payloadBytes: assumedUplinkBytesPerSecond + 1, baseTimeout: base),
        const Duration(seconds: 12),
      );
    });

    test('crece con el tamaño', () {
      final small = payloadTransferTimeout(payloadBytes: 1024 * 1024, baseTimeout: base);
      final big = payloadTransferTimeout(payloadBytes: 8 * 1024 * 1024, baseTimeout: base);
      expect(big, greaterThan(small));
    });
  });

  group('base64WireSize', () {
    test('cuatro caracteres por cada tres bytes, con relleno', () {
      expect(base64WireSize(3), 4);
      expect(base64WireSize(1), 4);
      expect(base64WireSize(1024 * 1024), 1398104);
    });
  });
}
