import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_impl.dart';

final agendaRepositoryProvider = Provider<AgendaRepository>((final ref) {
  return AgendaRepositoryImpl(dio: ref.watch(dioProvider));
});
