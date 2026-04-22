import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// Abstract contract for encrypted key-value storage.
///
/// Implementations must guarantee that values are persisted in the platform
/// secure enclave (iOS Keychain / Android Keystore). Never store tokens in
/// plain `AppStorage`.
abstract interface class SecureStorage {
  /// Returns the stored value for [key], or `null` if absent.
  Future<String?> read(final String key);

  /// Persists [value] under [key].
  Future<void> write(final String key, final String value);

  /// Removes the entry associated with [key].
  Future<void> delete(final String key);

  /// Removes all entries from the secure store.
  Future<void> clear();
}

/// [FlutterSecureStorage]-backed implementation of [SecureStorage].
final class FlutterSecureStorageImpl implements SecureStorage {
  FlutterSecureStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(final String key) => _storage.read(key: key);

  @override
  Future<void> write(final String key, final String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(final String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}

/// Riverpod provider that exposes a singleton [SecureStorage] instance.
///
/// Kept alive for the lifetime of the app — tokens must always be reachable.
@Riverpod(keepAlive: true)
SecureStorage secureStorage(final Ref ref) {
  return FlutterSecureStorageImpl(const FlutterSecureStorage());
}
