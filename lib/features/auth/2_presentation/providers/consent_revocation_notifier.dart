import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';

/// Cierre de sesión provocado por la retirada de la cláusula obligatoria.
///
/// Cuando el backend rechaza una consulta por falta de autorización y una
/// lectura fresca de las cláusulas confirma que la obligatoria ya no está
/// aceptada, el ciudadano la ha retirado desde otro sitio (el portal, otra
/// app): no hay nada que pueda ver, así que se cierra la sesión.
///
/// El estado es la señal para la UI: pasa a `true` una sola vez y quien la
/// escucha navega al landing con su mensaje. Es **idempotente** a propósito —
/// la pestaña "Todo" lanza cuatro consultas en paralelo y los carnets tres, y
/// cualquiera de ellas puede traer el mismo rechazo.
// Sin `final` a propósito: las pruebas de otras features sustituyen el cierre
// de sesión por un doble que solo lo registra.
class ConsentRevocationNotifier extends Notifier<bool> {
  bool _closing = false;

  @override
  bool build() => false;

  /// Cierra la sesión si no se ha cerrado ya. Devuelve sin hacer nada en
  /// llamadas repetidas.
  Future<void> signalRevoked() async {
    if (_closing || state) {
      return;
    }
    _closing = true;
    logger.w('[autorizacion] cláusula obligatoria retirada: se cierra la sesión');

    final sessionController = ref.read(authSessionControllerProvider);
    final idToken = ref.read(tokenResponseProvider)?.idToken ?? '';
    try {
      // Cerrar también la sesión federada, como el logout del menú de perfil:
      // sin esto el SSO del broker reautenticaría en silencio.
      if (idToken.isNotEmpty) {
        await ref.read(logoutUseCaseProvider).call(idToken: idToken);
      }
    } on Object catch (error) {
      logger.w('[autorizacion] logout federado no completado: $error');
    } finally {
      await sessionController.clear();
      if (ref.mounted) {
        ref.invalidate(landingProvider);
        state = true;
      }
    }
  }
}

/// `true` cuando la sesión se ha cerrado por retirada de la cláusula
/// obligatoria. Lo observa el widget raíz `App` para navegar al landing con
/// el aviso.
final consentRevocationProvider = NotifierProvider<ConsentRevocationNotifier, bool>(
  ConsentRevocationNotifier.new,
);
