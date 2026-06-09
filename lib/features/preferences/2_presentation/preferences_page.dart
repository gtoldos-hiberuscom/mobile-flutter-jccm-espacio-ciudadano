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
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/usecases/load_notification_contact_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

typedef _PreferencesArgs = ({String idAgente, String notificationCitizenId});

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
    final contact = await _loadNotificationContact(ref, args.notificationCitizenId);

    return _PreferencesState(
      lifeEventsStatus: lifeEventsEnabled
          ? selectedLifeEvents.isNotEmpty
                ? AppPreferenceStatus.enabled
                : AppPreferenceStatus.pending
          : AppPreferenceStatus.disabled,
      selectedLifeEvents: selectedLifeEvents,
      notificationContact: contact,
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

Future<NotificationContact?> _loadNotificationContact(
  final Ref ref,
  final String citizenId,
) async {
  if (citizenId.isEmpty) {
    return null;
  }
  final result = await ref.watch(loadNotificationContactUsecaseProvider).execute(citizenId: citizenId);
  return switch (result) {
    LoadNotificationContactSuccess(:final contact) => contact,
    LoadNotificationContactFailed() => null,
  };
}

final class _PreferencesState {
  const _PreferencesState({
    required this.lifeEventsStatus,
    required this.selectedLifeEvents,
    required this.notificationContact,
    required this.biometricEnabled,
  });

  final AppPreferenceStatus lifeEventsStatus;
  final List<LifeEvent> selectedLifeEvents;
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

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final claims = ref.watch(jwtClaimsProvider);
    final idAgente = claims?.idAgente ?? '';
    final preferencesArgs = (
      idAgente: idAgente,
      notificationCitizenId: _notificationCitizenId(claims),
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
            context.go(Routes.home);
          }
        },
        onInfo: () => AppAlertSnackbar.show(
          context,
          message: 'Gestiona tus autorizaciones, avisos y acceso biométrico.',
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
        ),
      ),
    );
  }

  Widget _buildPreferencesContent({
    required final _PreferencesState preferences,
    required final String idAgente,
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
          onAction: preferences.lifeEventsStatus != AppPreferenceStatus.disabled
              ? () => context.go(
                  Uri(
                    path: Routes.lifeEvents,
                    queryParameters: {'returnTo': Routes.preferences},
                  ).toString(),
                )
              : null,
          filledAction: preferences.lifeEventsStatus != AppPreferenceStatus.disabled,
          summaryItems: preferences.selectedLifeEvents.map((final event) => event.label).toList(growable: false),
          activeFooterText: 'Actualizado el 21 abr 2026 a las 23:00h',
        ),
        const SizedBox(height: AppDimensions.space16),
        if (preferences.notificationContact?.hasAnyContact ?? false)
          AppNotificationContactPreferenceCard(
            phone: preferences.notificationContact!.phone,
            email: preferences.notificationContact!.email,
            onEdit: () => context.go(Routes.notificationContact),
          )
        else
          AppPreferenceCard(
            title: 'Datos de contacto para notificaciones',
            icon: const AppIcon(AppIcons.alternateEmail, color: AppColors.textPrimary),
            status: AppPreferenceStatus.disabled,
            inactiveDescription: 'Para recibir notificaciones electrónicas debes indicar al menos un medio de aviso.',
            pendingDescription: 'Para recibir notificaciones electrónicas debes indicar al menos un medio de aviso.',
            activeDescription: 'Tienes configurado al menos un medio de aviso para recibir notificaciones electrónicas.',
            actionLabel: 'Dar de alta',
            actionIcon: AppIcons.edit,
            onAction: () => context.go(Routes.notificationContact),
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
        notificationCitizenId: _notificationCitizenId(ref.read(jwtClaimsProvider)),
      )),
    );
    AppAlertSnackbar.show(
      context,
      message: currentlyEnabled ? 'Acceso biométrico desactivado' : 'Acceso biométrico activado',
      severity: AppAlertSeverity.success,
    );
  }
}

String _notificationCitizenId(final JwtClaims? claims) {
  return claims?.idAgente ?? '';
}
