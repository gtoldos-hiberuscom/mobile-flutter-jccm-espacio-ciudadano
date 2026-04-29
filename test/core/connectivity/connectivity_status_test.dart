import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';

void main() {
  group('mapConnectivityResults', () {
    test('returns offline when only none is reported', () {
      expect(
        mapConnectivityResults(const [ConnectivityResult.none]),
        ConnectivityStatus.offline,
      );
    });

    test('returns online when wifi is present', () {
      expect(
        mapConnectivityResults(
          const [ConnectivityResult.wifi, ConnectivityResult.none],
        ),
        ConnectivityStatus.online,
      );
    });

    test('returns online when mobile is present', () {
      expect(
        mapConnectivityResults(const [ConnectivityResult.mobile]),
        ConnectivityStatus.online,
      );
    });

    test('returns offline when list is empty', () {
      expect(
        mapConnectivityResults(const []),
        ConnectivityStatus.offline,
      );
    });
  });
}
