import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';

/// Versión recomendada descartada, guardada como `x.y.z` en `AppStorage`.
///
/// Va por dispositivo y no por ciudadano (el aviso aparece antes de
/// identificarse, cuando aún no hay `idAgente`) y por fuente (`namespace`):
/// lo descartado con el mock no afecta a la tienda real.
final class AppUpdatePreferencesRepositoryImpl implements AppUpdatePreferencesRepository {
  const AppUpdatePreferencesRepositoryImpl(this._storage, {required final String namespace}) : _key = '${StorageKeys.appUpdateIgnoredVersionPrefix}$namespace';

  final AppStorage _storage;
  final String _key;

  @override
  Future<AppVersion?> readIgnoredVersion() async => AppVersion.tryParse(_storage.read<String>(_key));

  @override
  Future<void> saveIgnoredVersion(final AppVersion version) async {
    final saved = await _storage.write(_key, version.toString());
    if (!saved) {
      throw StateError('Could not persist ignored app update version');
    }
  }
}
