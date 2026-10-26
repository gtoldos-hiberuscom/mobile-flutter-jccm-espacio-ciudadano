import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

/// Decide si la home ofrece el acceso rápido con biometría.
///
/// Se ofrece una sola vez por ciudadano: el «sí» y el «no» se guardan por
/// `idAgente`, así que quien lo rechaza no lo vuelve a ver —siempre puede
/// activarlo desde Preferencias—. Que se vea o no ya no depende de si se mató
/// la app entre dos logins, que es lo que hacía inconsistente el aviso.
///
/// El estado (`true` = ya mostrada) sólo cubre lo que no llega a guardarse
/// —aceptar y cancelar luego el Face ID, un fallo al guardar el token—, para no
/// repetir la oferta al volver a la home dentro de la misma sesión. Vive en un
/// provider y no en el State porque la página se remonta al navegar por las
/// pestañas del shell, y se rearma al cerrar sesión: el `ProviderScope` dura
/// el proceso, y sin esto la siguiente persona en entrar no la veía nunca.
final biometricQuickAccessOfferProvider = NotifierProvider<BiometricQuickAccessOfferNotifier, bool>(
  BiometricQuickAccessOfferNotifier.new,
);

class BiometricQuickAccessOfferNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref.listen(tokenResponseProvider, (final previous, final next) {
      if (next == null) {
        state = false;
      }
    });
    return false;
  }

  bool shouldOffer(final String idAgente) {
    if (state) {
      return false;
    }
    final appStorage = ref.read(appStorageProvider);
    final enabled = appStorage.read<bool>('${StorageKeys.biometricQuickAccessEnabledPrefix}$idAgente') ?? false;
    final declined = appStorage.read<bool>('${StorageKeys.biometricQuickAccessDeclinedPrefix}$idAgente') ?? false;
    return !enabled && !declined;
  }

  void markShown() => state = true;

  Future<void> recordDeclined(final String idAgente) async {
    await ref.read(appStorageProvider).write('${StorageKeys.biometricQuickAccessDeclinedPrefix}$idAgente', true);
  }
}
