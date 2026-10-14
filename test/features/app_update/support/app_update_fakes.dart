import 'dart:async';

import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/domain.dart';

/// Decisión de prueba del servidor de versiones. Por defecto recomienda la
/// `2.0.0`.
AppUpdateDecision buildDecision({
  final UpdatePolicy policy = UpdatePolicy.recommended,
  final String? published = '2.0.0',
  final String? message,
}) => AppUpdateDecision(
  policy: policy,
  publishedVersion: AppVersion.tryParse(published),
  message: message,
);

final class FakeAppUpdateRepository implements AppUpdateRepository {
  FakeAppUpdateRepository({this.decision, this.error});

  AppUpdateDecision? decision;
  Exception? error;
  int calls = 0;
  String? lastApplicationId;
  AppVersion? lastInstalledVersion;

  /// Si se fija, cada petición espera a que se complete (para probar solapes).
  Completer<void>? gate;

  @override
  Future<AppUpdateDecision> fetchDecision({
    required final String applicationId,
    required final AppVersion installedVersion,
  }) async {
    calls++;
    lastApplicationId = applicationId;
    lastInstalledVersion = installedVersion;
    final pending = gate;
    if (pending != null) {
      await pending.future;
    }
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    final result = decision;
    if (result == null) {
      throw StateError('FakeAppUpdateRepository without decision');
    }
    return result;
  }
}

final class FakeInstalledVersionRepository implements InstalledVersionRepository {
  FakeInstalledVersionRepository(this.version, {this.applicationIdValue = 'es.jccm.espaciociudadano', this.error});

  AppVersion version;
  String applicationIdValue;
  Exception? error;

  @override
  Future<AppVersion> installedVersion() async {
    _throwIfFailing();
    return version;
  }

  @override
  Future<String> applicationId() async {
    _throwIfFailing();
    return applicationIdValue;
  }

  void _throwIfFailing() {
    final failure = error;
    if (failure != null) {
      throw failure;
    }
  }
}

final class FakeAppUpdatePreferencesRepository implements AppUpdatePreferencesRepository {
  FakeAppUpdatePreferencesRepository({this.ignored, this.saveError});

  AppVersion? ignored;
  Exception? saveError;
  final List<AppVersion> saved = [];

  @override
  Future<AppVersion?> readIgnoredVersion() async => ignored;

  @override
  Future<void> saveIgnoredVersion(final AppVersion version) async {
    final failure = saveError;
    if (failure != null) {
      throw failure;
    }
    saved.add(version);
    ignored = version;
  }
}

final class FakeAppStoreLauncher implements AppStoreLauncher {
  FakeAppStoreLauncher({this.result = true});

  bool result;
  Exception? error;
  int opened = 0;

  @override
  Future<bool> openStore() async {
    opened++;
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return result;
  }
}

final class MemoryAppStorage implements AppStorage {
  MemoryAppStorage({this.failWrites = false});

  final bool failWrites;
  final Map<String, Object> values = {};

  @override
  T? read<T>(final String key) => values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    if (failWrites) {
      return false;
    }
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    values.clear();
    return true;
  }
}
