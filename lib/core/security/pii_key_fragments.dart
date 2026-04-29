/// Single source of truth for PII key fragments used by all sinks
/// (logging, analytics adapters) when redacting structured payloads.
///
/// Matching is case-insensitive **substring on the key only** — values
/// are never inspected. Any payload entry whose key contains one of
/// these fragments must have its value replaced with [redactedMarker]
/// before reaching any external sink.
///
/// Updated from `docs/security/pii-inventory.md` RED/AMBER classifications.
library;

/// Lower-case fragments matched as substrings against payload keys.
const List<String> piiKeyFragments = <String>[
  'token',
  'id',
  'name',
  'dni',
  'nss',
  'plate',
  'license',
  'matricula',
];

/// Literal value substituted in for any redacted entry.
const String redactedMarker = '[REDACTED]';

/// Returns `true` when [key] should be considered PII according to
/// [piiKeyFragments].
bool isPiiKey(final String key) {
  final lower = key.toLowerCase();
  return piiKeyFragments.any(lower.contains);
}

/// Returns a copy of [raw] with the values of any PII-keyed entries
/// replaced by [redactedMarker]. Keys are preserved so the structure
/// remains observable.
///
/// Non-PII entries are passed through unchanged. Nested maps are
/// **not** descended into — callers are expected to pre-flatten any
/// nested structures before invoking this function.
Map<String, Object?> redactFields(final Map<String, Object?> raw) {
  return <String, Object?>{
    for (final entry in raw.entries) entry.key: isPiiKey(entry.key) ? redactedMarker : entry.value,
  };
}
