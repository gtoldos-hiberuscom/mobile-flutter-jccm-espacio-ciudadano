import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_period_filter.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_provider.dart';

class _FakeAgendaRepository implements AgendaRepository {
  _FakeAgendaRepository(this._snapshot);

  final AgendaSnapshot _snapshot;

  @override
  Future<AgendaSnapshot> loadAgenda() async => _snapshot;

  @override
  Stream<AgendaSnapshot> watchAgenda() async* {
    yield _snapshot;
  }
}

void main() {
  group('AgendaNotifier', () {
    final now = DateTime(2026, 5, 4, 10);
    final today = DateTime(now.year, now.month, now.day);

    AgendaEvent event(
      final String id,
      final DateTime when, {
      final AgendaCategory category = AgendaCategory.salud,
    }) => AgendaEvent(
      id: id,
      rawTitle: 'event-$id',
      startsAt: when,
      category: category,
      source: AgendaEventSource.manual,
    );

    final snapshot = AgendaSnapshot(
      events: <AgendaEvent>[
        event('past', today.subtract(const Duration(days: 10))),
        event('today-a', today.add(const Duration(hours: 8))),
        event('today-b', today.add(const Duration(hours: 14))),
        event('plus3', today.add(const Duration(days: 3))),
        event('plus20', today.add(const Duration(days: 20))),
        event('plus200', today.add(const Duration(days: 200))),
      ],
      lastUpdatedAt: now,
      loadState: AgendaLoadState.loaded,
    );

    ProviderContainer makeContainer() => ProviderContainer(
      overrides: [
        agendaRepositoryProvider.overrideWith(
          (final ref) => _FakeAgendaRepository(snapshot),
        ),
      ],
    );

    test('initial state exposes the full snapshot under filter all', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final state = await container.read(agendaProvider.future);
      expect(state.period, AgendaPeriodFilter.all);
      expect(state.snapshot.events.length, 6);
      expect(state.visibleEvents(now).length, 6);
    });

    test('setPeriod next7Days narrows to events inside the window', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(agendaProvider.future);
      container.read(agendaProvider.notifier).setPeriod(AgendaPeriodFilter.next7Days);
      final state = container.read(agendaProvider).requireValue;
      final ids = state.visibleEvents(now).map((final e) => e.id).toList();
      expect(ids, containsAll(<String>['today-a', 'today-b', 'plus3']));
      expect(ids, isNot(contains('plus20')));
      expect(ids, isNot(contains('past')));
    });

    test('setPeriod past returns only past events', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(agendaProvider.future);
      container.read(agendaProvider.notifier).setPeriod(AgendaPeriodFilter.past);
      final state = container.read(agendaProvider).requireValue;
      final ids = state.visibleEvents(now).map((final e) => e.id).toList();
      expect(ids, <String>['past']);
    });

    test('selectDay narrows visibleEvents to that day', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(agendaProvider.future);
      container.read(agendaProvider.notifier).selectDay(today);
      final state = container.read(agendaProvider).requireValue;
      final ids = state.visibleEvents(now).map((final e) => e.id).toList();
      expect(ids, <String>['today-a', 'today-b']);
    });

    test('setMonth resets the calendar anchor and clears day selection', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(agendaProvider.future);
      container.read(agendaProvider.notifier).selectDay(today);
      final june = DateTime(2026, 6);
      container.read(agendaProvider.notifier).setMonth(june);
      final state = container.read(agendaProvider).requireValue;
      expect(state.calendarMonth, june);
      expect(state.selectedDay, isNull);
    });

    test('daysWithEvents returns unique day buckets in current month', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(agendaProvider.future);
      // Anchor calendar to "today's" month.
      container.read(agendaProvider.notifier).setMonth(DateTime(today.year, today.month));
      final state = container.read(agendaProvider).requireValue;
      final days = state.daysWithEvents();
      // today-a + today-b collapse to a single bucket.
      expect(days.contains(today), isTrue);
      // plus3 same month
      expect(days.contains(today.add(const Duration(days: 3))), isTrue);
    });
  });
}
