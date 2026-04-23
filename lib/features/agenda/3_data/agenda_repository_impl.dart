import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_repository.dart';

/// In-memory mock implementation of [AgendaRepository].
///
/// Returns a deterministic spread of events anchored on `now`:
///   - 3 events in the past (sscb-style), one of which shares a day to
///     exercise the "multiple events on the same day" calendar dot.
///   - 4 events in the next 7 days (mixed categories).
///   - 3 events in the next 30 days.
///   - 2 events in the next 365 days.
///
/// No backend dependency — STORY-29 unblocks UI work while STORY-30/31
/// wire the real `/sescam/citas*` endpoints (canon §22, offline-first).
final class AgendaRepositoryImpl implements AgendaRepository {
  const AgendaRepositoryImpl();

  @override
  Future<AgendaSnapshot> loadAgenda() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 9);
    final events = <AgendaEvent>[
      // ── Past ─────────────────────────────────────────────────────────
      AgendaEvent(
        id: 'past-1',
        rawTitle: 'Revisión de cardiología',
        description: 'Hospital General de Toledo — Cardiología',
        startsAt: today.subtract(const Duration(days: 60, hours: 1)),
        endsAt: today.subtract(const Duration(days: 60)),
        location: 'Toledo',
        category: AgendaCategory.salud,
        source: AgendaEventSource.ssalud,
      ),
      AgendaEvent(
        id: 'past-2',
        rawTitle: 'Renovación DNI',
        description: 'Comisaría de Toledo',
        startsAt: today.subtract(const Duration(days: 30)),
        location: 'Toledo',
        category: AgendaCategory.administrativo,
        source: AgendaEventSource.ccaa,
      ),
      AgendaEvent(
        id: 'past-3',
        rawTitle: 'Reunión tutoría escolar',
        description: 'CEIP Cervantes',
        startsAt: today.subtract(const Duration(days: 15, hours: 2)),
        location: 'Albacete',
        category: AgendaCategory.educacion,
        source: AgendaEventSource.ccaa,
      ),
      // ── Next 7 days (includes a duplicate-day pair on +3d) ───────────
      AgendaEvent(
        id: 'next7-1',
        rawTitle: 'Análisis de sangre',
        description: 'Centro de salud Talavera',
        startsAt: today.add(const Duration(days: 1, hours: -1)),
        location: 'Talavera de la Reina',
        category: AgendaCategory.salud,
        source: AgendaEventSource.ssalud,
      ),
      AgendaEvent(
        id: 'next7-2',
        rawTitle: 'Cita atención al ciudadano',
        description: 'Oficina de Información',
        startsAt: today.add(const Duration(days: 3, hours: 1)),
        location: 'Cuenca',
        category: AgendaCategory.administrativo,
        source: AgendaEventSource.ccaa,
      ),
      AgendaEvent(
        id: 'next7-3',
        rawTitle: 'Charla orientación universitaria',
        description: 'IES Sefarad',
        startsAt: today.add(const Duration(days: 3, hours: 5)),
        location: 'Toledo',
        category: AgendaCategory.educacion,
        source: AgendaEventSource.manual,
      ),
      AgendaEvent(
        id: 'next7-4',
        rawTitle: 'Recordatorio: revisión médica',
        startsAt: today.add(const Duration(days: 6)),
        category: AgendaCategory.salud,
        source: AgendaEventSource.manual,
      ),
      // ── Next 30 days ─────────────────────────────────────────────────
      AgendaEvent(
        id: 'next30-1',
        rawTitle: 'Vacunación gripe',
        description: 'Centro de salud',
        startsAt: today.add(const Duration(days: 15)),
        location: 'Ciudad Real',
        category: AgendaCategory.salud,
        source: AgendaEventSource.ssalud,
      ),
      AgendaEvent(
        id: 'next30-2',
        rawTitle: 'Renovación carné conducir',
        startsAt: today.add(const Duration(days: 22)),
        location: 'Guadalajara',
        category: AgendaCategory.administrativo,
        source: AgendaEventSource.ccaa,
      ),
      AgendaEvent(
        id: 'next30-3',
        rawTitle: 'Inicio curso de formación',
        description: 'Centro Regional de Formación',
        startsAt: today.add(const Duration(days: 28)),
        location: 'Albacete',
        category: AgendaCategory.educacion,
        source: AgendaEventSource.ccaa,
      ),
      // ── Next 365 days ────────────────────────────────────────────────
      AgendaEvent(
        id: 'next365-1',
        rawTitle: 'Revisión odontológica anual',
        startsAt: today.add(const Duration(days: 120)),
        location: 'Toledo',
        category: AgendaCategory.salud,
        source: AgendaEventSource.ssalud,
      ),
      AgendaEvent(
        id: 'next365-2',
        rawTitle: 'Renovación documento sanitario',
        startsAt: today.add(const Duration(days: 250)),
        category: AgendaCategory.otros,
        source: AgendaEventSource.manual,
      ),
    ];

    return AgendaSnapshot(
      events: events,
      lastUpdatedAt: now,
      loadState: AgendaLoadState.loaded,
    );
  }

  @override
  Stream<AgendaSnapshot> watchAgenda() async* {
    yield await loadAgenda();
  }
}
