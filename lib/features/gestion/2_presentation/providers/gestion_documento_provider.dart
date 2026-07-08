import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_documento_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_documento_repository_impl.dart';

final gestionDocumentoRepositoryProvider = Provider<GestionDocumentoRepository>((final ref) {
  return GestionDocumentoRepositoryImpl(dio: ref.watch(dioProvider));
});
