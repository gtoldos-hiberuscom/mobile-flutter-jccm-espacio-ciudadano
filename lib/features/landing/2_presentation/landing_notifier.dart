import 'dart:async' show TimeoutException;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_refresh_status.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';

/// UI state for the public landing screen login flow.
final class LandingState {
  const LandingState({
    this.isLoggingIn = false,
    this.error,
    this.loginSuccess = false,
    this.isolationDegradedWarning = false,
    this.sessionExpired = false,
  });

  final bool isLoggingIn;

  /// Non-null when login failed with a non-cancellation error.
  final AuthException? error;

  /// One-shot signal consumed by the page to trigger navigation.
  final bool loginSuccess;

  /// Señal de un solo uso: la sesión guardada no pudo renovarse y se ha
  /// cerrado. Sin esto el guard devolvía al ciudadano a la landing sin decirle
  /// por qué, y desde su punto de vista la app simplemente le echaba.
  final bool sessionExpired;

  /// One-shot signal: login succeeded but the browser could not provide an
  /// ephemeral (isolated) session, so the Cl@ve web session may be remembered
  /// by this device's browser. The page shows a warning snackbar.
  final bool isolationDegradedWarning;
}

/// Owns the login flow state for the public landing screen.
///
/// Orchestration: UI -> login() -> [LoginUseCase] -> notifier updates -> [LandingState].
/// Navigation is triggered by the page via `ref.listen` on `loginSuccess`.
class LandingNotifier extends Notifier<LandingState> {
  /// Hard ceiling for the whole interactive login round-trip. If the AppAuth
  /// future never resolves (browser tab dismissed without a callback reaching
  /// the plugin), `isLoggingIn` would otherwise stay latched and the landing
  /// CTA would be dead until process death.
  static const loginTimeout = Duration(minutes: 3);

  /// Mismo margen que usa [AuthSessionController.refreshIfNeeded]: un token al
  /// borde de caducar no se da por bueno, o se entraría para que la primera
  /// petición se encuentre con un 401.
  static const Duration _accessTokenMargin = Duration(seconds: 60);

  bool _restoreAttempted = false;

  @override
  LandingState build() => const LandingState();

  /// Lleva al ciudadano a su espacio sin pasar por Cl@ve cuando hay una sesión
  /// guardada que todavía sirve.
  ///
  /// Hace falta porque el router arranca siempre en la landing, que es pública,
  /// y el `SessionGuard` solo actúa como redirect de rutas protegidas: nunca
  /// sube de la landing al interior. Sin este puente la sesión persistida se
  /// queda en el Keychain sin que nadie la mire, y el arranque en frío termina
  /// igual que antes — en Cl@ve.
  ///
  /// Reproduce el flujo pedido por el cliente:
  ///
  /// * con el access token todavía vivo se entra directamente, sin pedir nada
  ///   y **sin mirar la preferencia**: ese token se guarda sin protección, así
  ///   que exigir huella para usarlo no protegería nada y sólo costaría un
  ///   login de Cl@ve — además de contradecir lo pedido por el cliente («si
  ///   hay Access token se puede entrar»);
  /// * si ha caducado, hace falta el token de larga vida, y ése sí vive tras
  ///   la biometría: [AuthSessionController.refreshIfNeeded] lo lee del
  ///   almacén, y esa lectura **es** la comprobación biométrica;
  /// * si el refresco no sale adelante —biometría cancelada, token revocado,
  ///   red caída— no se navega: el ciudadano se queda en la landing y entra
  ///   con Cl@ve como siempre. Nunca se le muestra un error por esto, porque
  ///   no ha pedido nada todavía.
  Future<void> tryRestoreSession({
    required final String localizedTitle,
    required final String localizedReason,
    required final String localizedCancel,
  }) async {
    if (_restoreAttempted) {
      return;
    }
    _restoreAttempted = true;

    final sessionController = ref.read(authSessionControllerProvider);
    // Primero *de quién* es la sesión guardada, leyéndolo del access token sin
    // cargar nada ni tocar el almacén protegido. Hace falta antes que la
    // preferencia porque ésta va por ciudadano: en un dispositivo compartido,
    // el «sí» de uno no puede valer por el siguiente.
    final idAgente = await sessionController.persistedIdAgente();
    if (idAgente == null || !ref.mounted) {
      return;
    }

    // Hidratar no toca el almacén protegido, así que no puede levantar el
    // diálogo biométrico: sirve para saber si queda sesión utilizable antes de
    // decidir si hace falta pedir nada.
    final session = await sessionController.hydrateFromStorage();
    if (!ref.mounted) {
      return;
    }

    final expiresAt = session?.accessTokenExpirationDateTime;
    final accessTokenUsable = expiresAt != null && expiresAt.isAfter(DateTime.now().add(_accessTokenMargin));

    if (!accessTokenUsable) {
      // Sin access token vigente sólo queda el de larga vida, y ése sí está
      // detrás de la biometría: si el ciudadano no activó el acceso rápido, no
      // hay nada que abrir y entra por Cl@ve como siempre.
      if (!sessionController.biometricQuickAccessEnabledFor(idAgente)) {
        return;
      }
      final status = await sessionController.refreshIfNeeded(
        prompt: BiometricPromptCopy(title: localizedTitle, subtitle: localizedReason, cancelLabel: localizedCancel),
      );
      if (!ref.mounted) {
        return;
      }
      if (status != SessionRefreshStatus.valid) {
        // Sólo se avisa cuando la sesión está realmente muerta —el servidor ha
        // rechazado la credencial de larga vida— y no cuando el intento
        // simplemente no salió adelante: si el ciudadano canceló la biometría
        // o falló la red, su sesión sigue ahí y decirle que ha terminado sería
        // mentirle. Sin esta distinción, volver tras dos semanas dejaba al
        // ciudadano en la landing sin explicación ninguna.
        if (status == SessionRefreshStatus.definitivelyInvalid) {
          state = const LandingState(sessionExpired: true);
        }
        return;
      }
    }

    // El gate de consentimiento sigue siendo cosa del guard: aquí solo se
    // señala que hay sesión utilizable, y él decide si toca pasar por las
    // cláusulas antes de entrar.
    ref.invalidate(consentProvider(ref.read(citizenEndpointIdsProvider).idAgente ?? ''));
    state = const LandingState(loginSuccess: true);
  }

