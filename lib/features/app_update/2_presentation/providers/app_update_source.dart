import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

/// De dónde sale la versión publicada.
///
/// Se fija con la clave `APP_UPDATE_SOURCE` de los `config_*.json` (o con
/// `--dart-define=APP_UPDATE_SOURCE=mock-forced`): `store` consulta la tienda
/// de la plataforma (App Store por la búsqueda de iTunes, Google Play por la
/// API de actualizaciones in-app); los `mock-*` sirven un manifiesto fijo para
/// desarrollo y QA mientras la app no está publicada.
enum AppUpdateSource {
  store('store', null),
  mockForced('mock-forced', AppUpdateMockScenario.forced),
  mockRecommended('mock-recommended', AppUpdateMockScenario.recommended),
  mockNone('mock-none', AppUpdateMockScenario.none);

  const AppUpdateSource(this.configName, this.mockScenario);

  /// Valor de la clave de configuración.
  final String configName;

  /// Escenario del mock, o `null` si la fuente es la tienda.
  final AppUpdateMockScenario? mockScenario;

  /// Espacio de nombres de la versión recomendada ignorada: haber descartado
  /// la `99.0.0` del mock en un móvil de pruebas no debe silenciar la real.
  String get storageNamespace => mockScenario == null ? 'store' : 'mock';

  /// Fuente por el valor de configuración. Un nombre desconocido cae en
  /// [store] para que una errata nunca deje a producción con un mock.
  static AppUpdateSource fromName(final String name) {
    for (final source in values) {
      if (source.configName == name) {
        return source;
      }
    }
    logger.w('[app_update] APP_UPDATE_SOURCE desconocido "$name"; se usa "store"');
    return store;
  }
}
