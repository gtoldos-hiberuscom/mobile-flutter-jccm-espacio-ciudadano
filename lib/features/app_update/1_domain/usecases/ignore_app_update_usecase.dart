import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class IgnoreAppUpdateResult {
  const IgnoreAppUpdateResult();
}

final class IgnoreAppUpdateSaved extends IgnoreAppUpdateResult {
  const IgnoreAppUpdateSaved();
}

final class IgnoreAppUpdateFailed extends IgnoreAppUpdateResult {
  const IgnoreAppUpdateFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Recuerda que el ciudadano descartó una actualización recomendada para no volver a incomodarle con ella.
final class IgnoreAppUpdateUsecase {
  const IgnoreAppUpdateUsecase(this._preferences);

  final AppUpdatePreferencesRepository _preferences;

  Future<IgnoreAppUpdateResult> execute({required final AppVersion version}) async {
    try {
      await _preferences.saveIgnoredVersion(version);
      return const IgnoreAppUpdateSaved();
    } on Object catch (e) {
      return IgnoreAppUpdateFailed(message: e.toString(), cause: e);
    }
  }
}
