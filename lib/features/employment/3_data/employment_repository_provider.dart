import 'package:jccm_espacio_ciudadano/features/employment/1_domain/employment_repository.dart';
import 'package:jccm_espacio_ciudadano/features/employment/3_data/employment_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employment_repository_provider.g.dart';

@riverpod
EmploymentRepository employmentRepository(final Ref ref) =>
    const EmploymentRepositoryImpl();
