import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/cache/ttl_cache.dart';

void main() {
  group('TtlCache', () {
    test('returns null for unknown key', () {
      final cache = TtlCache();
      expect(cache.read<String>('missing'), isNull);
    });

    test('returns value before TTL', () {
      var now = DateTime(2026, 1, 1, 12);
      final cache = TtlCache(clock: () => now);
      cache.write('k', 'v', ttl: const Duration(minutes: 5));
      now = now.add(const Duration(minutes: 4));
      expect(cache.read<String>('k'), 'v');
    });

    test('expires past TTL and removes entry', () {
      var now = DateTime(2026, 1, 1, 12);
      final cache = TtlCache(clock: () => now);
      cache.write('k', 'v', ttl: const Duration(minutes: 5));
      now = now.add(const Duration(minutes: 6));
      expect(cache.read<String>('k'), isNull);
      expect(cache.length, 0);
    });

    test('invalidate removes a single entry', () {
      final cache = TtlCache();
      cache
        ..write('a', 1, ttl: const Duration(minutes: 1))
        ..write('b', 2, ttl: const Duration(minutes: 1))
        ..invalidate('a');
      expect(cache.read<int>('a'), isNull);
      expect(cache.read<int>('b'), 2);
    });

    test('invalidatePrefix scopes namespace eviction', () {
      final cache = TtlCache();
      cache
        ..write('agenda:list', 1, ttl: const Duration(minutes: 1))
        ..write('agenda:detail:1', 2, ttl: const Duration(minutes: 1))
        ..write('notifications:inbox', 3, ttl: const Duration(minutes: 1))
        ..invalidatePrefix('agenda:');
      expect(cache.read<int>('agenda:list'), isNull);
      expect(cache.read<int>('agenda:detail:1'), isNull);
      expect(cache.read<int>('notifications:inbox'), 3);
    });

    test('clear empties the cache', () {
      final cache = TtlCache()
        ..write('a', 1, ttl: const Duration(minutes: 1))
        ..clear();
      expect(cache.length, 0);
    });
  });
}
