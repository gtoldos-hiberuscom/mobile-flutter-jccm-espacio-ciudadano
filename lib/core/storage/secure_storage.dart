import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// How strongly a stored value is protected at rest.
///
/// Declared here, as a type of its own, so the [SecureStorage] contract never
/// leaks `flutter_secure_storage` types to its callers.
enum SecureStorageProtection {
  /// Platform secure store with its default policy: readable whenever the
  /// device is unlocked, without any user interaction.
  standard,

  /// Readable only after the user authenticates with biometrics: the platform
  /// raises the prompt on read, so **reading the value is the biometric
  /// check**. Nothing else in the app has to gate it.
  biometric,
}

/// Copy for the Android biometric prompt.
///
/// Android renders its own dialog and takes the strings from the caller; iOS
/// uses the system prompt plus `NSFaceIDUsageDescription` from `Info.plist`
/// and ignores this. Passed in from the presentation layer because
/// `lib/core/storage` has no access to `AppLocalizations`.

final class BiometricPromptCopy {
  const BiometricPromptCopy({
    required this.title,
    required this.subtitle,
    required this.cancelLabel,
  });

  final String title;
  final String subtitle;
  final String cancelLabel;
}

/// Abstract contract for encrypted key-value storage.
///
/// Implementations must guarantee that values are persisted in the platform
/// secure enclave (iOS Keychain / Android Keystore). Never store tokens in
/// plain `AppStorage`.
abstract interface class SecureStorage {
  /// Returns the stored value for [key], or `null` if absent.
  ///
  /// With [SecureStorageProtection.biometric] this raises the platform
  /// biometric prompt and throws if the user cancels or fails it.
  Future<String?> read(
    final String key, {
    final SecureStorageProtection protection,
    final BiometricPromptCopy? prompt,
  });

  /// Persists [value] under [key].
  Future<void> write(
    final String key,
    final String value, {
    final SecureStorageProtection protection,
    final BiometricPromptCopy? prompt,
  });

  /// Removes the entry associated with [key].
  Future<void> delete(
    final String key, {
    final SecureStorageProtection protection,
  });

  /// Vacía de golpe todo lo guardado tras biometría.
  ///
  /// Existe como operación propia porque borrar **clave a clave** con
  /// protección biométrica obliga a la plataforma a usar el cifrador, y en
  /// Android eso levanta el diálogo de huella: cerrar sesión pedía biometría
  /// incluso a quien nunca la activó. Vaciar el almacén con nombre propio no
  /// necesita descifrar nada.
  Future<void> clearBiometric();

  /// Removes all entries from the secure store.
  ///
  /// [includeBiometric] permite dejar fuera el almacén protegido. Merece la
  /// pena porque en Android **tocarlo lo crea**, y crearlo puede exigir
  /// autenticación: quien solo quiera limpiar lo ordinario no debe provocarle
  /// un diálogo de huella al ciudadano.
  Future<void> clear({final bool includeBiometric});
}

/// [FlutterSecureStorage]-backed implementation of [SecureStorage].
final class FlutterSecureStorageImpl implements SecureStorage {
  FlutterSecureStorageImpl(this._storage);

  /// Espacio de nombres del almacén Android reservado a lo que va tras
  /// biometría. Separado del almacén por defecto a propósito: ver
  /// [_androidOptions].
  static const String _biometricStoreName = 'jccm_secure_biometric';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(
    final String key, {
    final SecureStorageProtection protection = SecureStorageProtection.standard,
    final BiometricPromptCopy? prompt,
  }) => _storage.read(
    key: key,
    iOptions: _appleOptions(protection),
    aOptions: _androidOptions(protection, prompt),
  );

  @override
  Future<void> write(
    final String key,
    final String value, {
    final SecureStorageProtection protection = SecureStorageProtection.standard,
    final BiometricPromptCopy? prompt,
  }) => _storage.write(
    key: key,
    value: value,
    iOptions: _appleOptions(protection),
    aOptions: _androidOptions(protection, prompt),
  );

