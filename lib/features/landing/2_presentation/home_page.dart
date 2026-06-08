import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/check_life_events_onboarding_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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
  int _currentTabIndex = 0;
  bool _biometricDialogShown = false;

  static const List<AppBottomTabBarItem> _tabs = [
    AppBottomTabBarItem(label: 'Inicio', iconAsset: AppIconAssets.accountBalance),
    AppBottomTabBarItem(label: 'Gestión', iconAsset: AppIconAssets.docs),
    AppBottomTabBarItem(label: 'Mi Carpeta', iconAsset: AppIconAssets.apps),
    AppBottomTabBarItem(label: 'Agenda', iconAsset: AppIconAssets.calendarToday),
    AppBottomTabBarItem(label: 'Recomendados', iconAsset: AppIconAssets.license),
  ];

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

  void _showProfileMenu() {
    final claims = ref.read(jwtClaimsProvider);
    final l10n = AppLocalizations.of(context);

    showAppDrawerMenu(
      context: context,
      userName: _userName(claims),
      nif: claims?.personIdentifier ?? claims?.idAgente ?? '-',
      primaryItems: [
        AppDrawerMenuItem(
          label: l10n.drawerPreferences,
          icon: Icons.settings_outlined,
        ),
        AppDrawerMenuItem(
          label: l10n.digitalCardsPageTitle,
          icon: Icons.badge_outlined,
        ),
      ],
      secondaryLinks: [
        AppDrawerLinkItem(
          label: l10n.drawerHelpAndContact,
          icon: Icons.help_outline_rounded,
          onTap: () => _closeMenuAndGo(Routes.helpContact),
        ),
        AppDrawerLinkItem(
          label: l10n.legalAccessibilityTitle,
          icon: Icons.accessibility_new_rounded,
          onTap: () => _closeMenuAndGo(Routes.legalAccessibility),
        ),
        AppDrawerLinkItem(
          label: l10n.legalNoticeTitle,
          onTap: () => _closeMenuAndGo(Routes.legalNotice),
        ),
        AppDrawerLinkItem(
          label: l10n.legalPrivacyTitle,
          onTap: () => _closeMenuAndGo(Routes.legalPrivacy),
        ),
      ],
      onLogout: _logout,
      actionButtonLabel: 'Ir a Sede Electrónica',
      onActionButton: _openElectronicOffice,
    );
  }

  Future<void> _openElectronicOffice() async {
    final catalog = ref.read(externalLinkCatalogProvider);
    final link = catalog.findById('sede_dgt');
    if (link == null) {
      return;
    }

    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }

  Future<void> _logout() async {
    // Close drawer first.
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    final session = ref.read(tokenResponseProvider);
    final idToken = session?.idToken ?? '';

    // Best-effort end-session at the Cl@ve IdP.
    if (idToken.isNotEmpty) {
      await ref.read(logoutUseCaseProvider).call(idToken: idToken);
    }

    await ref.read(authSessionControllerProvider).clear();

    if (mounted) {
      context.go(Routes.landing);
    }
  }

  String _userName(final JwtClaims? claims) {
    return claims?.name ?? claims?.givenName ?? claims?.preferredUsername ?? 'Ciudadano/a';
  }

  void _closeMenuAndGo(final String route) {
    Navigator.of(context, rootNavigator: true).pop();
    context.go(route);
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.inicio,
        isLoggedIn: true,
        onAvatarTap: _showProfileMenu,
      ),
      body: const _HomeDashboard(),
      bottomNavigationBar: AppBottomTabBar(
        items: _tabs,
        currentIndex: _currentTabIndex,
        onTap: (final int index) => setState(() => _currentTabIndex = index),
      ),
      floatingActionButton: AppFab(
        iconAsset: AppIconAssets.license,
        onPressed: () {
          // TODO(jccm): Navigate to ID card / digital identity.
        },
        semanticsLabel: 'Identificación digital',
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundBlueLighter,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space24,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: 'Compo 1', style: AppTypography.h2),
          SizedBox(height: AppDimensions.space16),
          _SectionTitle(text: 'Título 3', style: AppTypography.h3),
          SizedBox(height: AppDimensions.space16),
          _SectionTitle(text: 'Título 3', style: AppTypography.leadingMedium),
          SizedBox(height: AppDimensions.space16),
          _SectionTitle(text: 'Título 3', style: AppTypography.bodyRegular),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: AppColors.textBase),
    );
  }
}
