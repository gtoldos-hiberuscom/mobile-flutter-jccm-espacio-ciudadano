import 'package:meta/meta.dart';

// Identificadores de cláusula. Son los `idClausula` que devuelve el backend en
// `GET /api/v1/ciudadanos/{id}/clausulas`, no una numeración propia: se envían
// tal cual en las altas y actualizaciones. Empiezan en 0.
//
// Ver `documentation/consent_clause_access_matrix.md` para qué consulta exige
// cada una.

/// Protección de datos. Obligatoria para usar el Espacio Ciudadano.
const requiredConsentClauseId = 0;

/// Condiciones de uso: hechos administrativos de la JCCM en bienestar social,
/// empleo, educación y salud.
const jccmDataConsentClauseId = 1;

/// Espacio Ciudadano: datos de la Administración General del Estado.
const ageDataConsentClauseId = 2;

/// Tratamiento de hechos vitales para recomendaciones personalizadas.
const recommendationsConsentClauseId = 3;

/// Consulta y descarga de carnets digitales.
const digitalCardsConsentClauseId = 4;

/// Domain entity representing a single legal authorisation clause.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
@immutable
final class Clause {
  const Clause({
    required this.id,
    required this.label,
    required this.isSelected,
    this.isPending = false,
    this.version = '1.0',
  });

  final int id;

  /// Human-readable clause text shown to the citizen.
  final String label;

  /// Whether the citizen has checked this clause.
  final bool isSelected;

  /// `true` while the backend has no answer recorded for this clause
  /// (`pendiente` en el sobre): the citizen never accepted **nor** rejected it.
  /// Distingue "contestada en falso" (revocación real) de "sin contestar"
  /// (registro nuevo o purgado), que no prueba ninguna revocación.
  final bool isPending;

  /// Version string for consent-record traceability.
  final String version;

  Clause copyWith({final bool? isSelected, final bool? isPending}) => Clause(
    id: id,
    label: label,
    isSelected: isSelected ?? this.isSelected,
    isPending: isPending ?? this.isPending,
    version: version,
  );

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Clause && id == other.id && isSelected == other.isSelected && isPending == other.isPending && version == other.version;

  @override
  int get hashCode => Object.hash(id, isSelected, isPending, version);
}
