import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/elevate_authentication_level_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

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
          // Se adopta en el mismo orden que `LandingNotifier.login`, y por el
          // mismo motivo: la pista para cerrar lo que se acaba de abrir debe
          // quedar guardada antes de que algo pueda fallar.
          session.startInMemory(tokenResponse, claims: jwtClaims);
          final idToken = tokenResponse.idToken;
          if (idToken != null && idToken.isNotEmpty) {
            await session.rememberBrowserSession(idToken);
          }
          // No dejar guardados los tokens del nivel anterior.
          await session.persistCurrentSession();
          if (!ref.mounted) {
            return;
          }
          state = ElevationState(
            outcome: result is ElevationSucceeded ? ElevationOutcome.succeeded : ElevationOutcome.stillInsufficient,
          );

        case ElevationIdentityMismatch():
          // No se adopta el token nuevo, y tampoco vale conservar el viejo: su
          // sesión de navegador se cerró al empezar. Salida honesta: reset.
          logger.w({'event': 'auth_elevation_identity_mismatch'});
          await session.clear();
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
