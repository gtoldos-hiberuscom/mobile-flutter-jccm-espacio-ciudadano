import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/elevate_authentication_level_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';

/// Desenlace de la última elevación, para que la pantalla lo cuente.
enum ElevationOutcome {
  /// Volvió con nivel suficiente. La pantalla ya se recarga por derivación.
  succeeded,

  /// Se reidentificó, pero el método elegido no alcanza el nivel exigido.
  stillInsufficient,

  /// El token nuevo era de otra persona: la sesión se ha cerrado.
  identityChanged,

  /// No se pudo completar. Se mantiene el bloqueo y se puede reintentar.
  failed,
}

final class ElevationState {
  const ElevationState({this.isElevating = false, this.outcome});

  final bool isElevating;

  /// Señal de un solo uso: la pantalla la consume y llama a [ElevationNotifier.acknowledge].
  final ElevationOutcome? outcome;

  ElevationState copyWith({final bool? isElevating, final ElevationOutcome? outcome}) =>
      ElevationState(isElevating: isElevating ?? this.isElevating, outcome: outcome);
}

/// Conduce la elevación de nivel y expone su estado.
///
/// Calcado de `LandingNotifier`: `isElevating` hace de guarda de reentrada
/// igual que `LandingState.isLoggingIn`, y el desenlace viaja como señal de un
/// solo uso.
///
/// **No repropaga nada a mano en el camino feliz.** Adoptar la sesión escribe
/// `tokenResponseProvider` y `jwtClaimsProvider`, de los que cuelga por
/// `ref.watch` el nivel, y de él el gate: el listado se rehace solo.
class ElevationNotifier extends Notifier<ElevationState> {
  @override
  ElevationState build() => const ElevationState();

  void acknowledge() {
    if (state.outcome != null) {
      state = ElevationState(isElevating: state.isElevating);
    }
  }

  Future<void> elevate({required final AuthenticationLevel minimum}) async {
    if (state.isElevating) {
      return;
    }
    final previous = ref.read(jwtClaimsProvider);
    if (previous == null) {
      // Sin sesión no hay nada que elevar; el guard de ruta ya expulsa.
      return;
    }

    state = const ElevationState(isElevating: true);
    final session = ref.read(authSessionControllerProvider);

    try {
      final result = await ref.read(elevateAuthenticationLevelUseCaseProvider)(
        minimum: minimum,
        currentClaims: previous,
      );
      if (!ref.mounted) {
        return;
      }

      switch (result) {
        case ElevationSucceeded(:final tokenResponse, :final jwtClaims):
        case ElevationInsufficient(:final tokenResponse, :final jwtClaims):
          // Se adopta como lo hace `LandingNotifier.login`, que es lo que
          // esta elevación es: un login. Memoria, pista de navegador e
          // invalidar el consentimiento.
          //
          // Lo que el login hace y aquí **no**: `endStaleBrowserSession()`
          // antes de autorizar. Aquello cierra la sesión que dejó otro
          // ciudadano (JCCMEC-224/228); aquí es el mismo, `prompt=login` ya
          // obliga a Cl@ve a desafiar, y cerrarle la sesión antes de elevar
          // fue lo que lo echaba al landing el 29/09 si después cancelaba.
          session.startInMemory(tokenResponse, claims: jwtClaims);
          // La sesión del navegador es ahora la de esta identificación, así
          // que el `id_token` que la cierra también. Con el anterior, el
          // siguiente cambio de ciudadano no podría cerrarla y Cerbero
          // volvería a cortar con «already authenticated as different user».
          await session.rememberBrowserSession(tokenResponse.idToken);
          if (!ref.mounted) {
            return;
          }
          // Lo que el login hace y aquí faltaba: el estado de consentimiento
          // cacheado es del token anterior.
          ref.invalidate(consentProvider(ref.read(citizenEndpointIdsProvider).idAgente ?? ''));
          // **NO se persiste la sesión aquí, y no es un olvido.** Persistir es
          // decisión del `SessionGuard`, que solo lo hace tras confirmar el
          // consentimiento (`_persistSessionNowConsentIsOnRecord`). Al
          // persistir por nuestra cuenta, `hasPersistedSession()` pasaba a ser
          // `true` antes de que el gate hubiera confirmado nada, y entonces un
          // `ConsentRequired` en la siguiente navegación tomaba la rama
          // destructiva del guard —`clear()` + rebote— y **echaba al ciudadano
          // al landing público justo después de elevar**. Sin persistir, ese
          // mismo `ConsentRequired` lleva al gate legal, que es recuperable.
          state = ElevationState(
            outcome: result is ElevationSucceeded ? ElevationOutcome.succeeded : ElevationOutcome.stillInsufficient,
          );

        case ElevationIdentityMismatch(:final idToken):
          // Acaba de identificarse otra persona en este dispositivo: no se
          // adopta el token nuevo, y tampoco vale seguir con el viejo.
          logger.w({'event': 'auth_elevation_identity_mismatch'});
          await session.clear();
          // `clear()` borra la pista de navegador, pero en el navegador queda
          // viva la sesión de esa otra persona. Se deja la suya —después del
          // `clear()`, que si no la borraría— para que el siguiente login la
          // cierre (`endStaleBrowserSession`). No autoriza nada: solo sirve
          // para cerrar.
          await session.rememberBrowserSession(idToken);
          if (!ref.mounted) {
            return;
          }
          state = const ElevationState(outcome: ElevationOutcome.identityChanged);

        case ElevationCancelled():
          // Silencio, como el login trata la cancelación.
          state = const ElevationState();

        case ElevationFailed(:final message, :final cause):
          logger.e({'event': 'auth_elevation_failed', 'message': message}, error: cause);
          state = const ElevationState(outcome: ElevationOutcome.failed);
      }
    } on Object catch (error, stackTrace) {
      logger.e({'event': 'auth_elevation_unexpected'}, error: error, stackTrace: stackTrace);
      if (ref.mounted) {
        state = const ElevationState(outcome: ElevationOutcome.failed);
      }
    }
  }
}

final elevationProvider = NotifierProvider<ElevationNotifier, ElevationState>(ElevationNotifier.new);