  @override
  Future<void> delete(
    final String key, {
    final SecureStorageProtection protection = SecureStorageProtection.standard,
  }) => _storage.delete(
    key: key,
    iOptions: _appleOptions(protection),
    aOptions: _androidOptions(protection, null),
  );

  @override
  Future<void> clearBiometric() => _storage.deleteAll(
    iOptions: _appleOptions(SecureStorageProtection.biometric),
    aOptions: _androidOptions(SecureStorageProtection.biometric, null),
  );

  @override
  Future<void> clear({final bool includeBiometric = true}) async {
    await _storage.deleteAll(
      iOptions: _appleOptions(SecureStorageProtection.standard),
      aOptions: _androidOptions(SecureStorageProtection.standard, null),
    );
    if (!includeBiometric) {
      return;
    }
    // Por defecto sí: un logout no puede dejar atrás el offline token sólo
    // porque las opciones por defecto no casen con la entrada protegida.
    await clearBiometric();
  }

  static IOSOptions _appleOptions(final SecureStorageProtection protection) => switch (protection) {
    SecureStorageProtection.standard => IOSOptions.defaultOptions,
    // `biometryCurrentSet` deliberately invalidates the item when the enrolled
    // biometrics change: a newly added fingerprint must not inherit access to
    // a session it was never authorised for. The citizen falls back to Cl@ve.
    SecureStorageProtection.biometric => const IOSOptions(
      accessControlFlags: [AccessControlFlag.biometryCurrentSet],
      // La clave que envuelve el token la custodia el Secure Enclave. Si el
      // dispositivo no lo tiene, el propio plugin cae a Keychain estándar
      // conservando los flags, así que no hay nada que degradar a mano.
      useSecureEnclave: true,
    ),
  };

  static AndroidOptions _androidOptions(
    final SecureStorageProtection protection,
    final BiometricPromptCopy? prompt,
  ) => switch (protection) {
    SecureStorageProtection.standard => AndroidOptions.defaultOptions,
    SecureStorageProtection.biometric => AndroidOptions.biometric(
      // Without this the plugin degrades silently to an unauthenticated key
      // (`setUserAuthenticationRequired(false)`) whenever biometrics are
      // unavailable — which would store the offline token unprotected.
      enforceBiometrics: true,
      // Este almacén se crea para una única cosa y con un único algoritmo, así
      // que no hay nada que migrar jamás. Con la migración activa el plugin
      // interpreta el primer uso como «cambio de algoritmo» y lanza un proceso
      // que exige autenticar, colando un diálogo de huella donde no toca.
      migrateOnAlgorithmChange: false,
      // Almacén propio, y esto no es cosmético: en Android el cifrador es del
      // almacén entero, no de cada clave. El almacén por defecto de esta app
      // se creó hace mucho con un cifrador sin autenticación, y el plugin lo
      // reutiliza tal cual —`cipher == null` y se salta la biometría—, así que
      // pedirla por clave no surtía efecto. Con un nombre propio el almacén
      // nace de cero y su clave se genera con `setUserAuthenticationRequired`.
      storageNamespace: _biometricStoreName,
      // `strongBiometricOnly` y no la credencial del dispositivo: el PIN del
      // terminal ya protege el acceso al propio terminal, y admitirlo aquí
      // haría que quien conozca ese PIN heredase semanas de sesión.
      biometricType: AndroidBiometricType.strongBiometricOnly,
      biometricPromptTitle: prompt?.title,
      biometricPromptSubtitle: prompt?.subtitle,
      biometricPromptNegativeButton: prompt?.cancelLabel,
    ),
  };
}

/// Riverpod provider that exposes a singleton [SecureStorage] instance.
///
/// Kept alive for the lifetime of the app — tokens must always be reachable.
final secureStorageProvider = Provider<SecureStorage>((final ref) {
  return FlutterSecureStorageImpl(const FlutterSecureStorage());
});
