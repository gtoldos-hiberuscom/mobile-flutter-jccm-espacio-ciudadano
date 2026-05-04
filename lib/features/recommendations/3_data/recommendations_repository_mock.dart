import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';

/// In-memory mock repository used while
/// `kRecommendationsLiveBackendEnabled = false`.
///
/// Honours TASK-58 §D4 (fixture spread across buckets) and §D6 (cursor =
/// stringified offset, fixed page size). 14 entries: all visible under
/// "Todos", ~4 under "Últimos días" (last 7 d), ~3 under "Novedades"
/// (last 30 d), ~5 flagged as "Tramitación inmediata".
class RecommendationsRepositoryMock implements RecommendationsRepository {
  RecommendationsRepositoryMock({
    final RecommendationsConfigState configState = RecommendationsConfigState.configured,
    final List<Recommendation>? items,
    final int pageSize = defaultPageSize,
    final Duration latency = Duration.zero,
  }) : _configState = configState,
       _items = List<Recommendation>.unmodifiable(items ?? _defaultFixture()),
       _pageSize = pageSize,
       _latency = latency;

  /// Default page size (TASK-58 §D6). Smaller than the fixture so paging
  /// behaviour is exercised by both the unit tests and the UI demo.
  static const int defaultPageSize = 6;

  final RecommendationsConfigState _configState;
  final List<Recommendation> _items;
  final int _pageSize;
  final Duration _latency;

  @override
  Future<RecommendationsConfigState> loadConfigState() async {
    await _wait();
    return _configState;
  }

  @override
  Future<RecommendationsPageResult> loadAll({final String? cursor}) async {
    return _page(_items, cursor);
  }

