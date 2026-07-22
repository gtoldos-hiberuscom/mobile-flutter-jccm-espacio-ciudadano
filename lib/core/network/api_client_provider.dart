import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

final dioProvider = Provider<Dio>((final ref) {
  final config = ref.watch(appConfigProvider);
  return buildDioClient(
    config: config,
    tokenGetter: () => ref.read(tokenResponseProvider)?.accessToken,
    // `force: false` so a 401 that lands after a peer (the guard or an earlier
    // 401) already renewed the token retries with the fresh token instead of
    // triggering another refresh. `AuthSessionController.refresh` de-dupes
    // genuinely concurrent refreshes via its single-flight guard.
    refreshSession: () => ref.read(authSessionControllerProvider).refresh(),
  );
});
