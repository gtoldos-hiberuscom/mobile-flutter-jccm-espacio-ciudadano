/// Which token claim is sent as the `{id}` path segment for the
/// `/api/v1/ciudadanos/{id}/...` endpoints (contacto, notificaciones).
///
/// The backend is mid-migration: PRE already resolves the citizen by document
/// number (the DNI carried in the token), while UAT still resolves by
/// `idAgente`. Sending the wrong one yields a 403. This is therefore configured
/// per environment and should collapse to [numDocumento] everywhere once every
/// backend environment has migrated.
enum CitizenIdStrategy {
  idAgente,
  numDocumento
  ;

  static CitizenIdStrategy fromConfigValue(final String value) => switch (value.trim().toLowerCase()) {
    'idagente' => CitizenIdStrategy.idAgente,
    'numdocumento' => CitizenIdStrategy.numDocumento,
    _ => throw FormatException('Unsupported CIUDADANOS_ID_STRATEGY: $value'),
  };
}

/// Typed runtime configuration for the application.
///
/// An [AppConfig] instance is created from compile-time environment values or
/// from the environment-specific JSON file at start-up, then passed through
/// `bootstrap` into the root widget tree.
class AppConfig {
  const AppConfig.fromMap(this._json);

  const AppConfig.fromEnvironment()
    : _json = const <String, Object?>{
        'APP_FLAVOR': String.fromEnvironment('APP_FLAVOR'),
        'APP_NAME': String.fromEnvironment('APP_NAME'),
        'BASE_URL': String.fromEnvironment('BASE_URL'),
        'CIUDADANOS_ID_STRATEGY': String.fromEnvironment('CIUDADANOS_ID_STRATEGY'),
        'TIMEOUT': String.fromEnvironment('TIMEOUT'),
        'DEBUG_MODE': String.fromEnvironment('DEBUG_MODE'),
        'SSO_CLIENT_ID': String.fromEnvironment('SSO_CLIENT_ID'),
        'SSO_REDIRECT_URI': String.fromEnvironment('SSO_REDIRECT_URI'),
        'SSO_REALM': String.fromEnvironment('SSO_REALM'),
        'SSO_BASE_URL': String.fromEnvironment('SSO_BASE_URL'),
      };

  final Map<String, Object?> _json;

  /// The active environment name for this run (e.g. 'development', 'preproduction', 'production').
  String get environment => _getConfigValue('APP_FLAVOR', (final v) => v as String);

  /// Base URL for the remote API.
  String get baseUrl => _getConfigValue('BASE_URL', (final v) => v as String);

  /// Identifier strategy for the `/api/v1/ciudadanos/{id}` endpoints.
  ///
  /// See [CitizenIdStrategy] — PRE uses `numDocumento` (DNI), UAT uses
  /// `idAgente` while the backend migration is in progress.
  CitizenIdStrategy get citizenIdStrategy => _getConfigValue('CIUDADANOS_ID_STRATEGY', (final v) => CitizenIdStrategy.fromConfigValue(v as String));

  /// Base URL of the JCCM electronic office for the active environment.
  Uri get sedeBaseUrl => switch (environment.trim().toLowerCase()) {
    'development' || 'uat' => Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
    'preproduction' || 'pre' => Uri.parse('https://sede.cm-pre.jccm.es/'),
    'production' || 'pro' => Uri.parse('https://www.jccm.es/'),
    final flavor => throw Exception('Unsupported APP_FLAVOR for Sede URL: $flavor'),
  };

  Uri procedureUrl(final int procedureId) => sedeBaseUrl.resolve('tramites/$procedureId');

  /// URLs shown in the domain service screens. They deliberately live in the
  /// runtime configuration instead of the widgets because procedure ids and
  /// several portals differ between UAT, PRE and production.
  Uri environmentUrl({required final String uat, required final String pre, required final String pro}) => Uri.parse(
    switch (environment.trim().toLowerCase()) {
      'development' || 'uat' => uat,
      'preproduction' || 'pre' => pre,
      'production' || 'pro' => pro,
      final flavor => throw Exception('Unsupported APP_FLAVOR for external URL: $flavor'),
    },
  );

  Uri get educamosUrl => environmentUrl(
    uat: 'https://sso-cerbero-uat.cm-pre.jccm.es/auth/realms/educacion/protocol/openid-connect/auth?client_id=edu-educamos-fo&redirect_uri=https%3A%2F%2Feclmagsc-uat.cm-pre.jccm.es%2Fs%2F&response_mode=fragment&response_type=code&scope=openid&kc_idp_hint=clavesp-saml',
    pre: 'https://sso-cerbero-pre.cm-pre.jccm.es/auth/realms/educacion/protocol/openid-connect/auth?client_id=edu-educamos-fo&redirect_uri=https%3A%2F%2Feclmagsc-pre.cm-pre.jccm.es%2Fs%2F&response_mode=fragment&response_type=code&scope=openid&kc_idp_hint=clavesp-saml',
    pro: 'https://cerbero.jccm.es/auth/realms/educacion/protocol/openid-connect/auth?client_id=edu-educamos-fo&redirect_uri=https%3A%2F%2Feducamosclm.castillalamancha.es%2Faccesoeducamos%2F&response_mode=fragment&response_type=code&scope=openid&kc_idp_hint=clavesp-saml',
  );
  Uri get teachingStaffUrl => environmentUrl(uat: 'https://portalpersonaldocente-uat.cm-pre.jccm.es/', pre: 'https://portalpersonaldocente-pre.cm-pre.jccm.es/', pro: 'https://portalpersonaldocente.jccm.es/');

