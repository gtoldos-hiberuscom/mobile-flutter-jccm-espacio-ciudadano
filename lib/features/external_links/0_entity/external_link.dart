import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:meta/meta.dart';

/// Immutable value object describing a single outbound destination shown
/// in the dashboard, landings or sitemap (canon §11).
///
/// Pure Dart only — no Flutter, Riverpod or `BuildContext` references.
///
/// - [id] is the stable, machine-readable identifier used by analytics,
///   tests and the catalog (e.g. `'educamos_clm'`). Never localised.
/// - [displayKey] is the ARB localisation key resolved by the presentation
///   layer (e.g. `'externalLinkEducamosClmLabel'`). The entity never
///   holds the rendered label, so the same value object is locale-safe.
/// - [url] is the validated outbound [Uri]. Schemes/hosts are re-validated
///   at launch time by the launcher (defence-in-depth).
/// - [category] groups the destination for analytics and grouping in UI.
@immutable
final class ExternalLink {
  const ExternalLink({
    required this.id,
    required this.displayKey,
    required this.url,
    required this.category,
  });

  /// Stable, locale-independent identifier.
  final String id;

  /// ARB localisation key for the user-facing label.
  final String displayKey;

  /// Outbound destination. Must be `https`. Re-validated at launch time.
  final Uri url;

  /// Logical category used for grouping and analytics labelling.
  final ExternalLinkCategory category;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is ExternalLink &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayKey == other.displayKey &&
          url == other.url &&
          category == other.category;

  @override
  int get hashCode => Object.hash(id, displayKey, url, category);

  @override
  String toString() =>
      'ExternalLink(id: $id, category: $category, host: ${url.host})';
}
