import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
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
      CheckAcceptedConsentClauseFailed() => false,
    };
    final selectedLifeEvents = lifeEventsEnabled ? await _selectedLifeEvents(ref, args.idAgente) : const <LifeEvent>[];
    final lifeEventsUpdatedAt = _readLifeEventsUpdatedAt(appStorage, args.idAgente);
    final notificationContact = await ref.watch(notificationContactProvider(args.contactId).future);

    return _PreferencesState(
      lifeEventsStatus: lifeEventsEnabled
          ? selectedLifeEvents.isNotEmpty
                ? AppPreferenceStatus.enabled
                : AppPreferenceStatus.pending
          : AppPreferenceStatus.disabled,
      selectedLifeEvents: selectedLifeEvents,
      lifeEventsUpdatedAt: lifeEventsUpdatedAt,
      notificationContact: notificationContact,
      biometricEnabled: appStorage.read<bool>(StorageKeys.biometricQuickAccessEnabled) ?? false,
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
    LoadLifeEventsFailed() => const [],
  };
}

final class _PreferencesState {
  const _PreferencesState({
    required this.lifeEventsStatus,
    required this.selectedLifeEvents,
    required this.lifeEventsUpdatedAt,
    required this.notificationContact,
    required this.biometricEnabled,
  });

  final AppPreferenceStatus lifeEventsStatus;
  final List<LifeEvent> selectedLifeEvents;
  final DateTime? lifeEventsUpdatedAt;
  final NotificationContact? notificationContact;
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
          bodyText: 'Gestiona tus autorizaciones, avisos y acceso biométrico.',
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
          title: 'Mis hechos vitales',
          icon: const AppSvgIcon(AppIconAssets.license, color: AppColors.textPrimary),
          status: preferences.lifeEventsStatus,
          inactiveDescription: 'Para seleccionar tus hechos vitales y poder recibir recomendaciones primero debes aceptar el uso de estos datos en Condiciones de uso y autorizaciones.',
          pendingDescription: 'Aún no has seleccionado las temáticas de las que quieras recibir actualizaciones dentro de tu sección de recomendaciones',
          activeDescription: 'Tienes hechos vitales seleccionados para recibir recomendaciones personalizadas.',
          actionLabel: 'Seleccionar',
          actionIcon: preferences.lifeEventsStatus == AppPreferenceStatus.enabled ? null : AppIcons.edit,
          onAction: preferences.lifeEventsStatus != AppPreferenceStatus.disabled ? () => unawaited(_openLifeEvents(preferencesArgs)) : null,
          filledAction: preferences.lifeEventsStatus != AppPreferenceStatus.disabled,
          summaryItems: preferences.selectedLifeEvents.map((final event) => event.label).toList(growable: false),
          activeFooterText: preferences.lifeEventsUpdatedAt == null ? null : 'Actualizado el ${_formatLifeEventsUpdate(preferences.lifeEventsUpdatedAt!)}',
        ),
        const SizedBox(height: AppDimensions.space16),
        AppPreferenceCard(
          title: 'Datos de contacto para notificaciones',
          icon: const AppIcon(AppIcons.alternateEmail, color: AppColors.textPrimary),
          status: preferences.notificationContact == null ? AppPreferenceStatus.pending : AppPreferenceStatus.enabled,
          inactiveDescription: 'Para recibir notificaciones electrónicas debes indicar al menos un medio de aviso.',
          pendingDescription: 'Gestiona el medio de aviso para recibir notificaciones electrónicas.',
          activeDescription: 'Tienes configurado al menos un medio de aviso para recibir notificaciones electrónicas.',
          actionLabel: 'Gestionar',
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
          onAction: _updatingBiometrics ? null : () => unawaited(_toggleBiometrics(idAgente, preferences.biometricEnabled)),
          showInactiveIcon: true,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppButton(
          label: 'Eliminar cuenta',
          leadingIcon: AppIcons.close,
          intent: AppButtonIntent.destructive,
          isExpanded: true,
          isLoading: _deletingAccount,
          onPressed: _deletingAccount ? null : () => unawaited(_confirmAndDeleteAccount(idAgente)),
        ),
      ],
    );
  }

  Future<void> _toggleBiometrics(
    final String idAgente,
    final bool currentlyEnabled,
  ) async {
    if (_updatingBiometrics) {
      return;
    }
    setState(() => _updatingBiometrics = true);

    final l10n = AppLocalizations.of(context);
    final appStorage = ref.read(appStorageProvider);
    var updated = false;

    if (currentlyEnabled) {
      updated = await appStorage.write(StorageKeys.biometricQuickAccessEnabled, false);
    } else {
      final authenticator = ref.read(biometricAuthenticatorProvider);
      final canAuthenticate = await authenticator.canAuthenticateWithBiometrics();
      if (!mounted) {
        return;
      }
      if (!canAuthenticate) {
        AppAlertSnackbar.show(
          context,
          message: l10n.walletErrorNoCapability,
          severity: AppAlertSeverity.warning,
        );
        setState(() => _updatingBiometrics = false);
        return;
      }

      final authenticated = await authenticator.authenticateForSessionUnlock(
        localizedReason: 'Activa el acceso biométrico a Espacio Ciudadano.',
      );
      if (!mounted) {
        return;
      }
      if (authenticated) {
        updated = await appStorage.write(StorageKeys.biometricQuickAccessEnabled, true);
      }
    }

    if (!mounted) {
      return;
    }
    setState(() => _updatingBiometrics = false);
    if (!updated) {
      return;
    }

    ref.invalidate(
      _preferencesStateProvider((
        idAgente: idAgente,
        contactId: ref.read(ciudadanosEndpointIdProvider),
      )),
    );
    AppAlertSnackbar.show(
      context,
      message: currentlyEnabled ? 'Acceso biométrico desactivado' : 'Acceso biométrico activado',
      severity: AppAlertSeverity.success,
    );
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
    final confirmed = await AppDestructiveConfirmDialog.show(
      context,
      title: 'Eliminación de cuenta y revocación de permisos',
      description:
          '¿Deseas borrar la selección de condiciones de uso, autorizaciones y hechos vitales?\n'
          'Al hacerlo, se cerrará tu sesión actual y, si vuelves a acceder tendrás que completar el proceso desde el inicio.',
      cancelLabel: 'Cancelar',
      confirmLabel: 'Eliminar',
    );
    if (confirmed != true || !mounted) {
      return;
    }
    if (idAgente.isEmpty) {
      AppAlertSnackbar.show(
        context,
        message: 'No se ha encontrado el identificador del usuario.',
        severity: AppAlertSeverity.error,
      );
      return;
    }

    setState(() => _deletingAccount = true);
    final resetError = await _resetAccountPreferences(idAgente);
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

  Future<String?> _resetAccountPreferences(final String idAgente) async {
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
      appStorage.remove(StorageKeys.consentAccepted),
      appStorage.remove(StorageKeys.biometricQuickAccessEnabled),
      appStorage.remove(StorageKeys.biometricQuickAccessPromptSeen),
      appStorage.remove('${StorageKeys.consentAcceptedPrefix}$idAgente'),
      appStorage.remove('${StorageKeys.consentAcceptedClausesPrefix}$idAgente'),
      appStorage.remove('${StorageKeys.lifeEventsOnboardingSeenPrefix}$idAgente'),
      appStorage.remove('${StorageKeys.lifeEventsLastUpdatedAtPrefix}$idAgente'),
    ]);
    if (writes.any((final success) => !success)) {
      return 'No hemos podido borrar tus autorizaciones. Inténtalo de nuevo.';
    }
    return null;
  }

  Future<String?> _resetLifeEvents(final String idAgente) async {
    final result = await ref.read(resetLifeEventsUsecaseProvider).execute(idAgente: idAgente);
    return switch (result) {
      ResetLifeEventsSuccess() => null,
      ResetLifeEventsFailed(:final message) => message,
    };
  }

  Future<String?> _resetConsentClauses(final String idAgente) async {
    final resetResult = await ref.read(resetConsentClausesUsecaseProvider).execute(idAgente: idAgente);
    return switch (resetResult) {
      ResetConsentClausesSuccess() => null,
      ResetConsentClausesFailed(:final message) => message,
    };
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

String _formatLifeEventsUpdate(final DateTime dateTime) {
  return '${dateTime.day} ${_shortMonthName(dateTime.month)} ${dateTime.year} a las ${_formatTime(dateTime)}';
}

String _formatTime(final DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:${minute}h';
}

String _shortMonthName(final int month) => switch (month) {
  1 => 'ene',
  2 => 'feb',
  3 => 'mar',
  4 => 'abr',
  5 => 'may',
  6 => 'jun',
  7 => 'jul',
  8 => 'ago',
  9 => 'sep',
  10 => 'oct',
  11 => 'nov',
  12 => 'dic',
  _ => '',
};
