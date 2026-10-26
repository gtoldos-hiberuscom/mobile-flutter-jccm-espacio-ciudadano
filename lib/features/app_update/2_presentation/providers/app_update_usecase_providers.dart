import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/check_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/ignore_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_repository_providers.dart';

/// DI composition for [CheckAppUpdateUsecase].
final checkAppUpdateUsecaseProvider = Provider<CheckAppUpdateUsecase>(
  (final ref) => CheckAppUpdateUsecase(
    decisions: ref.watch(appUpdateRepositoryProvider),
    installedVersions: ref.watch(installedVersionRepositoryProvider),
    preferences: ref.watch(appUpdatePreferencesRepositoryProvider),
  ),
);

/// DI composition for [IgnoreAppUpdateUsecase].
final ignoreAppUpdateUsecaseProvider = Provider<IgnoreAppUpdateUsecase>(
  (final ref) => IgnoreAppUpdateUsecase(ref.watch(appUpdatePreferencesRepositoryProvider)),
);
