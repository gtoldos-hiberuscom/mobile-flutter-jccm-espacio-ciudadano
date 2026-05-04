import 'package:meta/meta.dart';

/// A single recommended trámite shown in the *Mis Recomendaciones* list.
///
/// Pure Dart — no Flutter, Riverpod, Dio or `BuildContext` imports.
///
/// Fields are nullable per the tolerant adapter contract in
/// `documentation/discovery/TASK-58-recommendations-segmentation-strategy.md`
/// (D2): the backend payload may omit fields, return wrong types or
/// malformed dates, and the UI must degrade gracefully.
@immutable
final class Recommendation {
  const Recommendation({
    required this.id,
    required this.title,
    required this.isImmediateProcessing,
    this.summary,
    this.lifeEventId,
    this.lifeEventLabel,
    this.responsibleUnit,
    this.deadlineLabel,
    this.publishedAt,
    this.detailUri,
  });

  /// Stable identifier (`idTramite` stringified).
  final String id;

  /// Display title (`nombreTramite`). Required to render a card.
  final String title;

  /// Optional short description / summary surfaced under the title.
  final String? summary;

  /// Identifier of the life event the recommendation belongs to (if any).
  final String? lifeEventId;

  /// Human-readable life event label (`nombreHecho`).
  final String? lifeEventLabel;

  /// Backoffice unit responsible for the trámite
  /// (`nombreUnidadResponsable`).
  final String? responsibleUnit;

  /// Pre-formatted deadline label, e.g. `"30 días"` or `"Hasta 31/12"`.
  ///
  /// The adapter formats this server-side / on the data layer following
  /// the rules in TASK-58 D3; the UI does not re-interpret the value.
  final String? deadlineLabel;

  /// Publication timestamp (used for "Últimos días" / "Novedades" buckets).
  final DateTime? publishedAt;

  /// Whether the trámite is flagged as *Tramitación inmediata*.
  final bool isImmediateProcessing;

  /// Deep-link to the detail page when available.
  ///
  /// When `null`, the UI surfaces a "Detalle disponible próximamente"
  /// placeholder instead of attempting to navigate.
  final Uri? detailUri;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Recommendation && other.id == id && other.title == title && other.summary == summary && other.lifeEventId == lifeEventId && other.lifeEventLabel == lifeEventLabel && other.responsibleUnit == responsibleUnit && other.deadlineLabel == deadlineLabel && other.publishedAt == publishedAt && other.isImmediateProcessing == isImmediateProcessing && other.detailUri == detailUri;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    summary,
    lifeEventId,
    lifeEventLabel,
    responsibleUnit,
    deadlineLabel,
    publishedAt,
    isImmediateProcessing,
    detailUri,
  );
}
