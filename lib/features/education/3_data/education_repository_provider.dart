import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/api/educacion_api_wrapper.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/education_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'education_repository_provider.g.dart';

/// DI composition for [EducationRepository].
@riverpod
EducationRepository educationRepository(final Ref ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return EducationRepositoryImpl(
    apiWrapper: EducacionApiWrapper(EducacionApi(dio, standardSerializers)),
    secureStorage: storage,
  );
}
