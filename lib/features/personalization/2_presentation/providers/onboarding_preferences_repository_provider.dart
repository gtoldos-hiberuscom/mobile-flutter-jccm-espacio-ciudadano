import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/onboarding_preferences_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/onboarding_preferences_repository_impl.dart';

final onboardingPreferencesRepositoryProvider =
    Provider<OnboardingPreferencesRepository>((final ref) {
  final storage = ref.watch(appStorageProvider);
  return OnboardingPreferencesRepositoryImpl(storage);
});
