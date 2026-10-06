import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Firma de `PackageInfo.fromPlatform`, inyectable para no depender del plugin
/// en tests.
typedef LoadPackageInfo = Future<PackageInfo> Function();

/// Versión instalada e id de aplicación leídos de `package_info_plus`.
///
/// La versión va en el espacio de la tienda ([StorePlatform]): en Android el
/// `versionCode` (`buildNumber`) como `0.0.N`, porque es lo único que Google
/// Play sabe comparar; en iOS (y donde no hay tienda) la versión de marketing
/// (`version`, `x.y.z`).
///
/// `PackageInfo` se memoriza: no cambia mientras la app está en ejecución.
final class PackageInfoInstalledVersionRepository implements InstalledVersionRepository {
  PackageInfoInstalledVersionRepository({
    required final StorePlatform? platform,
    final LoadPackageInfo loadPackageInfo = PackageInfo.fromPlatform,
  }) : _platform = platform,
       _loadPackageInfo = loadPackageInfo;

  final StorePlatform? _platform;
  final LoadPackageInfo _loadPackageInfo;
  Future<PackageInfo>? _cached;

  @override
  Future<AppVersion> installedVersion() async {
    final info = await _packageInfo();
    return switch (_platform) {
      StorePlatform.android => _versionCodeOf(info.buildNumber),
      StorePlatform.ios || null => AppVersion.parse(info.version),
    };
  }

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

  static AppVersion _versionCodeOf(final String buildNumber) {
    final code = int.tryParse(buildNumber.trim());
    if (code == null || code < 0) {
      throw FormatException('Invalid Android versionCode', buildNumber);
    }
    return AppVersion(0, 0, code);
  }
}
