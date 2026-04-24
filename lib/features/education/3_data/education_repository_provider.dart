import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/education_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'education_repository_provider.g.dart';

/// DI composition for [EducationRepository].
@riverpod
EducationRepository educationRepository(final Ref ref) => const EducationRepositoryImpl();
