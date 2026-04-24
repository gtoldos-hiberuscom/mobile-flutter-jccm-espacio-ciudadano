import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'casework_repository_provider.g.dart';

/// DI composition for [CaseworkRepository].
@riverpod
CaseworkRepository caseworkRepository(final Ref ref) =>
    const CaseworkRepositoryImpl();
