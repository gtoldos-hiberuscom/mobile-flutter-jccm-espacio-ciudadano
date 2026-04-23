import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_period_filter.dart';

void main() {
  group('AgendaPeriodFilter.matches', () {
    final now = DateTime(2026, 5, 4, 10, 30); // wed 04 May 2026
    final today = DateTime(now.year, now.month, now.day);

    test('all matches every event regardless of date', () {
      expect(
        AgendaPeriodFilter.all.matches(now, today.subtract(const Duration(days: 1000))),
        isTrue,
      );
      expect(AgendaPeriodFilter.all.matches(now, today), isTrue);
      expect(
        AgendaPeriodFilter.all.matches(now, today.add(const Duration(days: 1000))),
        isTrue,
      );
    });

    test('past matches strictly earlier days', () {
      expect(
        AgendaPeriodFilter.past.matches(now, today.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      // Today itself is NOT past.
      expect(AgendaPeriodFilter.past.matches(now, today), isFalse);
      expect(
        AgendaPeriodFilter.past.matches(now, today.add(const Duration(days: 1))),
        isFalse,
      );
    });

    test('next7Days covers [today, today+7d)', () {
      expect(AgendaPeriodFilter.next7Days.matches(now, today), isTrue);
      expect(
        AgendaPeriodFilter.next7Days.matches(now, today.add(const Duration(days: 6, hours: 23))),
        isTrue,
      );
      expect(
        AgendaPeriodFilter.next7Days.matches(now, today.add(const Duration(days: 7))),
        isFalse,
      );
      expect(
        AgendaPeriodFilter.next7Days.matches(now, today.subtract(const Duration(seconds: 1))),
        isFalse,
      );
    });

    test('next30Days covers [today, today+30d)', () {
      expect(
        AgendaPeriodFilter.next30Days.matches(now, today.add(const Duration(days: 29))),
        isTrue,
      );
      expect(
        AgendaPeriodFilter.next30Days.matches(now, today.add(const Duration(days: 30))),
        isFalse,
      );
    });

    test('next365Days covers [today, today+365d)', () {
      expect(
        AgendaPeriodFilter.next365Days.matches(now, today.add(const Duration(days: 364))),
        isTrue,
      );
      expect(
        AgendaPeriodFilter.next365Days.matches(now, today.add(const Duration(days: 365))),
        isFalse,
      );
    });
  });
}
