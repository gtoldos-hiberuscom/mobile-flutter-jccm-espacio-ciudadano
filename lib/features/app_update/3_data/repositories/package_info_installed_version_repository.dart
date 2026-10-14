import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Firma de `PackageInfo.fromPlatform`, inyectable para no depender del plugin
/// en tests.
typedef LoadPackageInfo = Future<PackageInfo> Function();

/// Versión instalada e id de aplicación leídos de `package_info_plus`.
///
/// La versión es la de marketing (`version`: `versionName` en Android,
/// `CFBundleShortVersionString` en iOS); el número de build se descarta.
///
/// `PackageInfo` se memoriza: no cambia mientras la app está en ejecución.
final class PackageInfoInstalledVersionRepository implements InstalledVersionRepository {
  PackageInfoInstalledVersionRepository({final LoadPackageInfo loadPackageInfo = PackageInfo.fromPlatform}) : _loadPackageInfo = loadPackageInfo;

  final LoadPackageInfo _loadPackageInfo;
  Future<PackageInfo>? _cached;

  @override
  Future<AppVersion> installedVersion() async => AppVersion.parse((await _packageInfo()).version);

  @override
  Future<String> applicationId() async => (await _packageInfo()).packageName;

  Future<PackageInfo> _packageInfo() => _cached ??= _load();

  Future<PackageInfo> _load() async {
    try {
      return await _loadPackageInfo();
    } on Object {
      // Un fallo no se memoriza: la siguiente comprobación vuelve a intentarlo.
      _cached = null;
      rethrow;
    }
  }
}
