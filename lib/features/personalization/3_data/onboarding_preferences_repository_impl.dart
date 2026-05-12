import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/onboarding_preferences_repository.dart';

final class OnboardingPreferencesRepositoryImpl
    implements OnboardingPreferencesRepository {
  const OnboardingPreferencesRepositoryImpl(this._storage);
  final AppStorage _storage;

  String _key(final String idAgente) =>
      '${StorageKeys.lifeEventsOnboardingSeenPrefix}$idAgente';

  @override
  Future<bool> hasSeenLifeEventsOnboarding({
    required final String idAgente,
  }) async =>
      _storage.read<bool>(_key(idAgente)) ?? false;

  @override
  Future<void> markLifeEventsOnboardingSeen({
    required final String idAgente,
  }) =>
      _storage.write(_key(idAgente), true);
}