  Future<void> login() async {
    if (state.isLoggingIn) {
      return;
    }
    state = const LandingState(isLoggingIn: true);

    final LoginResult result;
    try {
      result = await ref.read(loginUseCaseProvider).call().timeout(loginTimeout);
    } on TimeoutException catch (e) {
      if (!ref.mounted) {
        return;
      }
      logger.e('Cl@ve login timed out after $loginTimeout');
      state = LandingState(error: AuthException.unexpected(cause: e));
      return;
    }

    if (!ref.mounted) {
      logger.w('Cl@ve login completed after LandingNotifier was disposed; result dropped');
      return;
    }

    switch (result) {
      case LoginSuccess(:final tokenResponse, :final jwtClaims, :final sessionIsolationDegraded):
        ref.read(authSessionControllerProvider).startInMemory(tokenResponse, claims: jwtClaims);
        ref.invalidate(consentProvider(ref.read(citizenEndpointIdsProvider).idAgente ?? ''));
        state = LandingState(
          loginSuccess: true,
          isolationDegradedWarning: sessionIsolationDegraded,
        );

      case LoginFailed(:final cause):
        // The user only ever sees a curated generic message; this log line is
        // the sole record of the real OAuth error/error_description.
        logger.e('Cl@ve login failed: $cause');
        if (cause is AuthException) {
          // Cancellations are silent — user deliberately dismissed the flow.
          state = cause.reason == AuthFailureReason.cancelled ? const LandingState() : LandingState(error: cause);
        } else {
          state = LandingState(
            error: AuthException.unexpected(cause: cause),
          );
        }
    }
  }

  /// La invoca el `SessionGuard` al expulsar por una sesión irrenovable.
  void notifySessionExpired() => state = const LandingState(sessionExpired: true);

  void clearError() => state = const LandingState();

  /// Consumes the one-shot [LandingState.loginSuccess] signal once a consumer
  /// has acted on it. The provider is not `autoDispose`, so without this a
  /// stale `true` survives for the rest of the process and auto-navigates any
  /// later visit to the /callback page.
  void consumeLoginSuccess() {
    if (state.loginSuccess) {
      state = const LandingState();
    }
  }
}

final landingProvider = NotifierProvider<LandingNotifier, LandingState>(LandingNotifier.new);
