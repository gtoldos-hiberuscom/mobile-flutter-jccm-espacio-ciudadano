import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

/// Riverpod provider that exposes the singleton [Dio] HTTP client.
///
/// The [Dio] instance is kept alive for the lifetime of the app and is
/// configured via [appConfigProvider] and [secureStorageProvider].
///
/// Consumers in the `3_data/` layer inject this provider to perform HTTP
/// requests without depending on Dio construction details.
///
/// ```dart
/// final dio = ref.watch(dioProvider);
/// final response = await dio.get('/citizen/notifications');
/// ```
@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(secureStorageProvider);
  return buildDioClient(config: config, secureStorage: storage);
}
