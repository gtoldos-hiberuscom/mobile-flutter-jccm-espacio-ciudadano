import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/intermediacion_response.dart';

/// Locks the three-state contract of the shared intermediación response
/// handler: 404 → null, authorization refusal → typed exception, anything
/// else → the transport error propagates (never "no data").
void main() {
  group('intermediacionRawResponse', () {
    test('404 means the organism has no data', () async {
      expect(await intermediacionRawResponse(() => throw _dioError(404, null)), isNull);
    });

    test('an error body carrying 412.00 becomes MyDataAuthorizationRequired', () async {
      await expectLater(
        intermediacionRawResponse(() => throw _dioError(412, {'codigo-respuesta': '412.00'})),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('an error body carrying codigo-error 3034 becomes MyDataAuthorizationRequired', () async {
      await expectLater(
        intermediacionRawResponse(
          () => throw _dioError(400, {
            'codigo-respuesta': '400.00',
            'info-error': {
              'errores': [
                {'codigo-error': '3034'},
              ],
            },
          }),
        ),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('a 2xx envelope carrying 412.00 also becomes MyDataAuthorizationRequired', () async {
      await expectLater(
        intermediacionRawResponse(() async => {'codigo-respuesta': '412.00'}),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('a 500 with a generic error body propagates the DioException', () async {
      await expectLater(
        intermediacionRawResponse(() => throw _dioError(500, {'codigo-respuesta': '500.00', 'mensaje-respuesta': 'Error'})),
        throwsA(isA<DioException>()),
      );
    });

    test('a transport failure without response propagates', () async {
      await expectLater(
        intermediacionRawResponse(() => throw _dioError(null, null)),
        throwsA(isA<DioException>()),
      );
    });

    test('a genuine payload passes through untouched', () async {
      final payload = {
        'codigo-respuesta': '200.00',
        'body': {'resul': '0'},
      };
      expect(await intermediacionRawResponse(() async => payload), same(payload));
    });
  });

  group('isHandledIntermediacionStatus', () {
    test('acepta 2xx, la negativa de autorización y la ausencia de datos', () {
      expect(isHandledIntermediacionStatus(200), isTrue);
      expect(isHandledIntermediacionStatus(204), isTrue);
      expect(isHandledIntermediacionStatus(403), isTrue);
      expect(isHandledIntermediacionStatus(404), isTrue);
    });

    test('rechaza los 3xx: una redirección no es un dato de negocio', () {
      // Un 302 de portal cautivo o del gateway entraba por la rama «manejada»
      // y su HTML se decodificaba a null, es decir, a «sin datos» (R-19).
      expect(isHandledIntermediacionStatus(301), isFalse);
      expect(isHandledIntermediacionStatus(302), isFalse);
      expect(isHandledIntermediacionStatus(304), isFalse);
    });

    test('rechaza el resto para que salga como DioException', () {
      expect(isHandledIntermediacionStatus(400), isFalse);
      expect(isHandledIntermediacionStatus(401), isFalse);
      expect(isHandledIntermediacionStatus(429), isFalse);
      expect(isHandledIntermediacionStatus(500), isFalse);
      expect(isHandledIntermediacionStatus(null), isFalse);
    });
  });
}

DioException _dioError(final int? statusCode, final Object? data) {
  final requestOptions = RequestOptions(path: '/x');
  return DioException(
    requestOptions: requestOptions,
    type: statusCode == null ? DioExceptionType.connectionTimeout : DioExceptionType.badResponse,
    response: statusCode == null
        ? null
        : Response<Object?>(
            requestOptions: requestOptions,
            statusCode: statusCode,
            data: data,
          ),
  );
}
