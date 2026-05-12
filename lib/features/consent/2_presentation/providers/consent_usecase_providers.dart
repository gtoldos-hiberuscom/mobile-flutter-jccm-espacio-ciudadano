import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/accept_consent_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_consent_required_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/load_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_repository_provider.dart';

final checkConsentRequiredUsecaseProvider =
    Provider<CheckConsentRequiredUsecase>((final ref) {
  return CheckConsentRequiredUsecase(
    ref.watch(consentRepositoryProvider),
  );
});

final loadClausesUsecaseProvider = Provider<LoadClausesUsecase>((final ref) {
  return LoadClausesUsecase(ref.watch(consentRepositoryProvider));
});

final acceptConsentUsecaseProvider =
    Provider<AcceptConsentUsecase>((final ref) {
  return AcceptConsentUsecase(ref.watch(consentRepositoryProvider));
});
