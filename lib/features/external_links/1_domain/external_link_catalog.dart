import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';

/// Domain contract for the inventory of outbound destinations the app
/// is allowed to navigate to (canon §13, repository ownership).
///
/// Implementations live in `3_data/`. The catalog is intentionally
/// **synchronous and deterministic** — the inventory ships with the
/// binary so it can also act as a security allow-list at launch time
/// (no open redirects, no remote control over destinations).
///
/// This interface must not import Flutter, Riverpod, Dio or any
/// concrete storage class.
abstract interface class ExternalLinkCatalog {
  /// Returns every link known to the application.
  List<ExternalLink> all();

  /// Returns links filtered by [category]. May be empty.
  List<ExternalLink> byCategory(final ExternalLinkCategory category);

  /// Returns the link matching [id] or `null` if it is not in the catalog.
  ExternalLink? findById(final String id);
}
