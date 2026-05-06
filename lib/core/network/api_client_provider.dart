import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/token_response_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final config = ref.watch(appConfigProvider);
  return buildDioClient(
    config: config,
    tokenGetter: () => ref.read(tokenResponseProvider)?.accessToken,
  );
}
