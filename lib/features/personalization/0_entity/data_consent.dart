import 'package:meta/meta.dart';

/// Types of citizen authorization (`clausulas`) covered by STORY-55.
///
/// The values map 1:1 to the consent categories surfaced by the
/// `/hechos-vitales/clausulas/{idAgente}` endpoint when it ships:
///
/// - [jccm] — autorización para usar datos propios de JCCM.
/// - [otrasAdmin] — autorización para consultar datos de otras
///   administraciones públicas (interoperabilidad).
/// - [perfilado] — autorización para perfilado de recomendaciones
///   personalizadas.
enum DataConsentType {
  jccm,
  otrasAdmin,
  perfilado,
}

/// A single citizen authorization (`clausula`).
///
/// Pure Dart — no Flutter, Riverpod, Dio, or `BuildContext` imports allowed.
@immutable
final class DataConsent {
  const DataConsent({
    required this.id,
    required this.type,
    required this.accepted,
    this.lastUpdatedAt,
    this.version,
  });

  /// Stable identifier used for persistence and equality.
  final String id;

  /// Authorization category — see [DataConsentType].
  final DataConsentType type;

  /// Whether the citizen has accepted this authorization.
  final bool accepted;

  /// Last time the citizen mutated this consent on the backend.
  /// Null when the catalog has never been persisted for this idAgente.
  final DateTime? lastUpdatedAt;

  /// Backend-provided version string for the `clausula` text. Null when
  /// the mock has not surfaced one yet.
  final String? version;

  DataConsent copyWith({
    final bool? accepted,
    final DateTime? lastUpdatedAt,
    final String? version,
  }) => DataConsent(
    id: id,
    type: type,
    accepted: accepted ?? this.accepted,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    version: version ?? this.version,
  );

  @override
  bool operator ==(final Object other) => identical(this, other) || other is DataConsent && other.id == id && other.type == type && other.accepted == accepted && other.lastUpdatedAt == lastUpdatedAt && other.version == version;

  @override
  int get hashCode => Object.hash(id, type, accepted, lastUpdatedAt, version);
}