  Uri educationProcedure(final int index) => _procedureByEnvironment(
    index,
    uat: const [16895, 16737, 13088],
    pre: const [94348, 94190, 90536],
    pro: const [1005767, 1005609, 1019656],
  );
  Uri healthProcedure(final int index) => _procedureByEnvironment(
    index,
    uat: const [14316, 15787, 15497],
    pre: const [91765, 93239, 92949],
    pro: const [1002366, 1002411, 1003550],
  );
  Uri socialWelfareProcedure(final int index) => _procedureByEnvironment(
    index,
    uat: const [12329, 94737, 12701],
    pre: const [89777, 94737, 90149],
    pro: const [1000378, 1004750, 1000750],
    uatUsesPreSede: const {1},
  );
  Uri employmentProcedure(final int index) => _procedureByEnvironment(
    index,
    uat: const [13472, 14568, 15620],
    pre: const [90920, 92017, 93072],
    pro: const [1001521, 1002618, 1003673],
  );
  Uri housingProcedure(final int index) => _procedureByEnvironment(
    index,
    uat: const [94881, 13882, 12159],
    pre: const [94881, 91331, 89607],
    pro: const [1021878, 1001932, 1000208],
    uatUsesPreSede: const {0},
  );
  Uri vehiclesProcedure(final int index) => _procedureByEnvironment(
    index,
    uat: const [17219, 17220, 14089],
    pre: const [94135, 94673, 91538],
    pro: const [1018538, 1018539, 1002139],
  );

  Uri _procedureByEnvironment(final int index, {required final List<int> uat, required final List<int> pre, required final List<int> pro, final Set<int> uatUsesPreSede = const {}}) {
    final flavor = environment.trim().toLowerCase();
    if ((flavor == 'development' || flavor == 'uat') && uatUsesPreSede.contains(index)) {
      return Uri.parse('https://sede.cm-pre.jccm.es/tramites/${uat[index]}');
    }
    final ids = switch (flavor) {
      'development' || 'uat' => uat,
      'preproduction' || 'pre' => pre,
      'production' || 'pro' => pro,
      _ => throw Exception('Unsupported APP_FLAVOR for procedure URL: $flavor'),
    };
    return procedureUrl(ids[index]);
  }

  Uri get sescamUrl => Uri.parse('https://sanidad.castillalamancha.es/');
  Uri get digitalHealthUrl => environmentUrl(uat: 'https://sescam.jccm.es/misaluddigital/#/app/inicio', pre: 'https://sescampre.jccm.es/misaluddigital/app/inicio', pro: 'https://sescam.jccm.es/misaluddigital/#/app/inicio');
  Uri get clinicalHistoryUrl => Uri.parse('https://sescam.jccm.es/hcdSnsWeb/accesoCiudadano/indexAction.do');
  Uri get socialHistoryUrl => environmentUrl(uat: 'https://historiasocial-pre.castillalamancha.es/historiasocial/avisoLegal.do', pre: 'https://historiasocial-pre.castillalamancha.es/historiasocial/avisoLegal.do', pro: 'https://historiasocial.castillalamancha.es/historiasocial/avisoLegal.do');
  Uri get childrenAndFamiliesUrl => Uri.parse('https://infanciayfamilias.castillalamancha.es/');
  Uri get employmentUrl => environmentUrl(uat: 'https://empleabilidad-pre.cm-pre.jccm.es/', pre: 'https://empleabilidad-pre.cm-pre.jccm.es/', pro: 'https://empleo.castillalamancha.es/private/posicion-global');
  Uri get publicEmploymentUrl => Uri.parse('https://empleopublico.castillalamancha.es/');
  Uri get housingUrl => Uri.parse('https://vivienda.castillalamancha.es/');
  Uri get cadastreUrl => Uri.parse('https://www.sedecatastro.gob.es/');
  Uri get dgtUrl => Uri.parse('https://sede.dgt.gob.es/es/');
  Uri get ageCitizenFolderUrl => Uri.parse('https://carpetaciudadana.gob.es/carpeta/clave.htm');

  /// Human-readable application name used in UI and analytics.
  String get appName => _getConfigValue('APP_NAME', (final v) => v as String);

  /// Network timeout in seconds.
  int get timeout => _getConfigValue('TIMEOUT', _parseInt);

  /// Whether verbose/debug logging is enabled.
  bool get debugMode => _getConfigValue('DEBUG_MODE', _parseBool);

  String get ssoClientId => _getConfigValue('SSO_CLIENT_ID', (final v) => v as String);

  String get ssoRedirectUri => _getConfigValue('SSO_REDIRECT_URI', (final v) => v as String);

  String get ssoRealm => _getConfigValue('SSO_REALM', (final v) => v as String);

  String get ssoBaseUrl => _getConfigValue('SSO_BASE_URL', (final v) => v as String);

  T _getConfigValue<T>(final String key, final T Function(Object) parser) {
    final value = _json[key];
    if (value == null) {
      throw Exception('Missing required config: $key');
    }
    try {
      return parser(value);
    } catch (e) {
      throw Exception('Invalid config for $key: $value');
    }
  }

  int _parseInt(final Object value) => switch (value) {
    final int intValue => intValue,
    final String stringValue => int.parse(stringValue),
    _ => throw FormatException('Expected int-compatible value: $value'),
  };

  bool _parseBool(final Object value) => switch (value) {
    final bool boolValue => boolValue,
    final String stringValue => bool.parse(stringValue),
    _ => throw FormatException('Expected bool-compatible value: $value'),
  };

  @override
  String toString() => 'AppConfig(env: $environment, baseUrl: $baseUrl, citizenIdStrategy: ${citizenIdStrategy.name}, appName: $appName, timeout: $timeout, debugMode: $debugMode, ssoClientId: $ssoClientId, ssoRedirectUri: $ssoRedirectUri, ssoRealm: $ssoRealm, ssoBaseUrl: $ssoBaseUrl)';
}
