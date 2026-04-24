import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/3_data/expediente_detail_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expediente_detail_repository_provider.g.dart';

/// DI composition for [ExpedienteDetailRepository] (STORY-35).
@riverpod
ExpedienteDetailRepository expedienteDetailRepository(final Ref ref) =>
    const ExpedienteDetailRepositoryImpl();
