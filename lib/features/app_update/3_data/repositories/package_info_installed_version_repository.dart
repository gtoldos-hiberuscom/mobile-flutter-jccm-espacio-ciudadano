import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Firma de `PackageInfo.fromPlatform`, inyectable para no depender del plugin
/// en tests.
typedef LoadPackageInfo = Future<PackageInfo> Function();

/// Versión instalada leída de `package_info_plus` (`CFBundleShortVersionString`
/// / `versionName`, que Flutter rellena desde `pubspec.yaml`).
///
/// Se memoriza: no cambia mientras la app está en ejecución.
final class PackageInfoInstalledVersionRepository implements InstalledVersionRepository {
  PackageInfoInstalledVersionRepository({final LoadPackageInfo loadPackageInfo = PackageInfo.fromPlatform}) : _loadPackageInfo = loadPackageInfo;

  final LoadPackageInfo _loadPackageInfo;
  Future<AppVersion>? _cached;

  @override
  Future<AppVersion> installedVersion() => _cached ??= _load();

  Future<AppVersion> _load() async {
    try {
      final info = await _loadPackageInfo();
      return AppVersion.parse(info.version);
    } on Object {
      // Un fallo no se memoriza: la siguiente comprobación vuelve a intentarlo.
      _cached = null;
      rethrow;
    }
  }
}
