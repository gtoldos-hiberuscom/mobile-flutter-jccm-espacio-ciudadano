// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

/// Resultado de averiguar **qué** autorización falta tras un rechazo del
/// backend.
///
/// También se lanza como excepción: la capa de presentación recibe el mismo
/// tipo que decide, así que una pantalla solo tiene que distinguir tres casos.
sealed class AuthorizationFailure implements Exception {
  const AuthorizationFailure();
}

/// El ciudadano no tiene aceptada la cláusula obligatoria
/// ([requiredConsentClauseId]): la ha retirado desde otro sitio, así que la
/// sesión debe cerrarse.
///
/// Solo se emite con una respuesta **fresca y correcta** del servicio de
/// cláusulas en la que la obligatoria aparece **contestada en falso**
/// (`seleccionado: false` y `pendiente: false`). Un registro donde figura sin
/// contestar no cuenta: es indistinguible del registro sintético que el
/// gateway fabrica cuando el soporte del ciudadano se ha purgado (todo
/// `pendiente: true`, incluso segundos después de un PATCH correcto).
final class ConsentRevoked extends AuthorizationFailure {
  const ConsentRevoked();

  @override
  String toString() => 'ConsentRevoked()';
}

/// Falta una cláusula concreta y ampliable: la pantalla debe ofrecer
/// concederla en Preferencias.
final class ClauseMissing extends AuthorizationFailure {
  const ClauseMissing(this.clauseId);

  final int clauseId;

  @override
  String toString() => 'ClauseMissing($clauseId)';
}

/// No se puede afirmar que falte ninguna autorización.
///
/// Dos caminos llegan aquí y los dos significan "no lo sé": el servicio de
/// cláusulas no pudo responder, o respondió y todas las cláusulas exigidas
/// están aceptadas (con lo que el rechazo no era de consentimiento). En ambos
/// casos la pantalla muestra un error reintentable: **nunca** se cierra sesión
/// ni se le dice al ciudadano que no ha autorizado.
final class AuthorizationUnknown extends AuthorizationFailure {
  const AuthorizationUnknown(this.reason);

  final String reason;

  @override
  String toString() => 'AuthorizationUnknown($reason)';
}

/// Traduce un rechazo por autorización del backend en una de las tres
/// situaciones de [AuthorizationFailure].
///
/// El sobre `412.00`/`3034` no distingue "el ciudadano revocó" de "el gateway
/// no pudo leer preferencias" — falla cerrado y emite el mismo cuerpo en los
/// dos casos. Por eso la única fuente admisible es una lectura **fresca** de
/// las cláusulas, y cualquier fallo de esa lectura se queda en
/// [AuthorizationUnknown].
final class ResolveAuthorizationFailureUsecase {
  const ResolveAuthorizationFailureUsecase(this._repository);

  final ConsentRepository _repository;

  Future<AuthorizationFailure> execute({
    required final String idAgente,
    required final Set<int> requiredClauseIds,
  }) async {
    final List<Clause> clauses;
    try {
      clauses = await _repository.refreshClauses(idAgente: idAgente);
    } on Object catch (error) {
      return AuthorizationUnknown('No se pudo releer las cláusulas: $error');
    }

    bool isAccepted(final int clauseId) => clauses.any((final clause) => clause.id == clauseId && clause.isSelected);

    if (!isAccepted(requiredConsentClauseId)) {
      // Cerrar sesión exige la prueba fuerte: la obligatoria presente y
      // contestada en falso. Si falta del listado o figura `pendiente`, eso es
      // un registro nuevo o purgado (el gateway responde uno sintético con todo
      // pendiente tras borrarse el soporte), no una revocación confirmada.
      final answeredAsRevoked = clauses.any(
        (final clause) => clause.id == requiredConsentClauseId && !clause.isSelected && !clause.isPending,
      );
      if (answeredAsRevoked) {
        return const ConsentRevoked();
      }
      return const AuthorizationUnknown('La cláusula obligatoria aparece sin contestar: registro pendiente o sintético, no una revocación');
    }

    // Orden estable: con varias cláusulas exigidas el resultado no puede
    // depender del orden de iteración de un Set.
    final pendingIds = requiredClauseIds.where((final id) => id != requiredConsentClauseId).toList()..sort();
    for (final clauseId in pendingIds) {
      if (!isAccepted(clauseId)) {
        return ClauseMissing(clauseId);
      }
    }

    return const AuthorizationUnknown('Todas las cláusulas exigidas están aceptadas');
  }
}
