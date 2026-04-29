import 'package:jccm_espacio_ciudadano/features/casework/registro/1_domain/registro_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/3_data/registro_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registro_repository_provider.g.dart';

/// DI composition for the STORY-36 [RegistroRepository].
@Riverpod(keepAlive: true)
RegistroRepository registroRepository(final Ref ref) => const RegistroRepositoryImpl();
