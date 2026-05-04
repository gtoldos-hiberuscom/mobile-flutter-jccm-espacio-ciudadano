/// Sprint 7 / STORY-65 — minimal TTL key/value cache.
///
/// In-memory cache keyed by `String`. Each entry has an absolute expiry
/// timestamp; reads past the expiry return `null`. The cache is generic
/// per call-site — adopters wrap with their own typed accessors.
///
/// Persistence is intentionally OUT of scope for this primitive: the
/// citizen-facing app has tight PII constraints (canon §26 / TASK-69), and
/// storing arbitrary feature responses on disk would conflict with them.
/// Features that need persistent caches must justify it in their ticket
/// Notes and use `SecureStorage` for sensitive values or
/// `SharedPreferences` for non-PII metadata explicitly.
final class TtlCache {
  TtlCache({final DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, _Entry> _entries = <String, _Entry>{};

  /// Returns the value if present and not expired, else `null`.
  T? read<T>(final String key) {
    final entry = _entries[key];
    if (entry == null) {
      return null;
    }
    if (entry.expiresAt.isBefore(_clock())) {
      _entries.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  /// Stores [value] under [key] with the given [ttl].
  void write<T>(final String key, final T value, {required final Duration ttl}) {
    _entries[key] = _Entry(value, _clock().add(ttl));
  }

  /// Removes the entry for [key], if any.
  void invalidate(final String key) {
    _entries.remove(key);
  }

  /// Removes all entries whose key starts with [prefix]. Useful when a
  /// feature evicts a whole namespace (e.g., `notifications:*`).
  void invalidatePrefix(final String prefix) {
    _entries.removeWhere((final k, final _) => k.startsWith(prefix));
  }

  /// Removes every entry.
  void clear() => _entries.clear();

  /// For diagnostics only — number of live entries (does not prune).
  int get length => _entries.length;
}

class _Entry {
  _Entry(this.value, this.expiresAt);

  final Object? value;
  final DateTime expiresAt;
}
