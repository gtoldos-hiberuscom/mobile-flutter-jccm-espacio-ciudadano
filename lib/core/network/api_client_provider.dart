import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/logging/logger_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

/// Riverpod provider that exposes the singleton [Dio] HTTP client.
///
/// The [Dio] instance is kept alive for the lifetime of the app and is
/// configured via [appConfigProvider] and [authSessionProvider].
///
/// ```dart
/// final dio = ref.watch(dioProvider);
/// final response = await dio.get('/citizen/notifications');
/// ```
@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);
  return buildDioClient(
    config: config,
    tokenGetter: () => ref.read(authSessionProvider)?.accessToken,
    logger: logger,
  );
}
