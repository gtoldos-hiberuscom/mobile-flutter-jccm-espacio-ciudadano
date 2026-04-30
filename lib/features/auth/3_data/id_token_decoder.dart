import 'dart:convert';

/// Pure-Dart, signature-less decoder for the payload of a compact JWT
/// (`header.payload.signature`).
///
/// Stays in `3_data/` — it is a transport-format helper, not a domain
/// abstraction. It does NOT verify the signature: the token is consumed
/// after the OIDC library has already validated it end-to-end against the
/// authorization server.
///
/// Returns the payload claims as a `Map<String, dynamic>`, or `null` when
/// the token is malformed or the payload is not a JSON object.
Map<String, dynamic>? decodeIdTokenPayload(final String token) {
  final trimmed = token.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final parts = trimmed.split('.');
  if (parts.length < 2) {
    return null;
  }

  try {
    final normalized = base64Url.normalize(parts[1]);
    final bytes = base64Url.decode(normalized);
    final decoded = json.decode(utf8.decode(bytes));
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map((final key, final value) => MapEntry(key.toString(), value));
    }
    return null;
  } on FormatException {
    return null;
  }
}
