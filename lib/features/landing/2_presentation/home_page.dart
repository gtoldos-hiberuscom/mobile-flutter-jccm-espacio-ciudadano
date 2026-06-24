import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/check_life_events_onboarding_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_usecase_providers.dart';

final _biometricQuickAccessPromptShownInSessionProvider = NotifierProvider<_BiometricQuickAccessPromptSessionNotifier, bool>(
  _BiometricQuickAccessPromptSessionNotifier.new,
);

class _BiometricQuickAccessPromptSessionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markShown() => state = true;
}

/// Authenticated home screen — Figma node 43716:13302 "Inicio".
///
/// Composed of:
/// - [AppNavBar] (type inicio, logged in, with notifications + avatar)
/// - Content area (light blue-lighter background)
/// - [AppBottomTabBar] (5 tabs: Inicio, Gestión, Mi Carpeta, Agenda, Recomendados)
/// - [AppFab] (ID card icon, bottom-right)
/// - Shows the biometric quick-access dialog on first load.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _biometricDialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_biometricDialogShown) {
      _biometricDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_handleInitialPrompts());
        }
      });
    }
  }

  Future<void> _handleInitialPrompts() async {
    await _showBiometricDialog();
    if (!mounted) {
      return;
    }
    await _redirectToLifeEventsOnboardingIfNeeded();
  }

  Future<void> _showBiometricDialog() async {
    final appStorage = ref.read(appStorageProvider);
    final enabled = appStorage.read<bool>(StorageKeys.biometricQuickAccessEnabled) ?? false;
    final promptShownInSession = ref.read(_biometricQuickAccessPromptShownInSessionProvider);
    if (enabled || promptShownInSession) {
      return;
    }

    final hasBiometrics = await ref.read(biometricAuthenticatorProvider).canAuthenticateWithBiometrics();
    if (!mounted || !hasBiometrics) {
      return;
    }
    ref.read(_biometricQuickAccessPromptShownInSessionProvider.notifier).markShown();

    final accepted = await AppBiometricAccessDialog.show(context);

    if (!mounted) {
      return;
    }

    if (accepted != true) {
      return;
    }

    await appStorage.write(StorageKeys.biometricQuickAccessEnabled, true);
    if (!mounted) {
      return;
    }

    AppAlertToast.show(
      context,
      message: 'Acceso biométrico activado',
      severity: AppAlertSeverity.success,
    );
  }

  Future<void> _redirectToLifeEventsOnboardingIfNeeded() async {
    final idAgente = ref.read(jwtClaimsProvider)?.idAgente ?? '';
    if (idAgente.isEmpty) {
      return;
    }
    final hasAcceptedLifeEventsClause = await _hasAcceptedLifeEventsClause(idAgente);
    if (!mounted || !hasAcceptedLifeEventsClause) {
      return;
    }

    final result = await ref.read(checkLifeEventsOnboardingUsecaseProvider).execute(idAgente: idAgente);
    if (!mounted) {
      return;
    }

    switch (result) {
      case CheckLifeEventsOnboardingFailed():
        context.go(Routes.lifeEventsOnboarding);
      case CheckLifeEventsOnboardingSuccess(:final hasSeen):
        if (!hasSeen) {
          context.go(Routes.lifeEventsOnboarding);
        }
    }
  }

  Future<bool> _hasAcceptedLifeEventsClause(final String idAgente) async {
    final result = await ref
        .read(checkAcceptedConsentClauseUsecaseProvider)
        .execute(
          idAgente: idAgente,
          clauseId: 3,
        );
    return switch (result) {
      AcceptedConsentClauseStatus(:final isAccepted) => isAccepted,
      CheckAcceptedConsentClauseFailed() => false,
    };
  }

  void _showComingSoon() {
    AppAlertSnackbar.show(
      context,
      message: 'Función disponible próximamente',
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.inicio,
        isLoggedIn: true,
        onAvatarTap: () => showAuthenticatedProfileMenu(context: context, ref: ref),
      ),
      body: _HomeDashboard(onComingSoon: _showComingSoon),
      floatingActionButton: AppFab(
        icon: AppIcons.license,
        onPressed: _showComingSoon,
        semanticsLabel: 'Identificación digital',
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({required this.onComingSoon});

  final VoidCallback onComingSoon;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.backgroundBlueLighter,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.space16,
            AppDimensions.space24,
            AppDimensions.space16,
            112,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(text: 'Mis novedades'),
              const SizedBox(height: AppDimensions.space8),
              AppSimpleNavCard(
                label: 'Notificaciones (4)',
                description: 'Consulta tus notificaciones pendientes',
                onTap: onComingSoon,
              ),
              const SizedBox(height: AppDimensions.space8),
              AppSimpleNavCard(
                label: 'Próximas citas (3)',
                description: 'Revisa tus citas que tienes agendadas próximamente',
                onTap: onComingSoon,
              ),
              const SizedBox(height: AppDimensions.space24),
              const _SectionTitle(text: 'Accesos “Mis datos”'),
              const SizedBox(height: AppDimensions.space8),
              _QuickAccessGrid(onComingSoon: onComingSoon),
              const SizedBox(height: AppDimensions.space24),
              const _SectionTitle(text: 'Trámites recomendados'),
              const SizedBox(height: AppDimensions.space8),
              _RecommendedProcedures(onComingSoon: onComingSoon),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: AppTypography.h3.copyWith(color: AppColors.textBlack),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.onComingSoon});

  final VoidCallback onComingSoon;

  static const _items = [
    _QuickAccessItem(
      label: 'Salud',
      icon: AppIcons.favorite,
      route: Routes.myDataHealth,
    ),
    _QuickAccessItem(
      label: 'Bienestar Social',
      icon: AppIcons.diversity,
      route: Routes.myDataSocialWelfare,
    ),
    _QuickAccessItem(
      label: 'Empleo',
      icon: AppIcons.work,
      route: Routes.myDataEmployment,
    ),
    _QuickAccessItem(
      label: 'Educación',
      icon: AppIcons.school,
      route: Routes.myDataEducation,
    ),
    _QuickAccessItem(
      label: 'Vivienda',
      icon: AppIcons.cottage,
      route: Routes.myDataHousing,
    ),
    _QuickAccessItem(
      label: 'Vehículos',
      icon: AppIcons.directionsCar,
      route: Routes.myDataVehicles,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppDimensions.space8,
        crossAxisSpacing: AppDimensions.space8,
        childAspectRatio: 0.73,
      ),
      itemBuilder: (final context, final index) {
        final item = _items[index];
        return AppQuickAccessCard(
          label: item.label,
          icon: item.icon,
          onTap: () {
            final route = item.route;
            if (route == null) {
              onComingSoon();
              return;
            }
            context.go(
              Uri(
                path: route,
                queryParameters: const {'from': 'home'},
              ).toString(),
            );
          },
        );
      },
    );
  }
}

class _RecommendedProcedures extends StatelessWidget {
  const _RecommendedProcedures({required this.onComingSoon});

  final VoidCallback onComingSoon;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 304,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: 2,
        separatorBuilder: (final context, final index) => const SizedBox(width: AppDimensions.space16),
        itemBuilder: (final context, final index) => SizedBox(
          width: 288,
          child: _RecommendedProcedureCard(onTap: onComingSoon),
        ),
      ),
    );
  }
}

class _RecommendedProcedureCard extends StatelessWidget {
  const _RecommendedProcedureCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return AppRecommendationCard(
      onTap: onTap,
      title: 'Nombre del trámite recomend. que puede ser muy largo pero con elipsis a la tercera línea...',
      badge: const AppTag(
        status: AppTagStatus.success,
        label: 'Tramitación inmediata',
        showIcon: false,
      ),
      detailLabel: 'Hechos vitales asociados',
      detailText: 'Quiero acoger - Busco trabajo - Quiero vivir en un pueblo - Quiero estudiar',
    );
  }
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.label,
    required this.icon,
    this.route,
  });

  final String label;
  final IconData icon;
  final String? route;
}
