import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/3_data/upload_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_repository_provider.g.dart';

/// DI composition for the STORY-38 [UploadRepository].
@Riverpod(keepAlive: true)
UploadRepository uploadRepository(final Ref ref) => const UploadRepositoryImpl();
