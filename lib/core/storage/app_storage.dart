import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_storage.g.dart';

/// Abstract contract for non-sensitive key-value storage.
///
/// Backed by SharedPreferences. Do NOT store secrets here; use
/// `SecureStorage` for tokens and credentials.
abstract interface class AppStorage {
  /// Returns the stored value for [key] cast to [T], or `null` if absent.
  ///
  /// Supported types: [String], [bool], [int], [double], `List<String>`.
  T? read<T>(final String key);

  /// Persists [value] under [key].
  ///
  /// Supported types: [String], [bool], [int], [double], `List<String>`.
  Future<bool> write(final String key, final Object value);

  /// Removes the entry associated with [key].
  Future<bool> remove(final String key);

  /// Removes all entries from the store.
  Future<bool> clear();
}

/// SharedPreferences-backed implementation of [AppStorage].
final class SharedPreferencesAppStorage implements AppStorage {
  SharedPreferencesAppStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  T? read<T>(final String key) => _prefs.get(key) as T?;

  @override
  Future<bool> write(final String key, final Object value) => switch (value) {
    final String v => _prefs.setString(key, v),
    final bool v => _prefs.setBool(key, v),
    final int v => _prefs.setInt(key, v),
    final double v => _prefs.setDouble(key, v),
    final List<String> v => _prefs.setStringList(key, v),
    _ => throw ArgumentError(
      'Unsupported type for AppStorage.write: ${value.runtimeType}',
    ),
  };

  @override
  Future<bool> remove(final String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();
}

/// Riverpod provider that exposes a singleton [AppStorage] instance.
///
/// Kept alive for the lifetime of the app.
/// The underlying SharedPreferences instance must be obtained
/// asynchronously; this provider must be overridden at bootstrap.
@Riverpod(keepAlive: true)
AppStorage appStorage(final Ref ref) => throw UnimplementedError(
  'appStorage must be overridden in ProviderScope at bootstrap.',
);
