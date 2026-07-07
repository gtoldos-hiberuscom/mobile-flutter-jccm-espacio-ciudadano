import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';

/// Mapper between API DTOs ([Clausulas], [ClausulasAgente]) and domain entity [Clause].
///
/// Maps data layer DTOs from the generated API client to pure domain entities,
/// following the architecture constraint that DTOs must never leak outside `3_data/`.
final class ClauseMapper {
  const ClauseMapper._();

  // ── DTO → Entity ──────────────────────────────────────────────────────────

  /// Converts a single [Clausulas] DTO to a domain [Clause] entity.
  static Clause fromDto(final Clausulas dto, {final String? label}) {
    return Clause(
      id: dto.idClausula ?? 0,
      label: label ?? '',
      isSelected: dto.seleccionado ?? false,
      version: dto.version ?? '1.0',
    );
  }

  /// Converts a [ClausulasAgente] DTO containing a list of clauses.
  ///
  /// Since the API DTO doesn't include the text labels, we need to merge
  /// with a fallback list that contains the actual clause text.
  static List<Clause> fromDtoList(
    final ClausulasAgente dto,
    final List<Clause> fallbackClauses,
  ) {
    final dtoClausesList = dto.clausulas?.toList() ?? <Clausulas>[];

    // Create a map of clause IDs from the API response
    final apiClausesMap = <int, Clausulas>{
      for (final dtoClause in dtoClausesList)
        if (dtoClause.idClausula != null) dtoClause.idClausula!: dtoClause,
    };

    // Merge with fallback clauses to include labels
    return fallbackClauses
        .map((final fallbackClause) {
          final apiClause = apiClausesMap[fallbackClause.id];
          if (apiClause != null) {
            return Clause(
              id: fallbackClause.id,
              label: fallbackClause.label,
              isSelected: apiClause.seleccionado ?? false,
              version: apiClause.version ?? fallbackClause.version,
            );
          }
          return fallbackClause;
        })
        .toList(growable: false);
  }

  // ── Entity → DTO ──────────────────────────────────────────────────────────

  /// Converts a domain [Clause] to a [Clausulas] DTO for API requests.
  static Clausulas toDto(final Clause clause) {
    return Clausulas(
      (final builder) => builder
        ..idClausula = clause.id
        ..seleccionado = clause.isSelected
        // Ensure version is always a string, even if it looks like a number
        ..version = clause.version,
    );
  }

  /// Converts a list of [Clause] entities to a [ClausulasAgente] DTO.
  static ClausulasAgente toClausulasAgente({
    required final String idAgente,
    required final List<Clause> clauses,
  }) {
    return ClausulasAgente(
      (final builder) => builder
        ..idAgente = idAgente
        ..clausulas = ListBuilder<Clausulas>(
          clauses.map(toDto),
        ),
    );
  }
}
