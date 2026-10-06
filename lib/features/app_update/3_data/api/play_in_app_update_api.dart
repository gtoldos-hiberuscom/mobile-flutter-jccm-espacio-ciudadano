// Con prefijo a propósito: el plugin exporta una clase `AppUpdateInfo` que
// colisiona con la entidad del mismo nombre de esta feature.
import 'package:in_app_update/in_app_update.dart' as play;
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/play_update_info_dto.dart';

/// Firma de la consulta a Google Play, inyectable en tests.
typedef CheckPlayUpdate = Future<PlayUpdateInfoDto> Function();

/// Envoltorio del plugin `in_app_update` (API oficial de actualizaciones
/// in-app de Google Play). Solo funciona con la app instalada desde Play (incluidas
/// las pistas de pruebas) y con Play Services: en un emulador sin Play, con un
/// APK instalado a mano o en iOS lanza, y el use case lo convierte en «no
/// bloquear».
final class PlayInAppUpdateApi {
  const PlayInAppUpdateApi._();

  /// Un `Task` de Play que no contesta dejaría la comprobación en curso para
  /// siempre (el notifier descarta las solapadas); mejor darla por fallida.
  static const Duration timeout = Duration(seconds: 5);

  static Future<PlayUpdateInfoDto> checkForUpdate() async {
    final info = await play.InAppUpdate.checkForUpdate().timeout(timeout);
    return PlayUpdateInfoDto(
      updateAvailable: info.updateAvailability == play.UpdateAvailability.updateAvailable,
      availableVersionCode: info.availableVersionCode,
      updatePriority: info.updatePriority,
    );
  }
}
