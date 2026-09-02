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
