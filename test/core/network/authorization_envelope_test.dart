import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';

void main() {
  group('isAuthorizationRequiredEnvelope', () {
    test('reconoce el sobre por codigo-respuesta 412.00', () {
      expect(
        isAuthorizationRequiredEnvelope(<String, dynamic>{
          'body': null,
          'mensaje-respuesta': 'No se pudo dar de alta el soporte.',
          'codigo-respuesta': '412.00',
        }),
        isTrue,
      );
    });

    test('reconoce el sobre por codigo-error 3034 dentro de info-error', () {
      expect(
        isAuthorizationRequiredEnvelope(<String, dynamic>{
          'codigo-respuesta': '200.00',
          'info-error': {
            'errores': [
              {'codigo-error': '3034', 'mensaje-error': 'Cuando autorizas a que Espacio Ciudadano…'},
            ],
          },
        }),
        isTrue,
      );
    });

    test('lo reconoce aunque el sobre llegue como cadena JSON anidada', () {
      expect(
        isAuthorizationRequiredEnvelope('{"codigo-respuesta":"412.00"}'),
        isTrue,
      );
    });

    test('no depende del mensaje del endpoint de soporte', () {
      // El `mensaje-respuesta` es ruido reutilizado: un 500 con ese mismo texto
      // no es una negativa por autorización.
      expect(
        isAuthorizationRequiredEnvelope(<String, dynamic>{
          'mensaje-respuesta': 'No se pudo dar de alta el soporte.',
          'codigo-respuesta': '500.00',
        }),
        isFalse,
      );
    });

    test('no reconoce respuestas correctas ni errores internos', () {
      expect(isAuthorizationRequiredEnvelope(<String, dynamic>{'codigo-respuesta': '200.00', 'info-error': null}), isFalse);
      expect(
        isAuthorizationRequiredEnvelope(<String, dynamic>{
          'codigo-respuesta': '500.00',
          'info-error': {
            'errores': [
              {'codigo-error': '0000'},
            ],
          },
        }),
        isFalse,
      );
    });

    test('tolera cargas que no son un sobre', () {
      expect(isAuthorizationRequiredEnvelope(null), isFalse);
      expect(isAuthorizationRequiredEnvelope('no soy json'), isFalse);
      expect(isAuthorizationRequiredEnvelope(<dynamic>[]), isFalse);
      expect(isAuthorizationRequiredEnvelope(42), isFalse);
    });
  });
}
