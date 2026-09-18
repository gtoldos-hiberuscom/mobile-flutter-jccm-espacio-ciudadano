import 'dart:async' show unawaited;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/reset_consent_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/reset_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

// `idAgente` drives consent/life-events/storage; `contactId` is the identifier
// for the `/ciudadanos/{id}` contacto endpoint, which differs per environment
// El gateway usa `sub_alt` en todos los entornos; `contactId` se mantiene
// separado del id de almacenamiento para no mezclar identidad remota y caché.
typedef _PreferencesArgs = ({String idAgente, String contactId});

final _preferencesStateProvider = FutureProvider.autoDispose.family<_PreferencesState, _PreferencesArgs>(
  (final ref, final args) async {
    final appStorage = ref.watch(appStorageProvider);
    final result = await ref
        .watch(checkAcceptedConsentClauseUsecaseProvider)
        .execute(
          idAgente: args.idAgente,
          clauseId: 3,
        );

    final lifeEventsEnabled = switch (result) {
      AcceptedConsentClauseStatus(:final isAccepted) => isAccepted,
      // AsyncError, nunca "disabled": afirmar que la autorización está apagada
      // en la propia pantalla de autorizaciones miente sobre el consentimiento;
      // el ErrorStateWidget con retry de la página pasa a ser alcanzable.
      CheckAcceptedConsentClauseFailed(:final message) => throw StateError(message),
    };
    final selectedLifeEvents = lifeEventsEnabled ? await _selectedLifeEvents(ref, args.idAgente) : const <LifeEvent>[];
    final lifeEventsUpdatedAt = _readLifeEventsUpdatedAt(appStorage, args.idAgente);
    // El contacto es un bloque más de esta pantalla, no su razón de ser: que
    // el servicio falle no puede llevarse por delante la biometría, los hechos
    // vitales, las autorizaciones ni el cierre de sesión, que es lo que pasaba
    // cuando la excepción subía hasta aquí. Gestión ya falla abierto ante este
    // mismo fallo (ver `gestion_page.dart`).
    //
    // El error no se traduce a «sin contacto»: eso le diría al ciudadano que
    // no tiene ningún medio de aviso configurado cuando lo único cierto es que
    // no hemos podido mirarlo. Por eso viaja como estado propio.
    NotificationContact? notificationContact;
    bool notificationContactUnavailable = false;
    try {
      notificationContact = await ref.watch(notificationContactProvider(args.contactId).future);
    } on Object catch (error, stackTrace) {
      logger.e('Notification contact unavailable — failing open', error: error, stackTrace: stackTrace);
      notificationContactUnavailable = true;
    }

    return _PreferencesState(
      biometricEnabled: appStorage.read<bool>('${StorageKeys.biometricQuickAccessEnabledPrefix}${args.idAgente}') ?? false,
      lifeEventsStatus: lifeEventsEnabled
          ? selectedLifeEvents.isNotEmpty
                ? AppPreferenceStatus.enabled
                : AppPreferenceStatus.pending
          : AppPreferenceStatus.disabled,
      selectedLifeEvents: selectedLifeEvents,
      lifeEventsUpdatedAt: lifeEventsUpdatedAt,
      notificationContact: notificationContact,
      notificationContactUnavailable: notificationContactUnavailable,
    );
  },
  name: 'preferencesStateProvider',
);

Future<List<LifeEvent>> _selectedLifeEvents(
  final Ref ref,
  final String idAgente,
) async {
  if (idAgente.isEmpty) {
    return const [];
  }
  final result = await ref.watch(loadLifeEventsUsecaseProvider).execute(idAgente: idAgente);
  return switch (result) {
    LoadLifeEventsSuccess(:final events) => events.where((final event) => event.selected).toList(growable: false),
    // AsyncError, nunca lista vacía: "no has seleccionado temáticas" es una
    // afirmación sobre datos del usuario que un fallo de carga no autoriza.
    LoadLifeEventsFailed(:final message) => throw StateError(message),
  };
}

final class _PreferencesState {
  const _PreferencesState({
    required this.lifeEventsStatus,
    required this.selectedLifeEvents,
    required this.lifeEventsUpdatedAt,
    required this.notificationContact,
    required this.notificationContactUnavailable,
    required this.biometricEnabled,
  });

  final AppPreferenceStatus lifeEventsStatus;
  final List<LifeEvent> selectedLifeEvents;
  final DateTime? lifeEventsUpdatedAt;
  final NotificationContact? notificationContact;

