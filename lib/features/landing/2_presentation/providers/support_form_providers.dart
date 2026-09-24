import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/usecases/submit_support_request_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/landing/3_data/support_repository_impl.dart';

final supportRepositoryProvider = Provider<SupportRepository>((final ref) {
  return SupportRepositoryImpl(
    dio: ref.watch(dioProvider),
    authenticatedEndpoint: ref.watch(appConfigProvider).authenticatedSupportUrl,
  );
});

final submitSupportRequestUsecaseProvider = Provider<SubmitSupportRequestUsecase>((final ref) {
  return SubmitSupportRequestUsecase(ref.watch(supportRepositoryProvider));
});
