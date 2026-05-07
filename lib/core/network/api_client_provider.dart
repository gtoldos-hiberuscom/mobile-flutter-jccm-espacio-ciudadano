import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/token_response_notifier.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  return buildDioClient(
    config: config,
    tokenGetter: () => ref.read(tokenResponseProvider)?.accessToken,
  );
});