  @override
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  }) async {
    if (bucket == RecommendationBucket.todos) {
      return loadAll(cursor: cursor);
    }
    final filtered = _items
        .where((final r) => _matches(r, bucket))
        .toList(
          growable: false,
        );
    return _page(filtered, cursor);
  }

  // ── Internals ────────────────────────────────────────────────────────────

  Future<RecommendationsPageResult> _page(
    final List<Recommendation> source,
    final String? cursor,
  ) async {
    await _wait();
    final offset = _parseCursor(cursor);
    if (offset >= source.length) {
      return RecommendationsPageResult.empty;
    }
    final end = (offset + _pageSize).clamp(0, source.length);
    final slice = source.sublist(offset, end);
    final hasMore = end < source.length;
    return RecommendationsPageResult(
      items: slice,
      hasMore: hasMore,
      nextCursor: hasMore ? end.toString() : null,
    );
  }

  Future<void> _wait() async {
    if (_latency != Duration.zero) {
      await Future<void>.delayed(_latency);
    }
  }

  static int _parseCursor(final String? cursor) {
    if (cursor == null || cursor.isEmpty) {
      return 0;
    }
    final parsed = int.tryParse(cursor);
    if (parsed == null || parsed < 0) {
      return 0;
    }
    return parsed;
  }

  static bool _matches(
    final Recommendation r,
    final RecommendationBucket bucket,
  ) {
    final now = _fixedNow;
    switch (bucket) {
      case RecommendationBucket.todos:
        return true;
      case RecommendationBucket.ultimosDias:
        final at = r.publishedAt;
        return at != null && now.difference(at).inDays <= 7;
      case RecommendationBucket.novedades:
        final at = r.publishedAt;
        return at != null && now.difference(at).inDays <= 30;
      case RecommendationBucket.tramitacionInmediata:
        return r.isImmediateProcessing;
    }
  }

  /// Stable "now" used both to seed the fixture and to filter buckets,
  /// so tests get deterministic counts regardless of wall-clock time.
  static final DateTime _fixedNow = DateTime(2026, 4, 15, 12);

  /// 14 fixture entries spread across buckets per TASK-58 §D4.
  static List<Recommendation> _defaultFixture() {
    final now = _fixedNow;
    DateTime daysAgo(final int n) => now.subtract(Duration(days: n));

    return <Recommendation>[
      // ── Últimos días (≤ 7d) — 4 entries ─────────────────────────────────
      Recommendation(
        id: 'r-001',
        title: 'Solicitud de ayudas para libros de texto',
        summary: 'Convocatoria abierta para el curso 2026/2027.',
        lifeEventId: 'le-edu',
        lifeEventLabel: 'Educación',
        responsibleUnit: 'Consejería de Educación',
        deadlineLabel: '30 días',
        publishedAt: daysAgo(1),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-001'),
      ),
      Recommendation(
        id: 'r-002',
        title: 'Renovación de la tarjeta sanitaria',
        summary: 'Actualiza tus datos para mantener la cobertura.',
        lifeEventId: 'le-salud',
        lifeEventLabel: 'Salud',
        responsibleUnit: 'SESCAM',
        deadlineLabel: '15 días',
        publishedAt: daysAgo(2),
        isImmediateProcessing: true,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-002'),
      ),
      Recommendation(
        id: 'r-003',
        title: 'Inscripción en la bolsa de empleo público',
        lifeEventId: 'le-empleo',
        lifeEventLabel: 'Empleo',
        responsibleUnit: 'Consejería de Empleo',
        deadlineLabel: '60 días',
        publishedAt: daysAgo(3),
        isImmediateProcessing: false,
      ),
      Recommendation(
        id: 'r-004',
        title: 'Cita previa para revisión médica anual',
        summary: 'Disponible en tu centro de salud habitual.',
        lifeEventId: 'le-salud',
        lifeEventLabel: 'Salud',
        responsibleUnit: 'SESCAM',
        deadlineLabel: 'Sin plazo',
        publishedAt: daysAgo(6),
        isImmediateProcessing: true,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-004'),
      ),

      // ── Novedades (8d..30d) — 3 entries ─────────────────────────────────
      Recommendation(
        id: 'r-005',
        title: 'Bono social de vivienda',
        summary: 'Ayuda mensual al alquiler para familias vulnerables.',
        lifeEventId: 'le-vivienda',
        lifeEventLabel: 'Vivienda',
        responsibleUnit: 'Consejería de Fomento',
        deadlineLabel: '90 días',
        publishedAt: daysAgo(12),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-005'),
      ),
      Recommendation(
        id: 'r-006',
        title: 'Beca de comedor escolar',
        lifeEventId: 'le-edu',
        lifeEventLabel: 'Educación',
        responsibleUnit: 'Consejería de Educación',
        deadlineLabel: '45 días',
        publishedAt: daysAgo(18),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-006'),
      ),
      Recommendation(
        id: 'r-007',
        title: 'Solicitud de prestación por desempleo autonómica',
        summary: 'Complemento autonómico al subsidio estatal.',
        lifeEventId: 'le-empleo',
        lifeEventLabel: 'Empleo',
        responsibleUnit: 'Consejería de Empleo',
        deadlineLabel: '30 días',
        publishedAt: daysAgo(25),
        isImmediateProcessing: true,
      ),

      // ── Older entries (> 30d) — only visible under "Todos" / immediate ──
      Recommendation(
        id: 'r-008',
        title: 'Inspección Técnica de Vehículos (ITV)',
        summary: 'Renueva la ITV de tu vehículo en la estación más cercana.',
        lifeEventId: 'le-trafico',
        lifeEventLabel: 'Movilidad',
        responsibleUnit: 'Industria',
        deadlineLabel: '30 días',
        publishedAt: daysAgo(45),
        isImmediateProcessing: true,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-008'),
      ),
      Recommendation(
        id: 'r-009',
        title: 'Solicitud de licencia de caza autonómica',
        lifeEventId: 'le-ocio',
        lifeEventLabel: 'Ocio',
        responsibleUnit: 'Medio Ambiente',
        deadlineLabel: '60 días',
        publishedAt: daysAgo(60),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-009'),
      ),
      Recommendation(
        id: 'r-010',
        title: 'Renovación del título de familia numerosa',
        summary: 'Mantén tus beneficios fiscales y de transporte.',
        lifeEventId: 'le-familia',
        lifeEventLabel: 'Familia',
        responsibleUnit: 'Bienestar Social',
        deadlineLabel: '90 días',
        publishedAt: daysAgo(70),
        isImmediateProcessing: true,
      ),
      Recommendation(
        id: 'r-011',
        title: 'Ayuda al estudio universitario',
        summary: 'Convocatoria autonómica complementaria a la beca MEC.',
        lifeEventId: 'le-edu',
        lifeEventLabel: 'Educación',
        responsibleUnit: 'Consejería de Educación',
        deadlineLabel: '120 días',
        publishedAt: daysAgo(80),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-011'),
      ),
      Recommendation(
        id: 'r-012',
        title: 'Solicitud de duplicado del DNI cultural',
        lifeEventId: 'le-cultura',
        lifeEventLabel: 'Cultura',
        responsibleUnit: 'Cultura',
        deadlineLabel: '15 días',
        publishedAt: daysAgo(95),
        isImmediateProcessing: true,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-012'),
      ),
      Recommendation(
        id: 'r-013',
        title: 'Subvención a entidades sin ánimo de lucro',
        summary: 'Convocatoria anual para proyectos sociales.',
        lifeEventId: 'le-asoc',
        lifeEventLabel: 'Asociaciones',
        responsibleUnit: 'Bienestar Social',
        deadlineLabel: '60 días',
        publishedAt: daysAgo(110),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-013'),
      ),
      Recommendation(
        id: 'r-014',
        title: 'Alta en el padrón municipal autonómico',
        responsibleUnit: 'Administración Local',
        deadlineLabel: 'Sin plazo',
        publishedAt: daysAgo(130),
        isImmediateProcessing: false,
        detailUri: Uri.parse('https://www.jccm.es/tramites/r-014'),
      ),
    ];
  }
}
