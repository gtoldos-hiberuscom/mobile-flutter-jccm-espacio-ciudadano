// lib/core/network/generated_api_wrapper.dart
//
// Abstract base class for all feature 3_data/api/ wrappers that adapt the
// generated Dio client into domain-safe Result<T> calls.
//
// Rules enforced by this layer:
//   • Generated API classes are ONLY instantiated inside 3_data/api/
//   • DTOs from generated/ MUST NOT cross the 3_data/ boundary
//   • Callers always receive Result<T>; exceptions never escape
//   • Null / empty responses are surfaced as NotFoundError, never as null
//   • String responses (raw content) are threaded through as Result<String>
//   • Binary (Uint8List) responses are threaded through as Result<Uint8List>
//
// Usage pattern in a feature:
//
//   // lib/features/publicacion/3_data/api/publicacion_api_wrapper.dart
//   class PublicacionApiWrapper extends GeneratedApiWrapper {
//     PublicacionApiWrapper(this._api) : super();
//
//     final PublicacionApi _api;
//
//     Future<Result<ZCSRFCPUBLISELECTBYNIFResponse>> miDetalleOperation(
//       DTQUERY body,
//     ) =>
//         safeCall(() => _api.miDetalleOperation(dTQUERYBody: body));
//   }

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';

/// Abstract base that every feature-level generated-API wrapper must extend.
///
/// Subclasses live in `lib/features/<feature>/3_data/api/` and hold a
/// reference to the concrete generated API class (e.g. `PublicacionApi`).
/// They expose public methods that delegate to [safeCall] so that all
/// error-handling logic is centralised here.
abstract base class GeneratedApiWrapper {
  const GeneratedApiWrapper();

  // ── Core adapter ───────────────────────────────────────────────────────────

  /// Executes [call] and maps the outcome to [Result].
  ///
  /// Covers:
  ///   • Successful responses → [Success] carrying the unwrapped [T].
  ///   • Null `.data` on a 2xx response → [Failure] with [NotFoundError].
  ///   • [DioException] with a typed [AppError] already set by the
  ///     `ErrorInterceptor` → [Failure] re-wrapping that error.
  ///   • Any other exception → [Failure] with [UnknownError].
  ///
  /// Type parameter [T] is the *response body* type emitted by the generated
  /// client (e.g. `ZCSRFCPUBLISELECTBYNIFResponse`, `String`, `Uint8List`).
  Future<Result<T>> safeCall<T>(
    final Future<Response<T>> Function() call,
  ) async {
    try {
      final response = await call();
      final data = response.data;

      if (data == null) {
        return Failure<T>(
          NotFoundError(
            message:
                'Empty response body for ${response.requestOptions.path}',
          ),
        );
      }

      return Success<T>(data);
    } on DioException catch (e) {
      final embeddedError = e.error;
      if (embeddedError is AppError) {
        // ErrorInterceptor already classified the error – reuse it directly.
        return Failure<T>(embeddedError);
      }
      // Fallback: classify from status code if interceptor did not fire.
      return Failure<T>(_mapDioExceptionFallback(e));
    } catch (e) {
      return Failure<T>(
        UnknownError(message: 'Unexpected error: $e'),
      );
    }
  }

  // ── String-content specialisation ──────────────────────────────────────────

  /// Convenience wrapper for endpoints that return raw [String] payloads.
  ///
  /// Semantically identical to [safeCall] but makes the intent explicit at
  /// the call-site, preventing accidental `.toString()` coercions.
  ///
  /// Applies to:
  ///   • `SescamApi.citasFuturas`, `citasPasadas`, `getCipFromNif`
  ///   • `CarnetDigitalApi.obtenerDatosFamiliaNumerosa` (overloads 1 & 2)
  ///   • `CarnetDigitalApi.obtenerPdf`, `obtenerPkPass`,
  ///     `obtenerPkPassFamiliaNumerosa1`
  ///   • `IntermediacionApi.obtenerDatosFamiliaNumerosa`
  Future<Result<String>> safeStringCall(
    final Future<Response<String>> Function() call,
  ) =>
      safeCall<String>(call);

  // ── Binary-content specialisation ──────────────────────────────────────────

  /// Convenience wrapper for endpoints that return binary [List<int>] payloads
  /// (e.g. `DocumentacionApi.registrarFicheroOperation` → `Uint8List`).
  ///
  /// The caller is responsible for casting to `Uint8List` if required; the
  /// wrapper only guarantees the bytes are non-null.
  Future<Result<List<int>>> safeBinaryCall(
    final Future<Response<List<int>>> Function() call,
  ) =>
      safeCall<List<int>>(call);

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Fallback classifier used when the `ErrorInterceptor` was not in the chain
  /// or did not annotate the exception with a typed [AppError].
  AppError _mapDioExceptionFallback(final DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
        return NetworkError(
          message: 'Connection problem: ${e.message ?? e.type.name}',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return switch (statusCode) {
          401 => const UnauthorizedError(),
          404 => NotFoundError(
              message:
                  'Resource not found (404): ${e.requestOptions.path}',
            ),
          _ => NetworkError(
              message:
                  'Server error ${statusCode ?? 'unknown'}: ${e.message ?? ''}',
              statusCode: statusCode,
            ),
        };

      case DioExceptionType.cancel:
        return const UnknownError(message: 'Request was cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return UnknownError(
          message: e.message ?? 'An unexpected error occurred',
        );
    }
  }
}
