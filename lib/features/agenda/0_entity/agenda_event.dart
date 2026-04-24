/// Category bucket for an [AgendaEvent].
///
/// Stable, locale-independent identifiers — UI labels are resolved through
/// ARB by mapping the enum value to the corresponding `agenda_category_*`
/// key. Pure Dart, no Flutter (canon §11).
enum AgendaCategory {
  salud,
  administrativo,
  educacion,
  otros,
}

/// Origin of an [AgendaEvent] payload — used by the data layer to
/// disambiguate sources when several backends or static catalogs feed
/// the same notifier.
enum AgendaEventSource {
  ssalud,
  ccaa,
  manual,
}

/// Pure-Dart agenda entry exposed to the domain and presentation layers.
///
/// No Flutter / Riverpod / DTO leakage allowed (canon §11). All copy is
/// either an opaque [rawTitle] (data already localised by the source) or
/// a [titleKey] resolved via ARB at render time.
final class AgendaEvent {
  const AgendaEvent({
    required this.id,
    required this.startsAt,
    required this.category,
    required this.source,
    this.titleKey,
    this.rawTitle,
    this.description,
    this.endsAt,
    this.location,
    this.centro,
    this.profesional,
    this.tipo,
    this.justificanteUrl,
  }) : assert(
         titleKey != null || rawTitle != null,
         'AgendaEvent requires either titleKey or rawTitle',
       );

  /// Stable identifier. Used for routing (`/agenda/:id`) and analytics —
  /// must never embed PII.
  final String id;

  /// Optional ARB key — preferred when the source is bundled / static.
  final String? titleKey;

  /// Optional already-localised title — used for backend-sourced events.
  final String? rawTitle;

  /// Optional ARB key or short already-localised description.
  final String? description;

  final DateTime startsAt;
  final DateTime? endsAt;
  final String? location;
  final AgendaCategory category;
  final AgendaEventSource source;

  /// Optional centro / facility (e.g. "Hospital General de Toledo").
  /// Surfaced on the event detail page (STORY-30).
  final String? centro;

  /// Optional professional name (e.g. "Dra. Pérez").
  final String? profesional;

  /// Optional appointment / event type / specialty (e.g. "Cardiología",
  /// "Análisis de sangre"). Distinct from [AgendaCategory] which is the
  /// macrobucket used by UI grouping.
  final String? tipo;

  /// Optional URL of the attendance proof ("justificante de asistencia").
  /// When non-null the detail page renders a CTA. The CTA is currently a
  /// placeholder until external-link allow-listing lands (TASK-53).
  final String? justificanteUrl;

  /// Day component (UTC-agnostic, local time) used by the calendar grid
  /// to bucket events per day.
  DateTime get day => DateTime(startsAt.year, startsAt.month, startsAt.day);
}
