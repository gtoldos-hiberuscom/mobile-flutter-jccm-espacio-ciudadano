import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/temp_cleanup.dart';

void main() {
  group('sweepDigitalCardsTempCache', () {
    late Directory tempRoot;

    setUp(() async {
      tempRoot = await Directory.systemTemp.createTemp('temp_cleanup_test_');
    });

    tearDown(() async {
      if (tempRoot.existsSync()) {
        await tempRoot.delete(recursive: true);
      }
    });

    test('returns 0 when the digital_cards subdirectory is missing', () async {
      final removed = await sweepDigitalCardsTempCache(tempRoot: tempRoot);
      expect(removed, 0);
    });

    test('removes only files older than the threshold', () async {
      final dir = Directory(
        '${tempRoot.path}${Platform.pathSeparator}digital_cards',
      );
      await dir.create(recursive: true);

      final stale = File('${dir.path}${Platform.pathSeparator}stale.pdf');
      await stale.writeAsBytes(<int>[1, 2, 3]);
      // Age it 24h.
      final old = DateTime.now().subtract(const Duration(hours: 24));
      await stale.setLastModified(old);

      final fresh = File('${dir.path}${Platform.pathSeparator}fresh.pdf');
      await fresh.writeAsBytes(<int>[4, 5, 6]);

      final removed = await sweepDigitalCardsTempCache(
        tempRoot: tempRoot,
        olderThan: const Duration(minutes: 5),
      );

      expect(removed, 1);
      expect(stale.existsSync(), isFalse);
      expect(fresh.existsSync(), isTrue);
    });

    test('returns 0 and does not throw on an empty directory', () async {
      final dir = Directory(
        '${tempRoot.path}${Platform.pathSeparator}digital_cards',
      );
      await dir.create(recursive: true);
      final removed = await sweepDigitalCardsTempCache(tempRoot: tempRoot);
      expect(removed, 0);
    });

    test('ignores subdirectories', () async {
      final dir = Directory(
        '${tempRoot.path}${Platform.pathSeparator}digital_cards',
      );
      await dir.create(recursive: true);
      final inner = Directory('${dir.path}${Platform.pathSeparator}sub');
      await inner.create();

      final removed = await sweepDigitalCardsTempCache(
        tempRoot: tempRoot,
        olderThan: const Duration(minutes: 5),
      );
      expect(removed, 0);
      expect(inner.existsSync(), isTrue);
    });
  });
}
