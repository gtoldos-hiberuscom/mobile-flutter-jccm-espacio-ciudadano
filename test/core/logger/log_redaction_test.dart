import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/logger/log_redaction.dart';

void main() {
  // `config_development.json` y `config_preproduction.json` llevan
  // LOG_REDACTION_OFF=true, así que `flutter test --dart-define-from-file=…`
  // desactiva la redacción y estos casos dejarían de tener sentido. Se saltan
  // en vez de fallar: un rojo ahí se lee como una regresión del redactor y no
  // lo es. La suite normal (`flutter test`, y CI) no pasa ningún config y los
  // ejecuta siempre.
  group('redactForLog', skip: logRedactionDisabled ? 'LOG_REDACTION_OFF activo: la redacción está desactivada a propósito' : null, () {
    test('enmascara los valores que no están en la lista blanca', () {
      final redacted = redactForLog({
        'nombre': 'Gonzalo',
        'apellidos': 'Pérez Pérez',
        'direccion': 'Calle Mayor 1',
        'cip': 'ABCD123456789',
        'numeroTitulo': 'FN-2026-0001',
        'codigo-respuesta': '200.00',
        'estado': 'OK',
      });

      expect(redacted, {
        'nombre': redactedPlaceholder,
        'apellidos': redactedPlaceholder,
        'direccion': redactedPlaceholder,
        'cip': redactedPlaceholder,
        'numeroTitulo': redactedPlaceholder,
        // La lista negra anterior dejaba pasar todo lo anterior en claro y solo
        // tapaba token/dni/nif/email/telefono.
        'codigo-respuesta': '200.00',
        'estado': 'OK',
      });
    });

    test('enmascara cabeceras de autorización', () {
      expect(
        redactForLog({'Authorization': 'Bearer eyJhbGciOi…', 'Accept': 'application/json'}),
        {'Authorization': redactedPlaceholder, 'Accept': 'application/json'},
      );
    });

    test('conserva la forma del árbol para poder depurar el contrato', () {
      final redacted = redactForLog({
        'body': {
          'listaTitulos': [
            {'titular': 'Gonzalo', 'estado': 'VIGENTE'},
            {'titular': 'Otra', 'estado': 'CADUCADO'},
          ],
        },
        'codigo-respuesta': '200.00',
      });

      expect(redacted, {
        'body': {
          'listaTitulos': [
            {'titular': redactedPlaceholder, 'estado': 'VIGENTE'},
            {'titular': redactedPlaceholder, 'estado': 'CADUCADO'},
          ],
        },
        'codigo-respuesta': '200.00',
      });
    });

    test('redacta por dentro un sobre que llega como texto plano', () {
      // Varios endpoints responden el sobre como String (`decodeStringResponse`).
      expect(
        redactForLog('{"body":{"nombre":"Gonzalo"},"codigo-respuesta":"500.00"}'),
        {
          'body': {'nombre': redactedPlaceholder},
          'codigo-respuesta': '500.00',
        },
      );
    });

    test('un cuerpo opaco se reduce a su longitud', () {
      expect(redactForLog('JVBERi0xLjQKJeLjz9MKMSAw'), '$redactedPlaceholder(24 chars)');
    });

    test('no toca números ni booleanos en la raíz', () {
      expect(redactForLog(42), 42);
      expect(redactForLog(true), isTrue);
      expect(redactForLog(null), isNull);
    });

    test('enmascara los escalares de una lista bajo clave no blanca', () {
      // Antes de LG-1 un String de una lista salía en claro: no era raíz, así
      // que ni se decodificaba ni se consultaba la lista blanca.
      expect(
        redactForLog({
          'telefonos': ['600111222', '925000000'],
          'codigo-respuesta': '200.00',
        }),
        {
          'telefonos': [redactedPlaceholder, redactedPlaceholder],
          'codigo-respuesta': '200.00',
        },
      );
    });

    test('conserva los escalares de una lista bajo clave blanca', () {
      // El contexto de la clave baja con la recursión: `info-error` es
      // diagnóstico, no dato personal, y sus elementos siguen siendo útiles.
      expect(
        redactForLog({
          'info-error': ['3034', 'cláusula no aceptada'],
        }),
        {
          'info-error': ['3034', 'cláusula no aceptada'],
        },
      );
    });

    test('conserva los números de una lista', () {
      expect(
        redactForLog({
          'paginas': [1, 2, 3],
        }),
        {
          'paginas': [1, 2, 3],
        },
      );
    });

    test('imprime codigo-error, que es el discriminador del sobre de autorización', () {
      // Con `codigo-respuesta: 200.00` y el 3034 dentro de `info-error`, este
      // código era el único rastro de por qué se decidió que falta
      // autorización — y salía enmascarado (LG-2).
      expect(
        redactForLog({'codigo-respuesta': '200.00', 'codigo-error': 3034, 'mensaje-respuesta': 'OK'}),
        {'codigo-respuesta': '200.00', 'codigo-error': 3034, 'mensaje-respuesta': 'OK'},
      );
    });
  });

  group('maskedDocument', () {
    test('conserva solo los tres últimos caracteres', () {
      expect(maskedDocument('03874761C'), '${redactedPlaceholder}61C');
      expect(maskedDocument('  99999999R  '), '${redactedPlaceholder}99R');
    });

    test('no filtra documentos cortos ni vacíos', () {
      expect(maskedDocument('12A'), redactedPlaceholder);
      expect(maskedDocument(''), redactedPlaceholder);
      expect(maskedDocument(null), redactedPlaceholder);
    });
  });

  group('maskedIdUnico', () {
    test('enmascara el documento y conserva el timestamp de correlación', () {
      expect(maskedIdUnico('03874761C_171447919011019'), '${redactedPlaceholder}61C_171447919011019');
    });

    test('sin separador se trata como documento', () {
      expect(maskedIdUnico('03874761C'), '${redactedPlaceholder}61C');
      expect(maskedIdUnico(null), redactedPlaceholder);
    });
  });
}
