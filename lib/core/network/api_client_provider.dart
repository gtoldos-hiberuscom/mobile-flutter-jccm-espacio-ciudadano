import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

final dioProvider = Provider<Dio>((final ref) {
  final config = ref.watch(appConfigProvider);
  final dio = buildDioClient(
    config: config,
    tokenGetter: () => ref.read(tokenResponseProvider)?.accessToken,
    // `force: false` on the first attempt so a 401 that lands after a peer (the
    // guard or an earlier 401) already renewed the token retries with the fresh
    // token instead of triggering another refresh. `AuthRefreshInterceptor`
    // escalates to `force: true` when the refreshed token is identical to the
    // one the server just rejected (revoked session / clock skew), so that path
    // ends in a clean logout rather than a reused stale token.
    // `AuthSessionController.refresh` de-dupes genuinely concurrent refreshes
    // via its single-flight guard.
    refreshSession: ({final bool force = false}) => ref.read(authSessionControllerProvider).refresh(force: force),
  );
  if (ref.watch(demoModeProvider)) {
    // Modo demostración: mismo Dio, mismos interceptores, pero el transporte
    // resuelve contra el backend ficticio en memoria. Al cambiar los claims
    // (entrar o cerrar sesión) este provider se reconstruye y con él los
    // repositorios que lo observan, así que el backend demo nace y muere con
    // la sesión demo.
    dio.httpClientAdapter = DemoHttpClientAdapter(DemoBackend.seeded(storage: ref.read(appStorageProvider), now: DateTime.now));
  }
  return dio;
});
