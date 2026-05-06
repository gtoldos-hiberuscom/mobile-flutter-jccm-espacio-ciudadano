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
  String toString() => 'AppConfig(env: $environment, baseUrl: $baseUrl, appName: $appName, timeout: $timeout, debugMode: $debugMode, ssoClientId: $ssoClientId, ssoRedirectUri: $ssoRedirectUri, ssoRealm: $ssoRealm, ssoBaseUrl: $ssoBaseUrl)';
}
