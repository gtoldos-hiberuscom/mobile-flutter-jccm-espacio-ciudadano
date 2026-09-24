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
import 'package:flutter/foundation.dart';

const String redactedPlaceholder = '***';

const bool _redactionDisabledByEnv = bool.fromEnvironment('LOG_REDACTION_OFF');

/// Desactiva la redacción para poder depurar contra los entornos de prueba.
///
/// Lo declaran los `config_*.json`, que `--dart-define-from-file` inyecta como
/// dart-defines: `true` en development y preproduction (apuntan a UAT y pre,
/// con usuarios de prueba) y `false` en production. Se puede forzar en una
/// ejecución suelta con `--dart-define=LOG_REDACTION_OFF=true`.
///
/// **No pasa por `AppConfig`** a propósito, y va conjugada con [kDebugMode],
/// que es `const false` en release y profile: allí la constante es falsa y la
/// rama desaparece en compilación, así que ningún build de tiendas puede
/// quedarse sin redactar por lo que diga un fichero de configuración.
const bool logRedactionDisabled = kDebugMode && _redactionDisabledByEnv;

/// Claves cuyo valor puede imprimirse: códigos de respuesta, estados,
/// metadatos de paginación y campos estructurales del sobre de la fachada.
/// Ninguna identifica a una persona. Ante la duda, no se añade.
const Set<String> loggableKeys = {
  // Sobre genérico de la fachada
  'codigo-respuesta',
  // El discriminador del sobre de autorización (p. ej. `3034`). Es numérico y
  // sin él la traza dice que falta autorización sin decir por qué (LG-2).
  'codigo-error',
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
/// Con [logRedactionDisabled] puesto no enmascara nada — solo para depurar en
/// local.
Object? redactForLog(final Object? value) {
  // Los clientes Dio con ResponseType.bytes entregan Uint8List. Volcarla
  // completa genera miles de números por cada PDF o imagen y puede bloquear
  // la consola, incluso cuando la redacción está desactivada en desarrollo.
  if (value is Uint8List) {
    return '<binary: ${value.length} bytes>';
  }
  return _redact(value, isRoot: true);
}

Object? _redact(final Object? value, {final bool isRoot = false, final bool loggableContext = false}) {
  if (logRedactionDisabled) {
    return value;
  }
  if (value is Map) {
    return value.map((final key, final nested) {
      final keyText = key.toString().toLowerCase();
      final loggable = loggableKeys.contains(keyText);
      if (nested is Map || nested is Iterable) {
        // La estructura no es dato personal: se sigue recorriendo. El contexto
        // de la clave baja con la recursión para que una lista de escalares
        // bajo una clave blanca (`info-error`…) siga imprimiéndose.
        return MapEntry(key, _redact(nested, loggableContext: loggable));
      }
      if (loggable) {
        return MapEntry(key, nested);
      }
      return MapEntry(key, redactedPlaceholder);
    });
  }
  if (value is Iterable) {
    // Un escalar dentro de una lista no tiene clave propia: hereda la de la
    // lista. Sin esto, los String de una lista salían en claro por no ser raíz
    // y no consultar la lista blanca (LG-1).
    return value.map((final element) => element is Map || element is Iterable ? _redact(element, loggableContext: loggableContext) : _redactScalar(element, loggableContext: loggableContext)).toList(growable: false);
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

/// Escalar sin clave propia (elemento de lista): se imprime si el contexto es
/// una clave de [loggableKeys], y si no se enmascara. Los números y booleanos
/// se conservan, igual que en la raíz: no identifican a nadie por sí mismos.
Object? _redactScalar(final Object? value, {required final bool loggableContext}) {
  if (value == null || value is num || value is bool || loggableContext) {
    return value;
  }
  return redactedPlaceholder;
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
