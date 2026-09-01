/// Redacción de datos para trazas.
///
/// El criterio es **lista blanca**: solo se imprime el valor de las claves
/// técnicas conocidas y todo lo demás se enmascara. Con la lista negra anterior
/// (`token`, `dni`, `nif`, `email`…) salían en claro `nombre`, `apellidos`,
/// `direccion`, el CIP sanitario, el número de un título de familia numerosa o
/// el base64 de un carné — datos personales y, en varios casos, de categoría
/// especial (salud, discapacidad).
///
/// Se conservan las claves y la forma del árbol (mapas, listas y su longitud):
/// es lo que hace falta para depurar el contrato de un endpoint, y no es
/// información personal.
library;

import 'dart:convert';

const String redactedPlaceholder = '***';

/// Claves cuyo valor puede imprimirse: códigos de respuesta, estados,
/// metadatos de paginación y campos estructurales del sobre de la fachada.
/// Ninguna identifica a una persona. Ante la duda, no se añade.
const Set<String> loggableKeys = {
  // Sobre genérico de la fachada
  'codigo-respuesta',
  'mensaje-respuesta',
  'timestamp',
  'info-error',
  'estado',
  'resul',
  'mensaje',
  'code',
  'status',
  'error',
  'error_description',
  'message',
  // Cabeceras técnicas
  'content-type',
  'accept',
  'content-length',
  // Paginación
  'page',
  'size',
  'total',
  'totalelements',
  'totalpages',
  'numberofelements',
  'number',
  'first',
  'last',
  'empty',
  // Metadatos de negocio no identificativos
  'orden',
  'tamano',
  'tamanobytes',
  'tamaniobytes',
  'idficha',
  'tipoproc',
  'tipoprocedimiento',
  'tipodoc',
  'tipoenvio',
  'categoria',
  'algoritmo',
  'origen',
  'sistema',
  'sistemaorigen',
  'sisorigen',
  'aplicacion',
  'tipoentidad',
  'fecha-cambio',
};

/// Prepara [value] para una traza: claves y estructura intactas, valores
/// enmascarados salvo los de [loggableKeys].
///
/// Una cadena en la raíz se intenta decodificar como JSON (varios endpoints
/// responden el sobre como texto plano) para poder redactarla por dentro; si no
/// es JSON se enmascara indicando su longitud, que es lo único útil de un
/// cuerpo opaco (por ejemplo el base64 de un PDF).
Object? redactForLog(final Object? value) => _redact(value, isRoot: true);

Object? _redact(final Object? value, {final bool isRoot = false}) {
  if (value is Map) {
    return value.map((final key, final nested) {
      final keyText = key.toString().toLowerCase();
      if (nested is Map || nested is Iterable) {
        // La estructura no es dato personal: se sigue recorriendo.
        return MapEntry(key, _redact(nested));
      }
      if (loggableKeys.contains(keyText)) {
        return MapEntry(key, nested);
      }
      return MapEntry(key, redactedPlaceholder);
    });
  }
  if (value is Iterable) {
    return value.map(_redact).toList(growable: false);
  }
  if (value is String && isRoot) {
    final decoded = _tryDecodeJson(value);
    if (decoded != null) {
      return _redact(decoded);
    }
    return '$redactedPlaceholder(${value.length} chars)';
  }
  if (isRoot && value != null && value is! num && value is! bool) {
    return redactedPlaceholder;
  }
  return value;
}

Object? _tryDecodeJson(final String value) {
  final trimmed = value.trim();
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) {
    return null;
  }
  try {
    return jsonDecode(trimmed);
  } on FormatException {
    return null;
  }
}

/// Documento de una persona (DNI/NIE/CIF) listo para una traza: se conservan
/// los tres últimos caracteres, suficiente para correlacionar peticiones sin
/// registrar el documento completo.
String maskedDocument(final String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return redactedPlaceholder;
  }
  if (trimmed.length <= 3) {
    return redactedPlaceholder;
  }
  return '$redactedPlaceholder${trimmed.substring(trimmed.length - 3)}';
}

/// `idunico` de una transacción de aportación (`{documento}_{timestamp}`) con
/// el documento enmascarado: el timestamp se conserva porque es lo que permite
/// seguir la transacción en los logs y no identifica a nadie.
String maskedIdUnico(final String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return redactedPlaceholder;
  }
  final separator = trimmed.indexOf('_');
  if (separator <= 0) {
    return maskedDocument(trimmed);
  }
  return '${maskedDocument(trimmed.substring(0, separator))}${trimmed.substring(separator)}';
}
