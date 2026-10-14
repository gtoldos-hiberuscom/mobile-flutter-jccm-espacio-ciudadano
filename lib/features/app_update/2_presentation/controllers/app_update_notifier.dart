import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_info.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/check_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/usecases/ignore_app_update_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_repository_providers.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_usecase_providers.dart';
import 'package:meta/meta.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class AppUpdateState {
  const AppUpdateState();
}

/// No hay aviso que mostrar.
final class AppUpdateHidden extends AppUpdateState {
  const AppUpdateHidden();
}

/// El aviso está en pantalla; [storeOpenFailed] enseña el error de tienda.
@immutable
final class AppUpdateVisible extends AppUpdateState {
  const AppUpdateVisible({required this.info, this.storeOpenFailed = false});

  final AppUpdateInfo info;
  final bool storeOpenFailed;

  AppUpdateVisible copyWith({final bool? storeOpenFailed}) => AppUpdateVisible(
    info: info,
    storeOpenFailed: storeOpenFailed ?? this.storeOpenFailed,
  );

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AppUpdateVisible && runtimeType == other.runtimeType && info == other.info && storeOpenFailed == other.storeOpenFailed;

  @override
  int get hashCode => Object.hash(info, storeOpenFailed);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Comprueba si hay que avisar de una actualización al arrancar y cada vez que
/// la app vuelve de segundo plano, y gobierna el aviso.
///
/// Fail-open: si la comprobación falla no se toca el estado (nada aparece y,
/// si ya había una forzada en pantalla, se queda).
class AppUpdateNotifier extends Notifier<AppUpdateState> {
  bool _checking = false;
  AppVersion? _dismissedInSession;

  @override
  AppUpdateState build() {
    final resumed = ref.watch(appResumedFromBackgroundProvider).listen((final _) => unawaited(check()));
    ref.onDispose(() => unawaited(resumed.cancel()));
    unawaited(Future.microtask(check));
    return const AppUpdateHidden();
  }

  /// Lanza una comprobación; las que se solapan se descartan.
  Future<void> check() async {
    if (_checking) {
      return;
    }
    _checking = true;
    try {
      final result = await ref.read(checkAppUpdateUsecaseProvider).execute();
      if (!ref.mounted) {
        return;
      }
      switch (result) {
        case UpdateNotRequired():
          state = const AppUpdateHidden();
        case UpdateAvailable(:final info):
          if (!info.isForced && info.latestVersion == _dismissedInSession) {
            logger.d('[app_update] recomendada ${info.latestVersion} ya descartada en esta sesión');
            return;
          }
          if (state case AppUpdateVisible(info: final current) when current == info) {
            return;
          }
          logger.i('[app_update] aviso ${info.policy.name} para ${info.latestVersion}');
          state = AppUpdateVisible(info: info);
        case CheckAppUpdateFailed(:final message, :final cause):
          logger.w('[app_update] comprobación no disponible: $message', error: cause);
      }
    } finally {
      _checking = false;
    }
  }

  /// «Ahora no»: solo para una recomendada. Oculta el aviso y recuerda la
  /// versión para no repetirlo.
  Future<void> dismiss() async {
    final current = state;
    if (current is! AppUpdateVisible || current.info.isForced) {
      return;
    }
    final version = current.info.latestVersion;
    _dismissedInSession = version;
    state = const AppUpdateHidden();
    logger.i('[app_update] recomendada $version descartada por el usuario');

    final result = await ref.read(ignoreAppUpdateUsecaseProvider).execute(version: version);
    if (result case IgnoreAppUpdateFailed(:final message, :final cause)) {
      logger.w('[app_update] no se pudo guardar la versión ignorada: $message', error: cause);
    }
  }

  /// «Actualizar»: abre la tienda. El aviso no se cierra: tras instalar, el
  /// sistema reinicia la app.
  Future<void> openStore() async {
    final current = state;
    if (current is! AppUpdateVisible) {
      return;
    }
    bool opened;
    try {
      opened = await ref.read(appStoreLauncherProvider).openStore();
    } on Object catch (error, stackTrace) {
      // El lanzador no lanza, pero construirlo lee la configuración
      // (`APP_STORE_ID`): un fallo ahí debe acabar en el texto de error del
      // aviso, no en un error sin capturar.
      logger.e('[app_update] no se pudo preparar la apertura de la tienda', error: error, stackTrace: stackTrace);
      opened = false;
    }
    if (!ref.mounted) {
      return;
    }
    if (opened) {
      logger.i('[app_update] tienda abierta');
    }
    final latest = state;
    if (latest is AppUpdateVisible && latest.storeOpenFailed != !opened) {
      state = latest.copyWith(storeOpenFailed: !opened);
    }
  }
}

final appUpdateProvider = NotifierProvider<AppUpdateNotifier, AppUpdateState>(AppUpdateNotifier.new);
