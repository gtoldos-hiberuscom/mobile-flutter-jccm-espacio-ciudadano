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
///
/// Only the fields `flutter_secure_storage` 10.0.0 — the version this project
/// pins — actually forwards to the platform. Later 10.x releases add a
/// negative-button label, Secure Enclave wrapping and strong-biometrics-only
/// enforcement; adopting them means moving the pinned dependency, which is a
/// decision of its own.
final class BiometricPromptCopy {
  const BiometricPromptCopy({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
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

  /// Removes all entries from the secure store, whatever their protection.
  Future<void> clear();
}

/// [FlutterSecureStorage]-backed implementation of [SecureStorage].
final class FlutterSecureStorageImpl implements SecureStorage {
  FlutterSecureStorageImpl(this._storage);

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
  Future<void> clear() async {
    // Both policies are wiped: a logout must not leave the biometric-protected
    // refresh token behind just because the default options do not match it.
    await _storage.deleteAll(
      iOptions: _appleOptions(SecureStorageProtection.standard),
      aOptions: _androidOptions(SecureStorageProtection.standard, null),
    );
    await _storage.deleteAll(
      iOptions: _appleOptions(SecureStorageProtection.biometric),
      aOptions: _androidOptions(SecureStorageProtection.biometric, null),
    );
  }

  static IOSOptions _appleOptions(final SecureStorageProtection protection) => switch (protection) {
    SecureStorageProtection.standard => IOSOptions.defaultOptions,
    // `biometryCurrentSet` deliberately invalidates the item when the enrolled
    // biometrics change: a newly added fingerprint must not inherit access to
    // a session it was never authorised for. The citizen falls back to Cl@ve.
    SecureStorageProtection.biometric => const IOSOptions(
      accessControlFlags: [AccessControlFlag.biometryCurrentSet],
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
      biometricPromptTitle: prompt?.title,
      biometricPromptSubtitle: prompt?.subtitle,
    ),
  };
}

/// Riverpod provider that exposes a singleton [SecureStorage] instance.
///
/// Kept alive for the lifetime of the app — tokens must always be reachable.
final secureStorageProvider = Provider<SecureStorage>((final ref) {
  return FlutterSecureStorageImpl(const FlutterSecureStorage());
});
