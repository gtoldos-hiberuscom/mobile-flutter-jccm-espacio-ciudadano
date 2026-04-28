import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/auth/clave_auth_remote_datasource.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';

final claveAuthRemoteDatasourceProvider = Provider<ClaveAuthRemoteDatasource>(
  (final ref) {
    return FlutterAppAuthClaveAuthRemoteDatasource(
      config: ref.watch(appConfigProvider),
      dio: ref.watch(dioProvider),
    );
  },
);
