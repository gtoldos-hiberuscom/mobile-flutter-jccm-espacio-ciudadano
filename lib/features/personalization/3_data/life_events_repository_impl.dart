import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_repository.dart';

/// Mock implementation of [LifeEventsRepository] for STORY-54.
///
/// Returns a deterministic catalog of 10 hechos vitales spread across the
/// supported categories so the UI can exercise grouping, baseline (some
/// pre-selected items) and the loaded/saving/saved transitions without a
/// live backend.
///
/// TODO(STORY-54): replace with the real Dio-backed implementation
/// hitting `/hechos-vitales/hechos/{idAgente}` (GET catalog),
/// `PATCH /hechos-vitales/hechos` (persist selection) and
/// `/hechos-vitales/preferencias/{idAgente}` (DELETE reset). Depends on
/// TASK-21 idAgente closure.
final class LifeEventsRepositoryImpl implements LifeEventsRepository {
  const LifeEventsRepositoryImpl();

  static const List<LifeEvent> _catalog = <LifeEvent>[
    LifeEvent(
      id: 'fam-nacimiento',
      label: 'Nacimiento de un hijo',
      category: LifeEventCategory.familia,
    ),
    LifeEvent(
      id: 'fam-matrimonio',
      label: 'Matrimonio o pareja de hecho',
      category: LifeEventCategory.familia,
    ),
    LifeEvent(
      id: 'sal-discapacidad',
      label: 'Reconocimiento de discapacidad',
      category: LifeEventCategory.salud,
    ),
    LifeEvent(
      id: 'sal-dependencia',
      label: 'Situación de dependencia',
      category: LifeEventCategory.salud,
    ),
    LifeEvent(
      id: 'emp-desempleo',
      label: 'Situación de desempleo',
      category: LifeEventCategory.empleo,
    ),
    LifeEvent(
      id: 'emp-autonomo',
      label: 'Alta como trabajador autónomo',
      category: LifeEventCategory.empleo,
    ),
    LifeEvent(
      id: 'viv-alquiler',
      label: 'Búsqueda de vivienda en alquiler',
      category: LifeEventCategory.vivienda,
    ),
    LifeEvent(
      id: 'viv-rehabilitacion',
      label: 'Rehabilitación o reforma de vivienda',
      category: LifeEventCategory.vivienda,
    ),
    LifeEvent(
      id: 'edu-becas',
      label: 'Solicitud de becas educativas',
      category: LifeEventCategory.educacion,
    ),
    LifeEvent(
      id: 'edu-formacion-adultos',
      label: 'Formación para personas adultas',
      category: LifeEventCategory.educacion,
    ),
  ];

  /// Per-citizen selected ids — kept in memory so consecutive reads after
  /// `saveHechos` / `resetPreferencias` reflect the latest mutation.
  static final Map<String, Set<String>> _persistedSelections =
      <String, Set<String>>{};

  static const Set<String> _defaultBaseline = <String>{
    'fam-nacimiento',
    'emp-desempleo',
  };

  @override
  Future<LifeEventsLoadResult> loadHechos(final String idAgente) async {
    final selected = _persistedSelections.putIfAbsent(
      idAgente,
      () => Set<String>.from(_defaultBaseline),
    );
    return LifeEventsLoadResult(
      items: List<LifeEvent>.unmodifiable(_catalog),
      selectedIds: Set<String>.unmodifiable(selected),
    );
  }

  @override
  Future<void> saveHechos(
    final String idAgente,
    final Set<String> selectedIds,
  ) async {
    _persistedSelections[idAgente] = Set<String>.from(selectedIds);
  }

  @override
  Future<void> resetPreferencias(final String idAgente) async {
    _persistedSelections[idAgente] = <String>{};
  }
}