  /// Si la consulta del contacto falló. Separado de que [notificationContact]
  /// sea nulo: una cosa es no tener medio de aviso y otra no haber podido
  /// comprobarlo.
  final bool notificationContactUnavailable;
  final bool biometricEnabled;
}

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({super.key});

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  bool _updatingBiometrics = false;

  bool _deletingAccount = false;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idAgente = ref.watch(citizenEndpointIdsProvider).idAgente ?? '';
    final contactId = ref.watch(ciudadanosEndpointIdProvider);
    final preferencesArgs = (
      idAgente: idAgente,
      contactId: contactId,
    );
    final state = ref.watch(_preferencesStateProvider(preferencesArgs));

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppHeaderBar(
        title: l10n.drawerPreferences,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(Routes.homeFromDrawer);
          }
        },
        onInfo: () => AppInfoSheet.show(
          context: context,
          title: l10n.drawerPreferences,
          bodyText: l10n.preferencesInfoSheetBody,
        ),
      ),
      body: state.when(
        loading: () => const AppLoadingIndicator(),
        error: (final _, final _) => ErrorStateWidget(
          message: l10n.errorStateDefault,
          onRetry: () => ref.invalidate(_preferencesStateProvider(preferencesArgs)),
        ),
        data: (final preferences) => _buildPreferencesContent(
          preferences: preferences,
          idAgente: idAgente,
          preferencesArgs: preferencesArgs,
        ),
      ),
    );
  }

  Widget _buildPreferencesContent({
    required final _PreferencesState preferences,
    required final String idAgente,
    required final _PreferencesArgs preferencesArgs,
  }) {
    final l10n = AppLocalizations.of(context);
    return AppPreferenceList(
      children: [
        AppConsentPreferenceCard(
          onEdit: () => context.go(
            Uri(
              path: Routes.consent,
              queryParameters: {
                'mode': 'preferences',
                'returnTo': Routes.preferences,
              },
            ).toString(),
          ),
        ),
        const SizedBox(height: AppDimensions.space16),
        AppPreferenceCard(
          title: l10n.lifeEventsTitle,
          icon: const AppSvgIcon(AppIconAssets.license, color: AppColors.textPrimary),
          status: preferences.lifeEventsStatus,
          inactiveDescription: l10n.preferencesLifeEventsInactiveDescription,
          pendingDescription: l10n.preferencesLifeEventsPendingDescription,
          activeDescription: l10n.preferencesLifeEventsActiveDescription,
          actionLabel: l10n.preferencesSelectAction,
          actionIcon: preferences.lifeEventsStatus == AppPreferenceStatus.enabled ? null : AppIcons.edit,
          onAction: preferences.lifeEventsStatus != AppPreferenceStatus.disabled ? () => unawaited(_openLifeEvents(preferencesArgs)) : null,
          filledAction: preferences.lifeEventsStatus != AppPreferenceStatus.disabled,
          summaryItems: preferences.selectedLifeEvents.map((final event) => event.label).toList(growable: false),
          activeFooterText: preferences.lifeEventsUpdatedAt == null ? null : _formatLifeEventsUpdate(l10n, preferences.lifeEventsUpdatedAt!),
        ),
        const SizedBox(height: AppDimensions.space16),
        if (preferences.notificationContactUnavailable)
          ErrorStateWidget(
            message: l10n.notificationContactErrorLoading,
            announce: false,
            onRetry: () {
              ref
                ..invalidate(notificationContactProvider(preferencesArgs.contactId))
                ..invalidate(_preferencesStateProvider(preferencesArgs));
            },
          )
        else
          AppPreferenceCard(
            title: l10n.preferencesNotificationContactTitle,
            icon: const AppIcon(AppIcons.alternateEmail, color: AppColors.textPrimary),
            status: preferences.notificationContact == null ? AppPreferenceStatus.pending : AppPreferenceStatus.enabled,
            inactiveDescription: l10n.preferencesNotificationContactInactiveDescription,
            pendingDescription: l10n.preferencesNotificationContactPendingDescription,
            activeDescription: l10n.preferencesNotificationContactActiveDescription,
            actionLabel: l10n.preferencesManageAction,
            actionIcon: AppIcons.edit,
            summaryItems: [
              ?preferences.notificationContact?.phone,
              ?preferences.notificationContact?.email,
            ],
            onAction: () => context.go(
              Uri(
                path: Routes.notificationContact,
                queryParameters: {'returnTo': Routes.preferences},
              ).toString(),
            ),
          ),
        const SizedBox(height: AppDimensions.space16),
        AppPreferenceCard(
          title: 'Activación de acceso biométrico',
          icon: const AppIcon(AppIcons.fingerprint, color: AppColors.textPrimary),
          status: preferences.biometricEnabled ? AppPreferenceStatus.enabled : AppPreferenceStatus.disabled,
          inactiveDescription: 'No se ha activado el acceso biométrico a la aplicación.',
          pendingDescription: 'No se ha activado el acceso biométrico a la aplicación.',
          activeDescription: 'El acceso biométrico a la aplicación está activado.',
          actionLabel: preferences.biometricEnabled ? 'Desactivar' : 'Activar',
          actionIcon: preferences.biometricEnabled ? AppIcons.close : AppIcons.check,
          onAction: _updatingBiometrics ? null : () => unawaited(_toggleBiometrics(preferencesArgs, preferences.biometricEnabled)),
          showInactiveIcon: true,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppButton(
          label: l10n.lifeEventsResetAction,
          leadingIcon: AppIcons.close,
          intent: AppButtonIntent.destructive,
          isExpanded: true,
          isLoading: _deletingAccount,
          onPressed: _deletingAccount ? null : () => unawaited(_confirmAndDeleteAccount(idAgente)),
        ),
      ],
    );
  }

  /// Activa o desactiva el acceso rápido con biometría.
  ///
  /// Activar exige dos cosas antes de tocar nada: que el dispositivo tenga
  /// biometría dada de alta —si no, el almacén rechazaría guardar el token y
  /// la promesa sería falsa— y que el ciudadano la supere ahora, que es la
  /// forma de comprobar que es quien dice ser antes de dejar su sesión abierta
  /// durante semanas.
  ///
  /// El cambio se aplica a la sesión en curso, no al siguiente login: al
  /// activar se guarda el token que ya está en memoria y al desactivar se
  /// borra del dispositivo en el acto.
  Future<void> _toggleBiometrics(
    final _PreferencesArgs preferencesArgs,
    final bool currentlyEnabled,
  ) async {
    if (_updatingBiometrics) {
      return;
    }
    setState(() => _updatingBiometrics = true);

    final l10n = AppLocalizations.of(context);
    final appStorage = ref.read(appStorageProvider);

    try {
      if (currentlyEnabled) {
        await appStorage.write('${StorageKeys.biometricQuickAccessEnabledPrefix}${preferencesArgs.idAgente}', false);
      } else {
        final authenticator = ref.read(biometricAuthenticatorProvider);
        if (!await authenticator.canAuthenticateWithBiometrics()) {
          if (!mounted) {
            return;
          }
          AppAlertSnackbar.show(
            context,
            message: l10n.walletErrorNoCapability,
            severity: AppAlertSeverity.warning,
          );
          return;
        }

        // Igual que en la home: en Android la escritura en el KeyStore ya
        // autentica, así que pedirlo también aquí encadenaba dos huellas.
        if (!Platform.isAndroid) {
          final authenticated = await authenticator.authenticateForSessionUnlock(
            localizedReason: l10n.sessionUnlockBiometricReason,
          );
          if (!authenticated) {
            return;
          }
        }
        await appStorage.write('${StorageKeys.biometricQuickAccessEnabledPrefix}${preferencesArgs.idAgente}', true);
      }

      final applied = await ref.read(authSessionControllerProvider).applyBiometricQuickAccessChange();
      if (!applied) {
        // No se pudo guardar el token: la preferencia vuelve atrás para no
        // anunciar un acceso rápido que no existe, y se explica por qué. El
        // caso típico no es un fallo del dispositivo: es una sesión restaurada
        // cuyo access token seguía vivo, así que nunca hizo falta refrescar y
        // no hay credencial de larga vida en memoria que guardar. La salida es
        // volver a identificarse, no reintentar el interruptor.
        await appStorage.write('${StorageKeys.biometricQuickAccessEnabledPrefix}${preferencesArgs.idAgente}', false);
        if (mounted) {
          AppAlertSnackbar.show(
            context,
            message: l10n.preferencesBiometricEnableFailed,
            severity: AppAlertSeverity.warning,
          );
        }
      }
      if (!mounted) {
        return;
      }
      ref.invalidate(_preferencesStateProvider(preferencesArgs));
      if (currentlyEnabled) {
        // Revocar borra el token de larga vida, así que la sesión en curso ya
        // no podrá renovarse cuando caduque el access token. Sin este aviso el
        // ciudadano se encontraba en Cl@ve unos minutos después de tocar un
        // interruptor que sólo prometía quitar la huella.
        AppAlertSnackbar.show(
          context,
          message: l10n.preferencesBiometricDisabledNotice,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _updatingBiometrics = false);
      }
    }
  }

  Future<void> _openLifeEvents(final _PreferencesArgs preferencesArgs) async {
    await context.push<void>(
      Uri(
        path: Routes.lifeEvents,
        queryParameters: {'returnTo': Routes.preferences},
      ).toString(),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(_preferencesStateProvider(preferencesArgs));
  }

  Future<void> _confirmAndDeleteAccount(final String idAgente) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDestructiveConfirmDialog.show(
      context,
      title: l10n.preferencesRevokeDialogTitle,
      description: l10n.preferencesRevokeDialogDescription,
      cancelLabel: l10n.lifeEventsResetCancel,
      confirmLabel: l10n.preferencesRevokeDialogConfirm,
    );
    if (confirmed != true || !mounted) {
      return;
    }
    if (idAgente.isEmpty) {
      AppAlertSnackbar.show(
        context,
        message: l10n.preferencesMissingUserIdError,
        severity: AppAlertSeverity.error,
      );
      return;
    }

    setState(() => _deletingAccount = true);
    final resetError = await _resetAccountPreferences(l10n, idAgente);
    if (!mounted) {
      return;
    }
    if (resetError != null) {
      setState(() => _deletingAccount = false);
      AppAlertSnackbar.show(
        context,
        message: resetError,
        severity: AppAlertSeverity.error,
      );
      return;
    }

    // Terminate the federated Cl@ve session (RP-initiated logout) so the
    // broker's SSO cookie is invalidated, then always clear the local session.
    try {
      final idToken = ref.read(tokenResponseProvider)?.idToken ?? '';
      if (idToken.isNotEmpty) {
        await ref.read(logoutUseCaseProvider).call(idToken: idToken);
      }
    } finally {
      ref
        ..invalidate(_preferencesStateProvider((idAgente: idAgente, contactId: ref.read(ciudadanosEndpointIdProvider))))
        ..invalidate(consentProvider(idAgente));
      await ref.read(authSessionControllerProvider).clear();
    }
    if (!mounted) {
      return;
    }
    context.go(Routes.landing);
  }

  Future<String?> _resetAccountPreferences(final AppLocalizations l10n, final String idAgente) async {
    final lifeEventsError = await _resetLifeEvents(idAgente);
    if (lifeEventsError != null) {
      return lifeEventsError;
    }
    final clausesError = await _resetConsentClauses(idAgente);
    if (clausesError != null) {
      return clausesError;
    }

    final appStorage = ref.read(appStorageProvider);
    final writes = await Future.wait([
      appStorage.remove('${StorageKeys.consentAcceptedPrefix}$idAgente'),
      appStorage.remove('${StorageKeys.consentAcceptedClausesPrefix}$idAgente'),
      appStorage.remove('${StorageKeys.lifeEventsOnboardingSeenPrefix}$idAgente'),
      appStorage.remove('${StorageKeys.lifeEventsLastUpdatedAtPrefix}$idAgente'),
    ]);
    if (writes.any((final success) => !success)) {
      return l10n.preferencesResetAuthorizationsError;
    }
    return null;
  }

  // El detalle crudo (e.toString() del usecase) va solo al logger; el snackbar
  // muestra únicamente el mensaje curado.
  Future<String?> _resetLifeEvents(final String idAgente) async {
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(resetLifeEventsUsecaseProvider).execute(idAgente: idAgente);
    switch (result) {
      case ResetLifeEventsSuccess():
        return null;
      case ResetLifeEventsFailed(:final message, :final cause):
        logger.e('Life events reset failed: $message', error: cause);
        return l10n.preferencesResetError;
    }
  }

  Future<String?> _resetConsentClauses(final String idAgente) async {
    final l10n = AppLocalizations.of(context);
    final resetResult = await ref.read(resetConsentClausesUsecaseProvider).execute(idAgente: idAgente);
    switch (resetResult) {
      case ResetConsentClausesSuccess():
        return null;
      case ResetConsentClausesFailed(:final message, :final cause):
        logger.e('Consent clauses reset failed: $message', error: cause);
        return l10n.preferencesResetError;
    }
  }
}

DateTime? _readLifeEventsUpdatedAt(final AppStorage appStorage, final String idAgente) {
  if (idAgente.isEmpty) {
    return null;
  }
  final storedValue = appStorage.read<String>(
    '${StorageKeys.lifeEventsLastUpdatedAtPrefix}$idAgente',
  );
  if (storedValue == null || storedValue.isEmpty) {
    return null;
  }
  return DateTime.tryParse(storedValue);
}

String _formatLifeEventsUpdate(final AppLocalizations l10n, final DateTime dateTime) {
  return l10n.commonUpdatedAt(
    dateTime.day,
    l10n.commonMonthShortName(_monthKey(dateTime.month)),
    dateTime.year,
    _formatTime(dateTime),
  );
}

String _formatTime(final DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _monthKey(final int month) => switch (month) {
  1 => 'january',
  2 => 'february',
  3 => 'march',
  4 => 'april',
  5 => 'may',
  6 => 'june',
  7 => 'july',
  8 => 'august',
  9 => 'september',
  10 => 'october',
  11 => 'november',
  12 => 'december',
  _ => 'other',
};
