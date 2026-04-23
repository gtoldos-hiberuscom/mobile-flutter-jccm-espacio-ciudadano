import 'package:jccm_espacio_ciudadano/features/social_welfare/1_domain/social_welfare_repository.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/3_data/social_welfare_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'social_welfare_repository_provider.g.dart';

@riverpod
SocialWelfareRepository socialWelfareRepository(final Ref ref) =>
    const SocialWelfareRepositoryImpl();
