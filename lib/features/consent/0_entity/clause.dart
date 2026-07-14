import 'package:meta/meta.dart';

const requiredConsentClauseId = 0;
const jccmDataConsentClauseId = 1;
const recommendationsConsentClauseId = 3;
const ageDataConsentClauseId = 2;

const jccmDataConsentClauseLabel = 'Autorizo la consulta de los hechos administrativos que obren en poder de la JCCM en materia de Bienestar social, Empleo, Educación y Salud para que se muestren en Espacio ciudadano.';
const otherTopicsConsentClauseLabel = 'Autorizo la consulta de los datos que la Otras temas de interés tiene sobre mí para que se muestren en Espacio Ciudadano.';
const recommendationsConsentClauseLabel = 'Consiento que mis datos sean tratados para recibir recomendaciones relativas a trámites mediante la elaboración de un perfil basado exclusivamente en los hechos vitales que he marcado. Podrá retirar en cualquier momento desmarcando la autorización inicial en el apartado de perfil usuario';

String consentClauseLabel(final int id, final String fallback) => switch (id) {
  jccmDataConsentClauseId => jccmDataConsentClauseLabel,
  ageDataConsentClauseId => otherTopicsConsentClauseLabel,
  recommendationsConsentClauseId => recommendationsConsentClauseLabel,
  _ => fallback,
};

/// Domain entity representing a single legal authorisation clause.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
@immutable
final class Clause {
  const Clause({
    required this.id,
    required this.label,
    required this.isSelected,
    this.version = '1.0',
  });

  final int id;

  /// Human-readable clause text shown to the citizen.
  final String label;

  /// Whether the citizen has checked this clause.
  final bool isSelected;

  /// Version string for consent-record traceability.
  final String version;

  Clause copyWith({final bool? isSelected}) => Clause(
    id: id,
    label: label,
    isSelected: isSelected ?? this.isSelected,
    version: version,
  );

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Clause && id == other.id && isSelected == other.isSelected && version == other.version;

  @override
  int get hashCode => Object.hash(id, isSelected, version);
}
