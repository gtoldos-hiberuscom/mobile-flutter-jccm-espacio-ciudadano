import 'dart:convert';

/// Normaliza el sobre de respuesta de la API a un mapa.
///
/// Todas las operaciones devuelven `{ body, timestamp, mensaje-respuesta,
/// codigo-respuesta, info-error }`, pero el backend lo ha entregado en
/// ocasiones como cadena JSON, incluso anidada, de ahí el desempaquetado
/// iterativo. Devuelve `null` cuando la carga no es un objeto.
Map<String, dynamic>? decodeApiEnvelope(final Object? data) {
  Object? current = data;
  for (var attempt = 0; attempt < 3; attempt++) {
    if (current is Map<String, dynamic>) {
      return current;
    }
    if (current is Map<dynamic, dynamic>) {
      return <String, dynamic>{
        for (final entry in current.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    if (current is! String) {
      return null;
    }
    final trimmed = current.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    try {
      current = jsonDecode(trimmed);
    } on FormatException {
      return null;
    }
  }
  return null;
}
