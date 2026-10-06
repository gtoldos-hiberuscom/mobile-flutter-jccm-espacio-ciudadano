import 'package:meta/meta.dart';

/// Lo que Google Play dice de la app, traducido del plugin `in_app_update` a
/// un tipo propio: ni el mapper ni los tests dependen del plugin.
@immutable
final class PlayUpdateInfoDto {
  const PlayUpdateInfoDto({
    required this.updateAvailable,
    required this.availableVersionCode,
    required this.updatePriority,
  });

  /// `UpdateAvailability.updateAvailable` de Play.
  final bool updateAvailable;

  /// `versionCode` publicado; Play nunca da el nombre de versión.
  final int? availableVersionCode;

  /// Prioridad 0–5 fijada al publicar (solo con la Google Play Developer API).
  final int updatePriority;
}
