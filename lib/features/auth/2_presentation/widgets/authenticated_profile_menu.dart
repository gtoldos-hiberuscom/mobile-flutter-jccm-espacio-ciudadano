import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void showAuthenticatedProfileMenu({
  required final BuildContext context,
  required final WidgetRef ref,
}) {
  final claims = ref.read(jwtClaimsProvider);
  final l10n = AppLocalizations.of(context);

  void closeMenuAndGo(final String route) {
    Navigator.of(context, rootNavigator: true).pop();
    context.go(route);
  }

  Future<void> openElectronicOffice() async {
    final catalog = ref.read(externalLinkCatalogProvider);
    final link = catalog.findById('sede_dgt');
    if (link == null) {
      return;
    }

    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!context.mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }

  Future<void> logout() async {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    final session = ref.read(tokenResponseProvider);
    final idToken = session?.idToken ?? '';

    if (idToken.isNotEmpty) {
      await ref.read(logoutUseCaseProvider).call(idToken: idToken);
    }

    await ref.read(authSessionControllerProvider).clear();

    if (context.mounted) {
      context.go(Routes.landing);
    }
  }

  showAppDrawerMenu(
    context: context,
    userName: _userName(claims),
    nif: claims?.personIdentifier ?? claims?.idAgente ?? '-',
    primaryItems: [
      AppDrawerMenuItem(
        label: l10n.drawerPreferences,
        icon: Icons.settings_outlined,
        onTap: () => closeMenuAndGo(Routes.lifeEvents),
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
        onTap: () => closeMenuAndGo(Routes.helpContact),
      ),
      AppDrawerLinkItem(
        label: l10n.legalAccessibilityTitle,
        icon: Icons.accessibility_new_rounded,
        onTap: () => closeMenuAndGo(Routes.legalAccessibility),
      ),
      AppDrawerLinkItem(
        label: l10n.legalNoticeTitle,
        onTap: () => closeMenuAndGo(Routes.legalNotice),
      ),
      AppDrawerLinkItem(
        label: l10n.legalPrivacyTitle,
        onTap: () => closeMenuAndGo(Routes.legalPrivacy),
      ),
    ],
    onLogout: logout,
    actionButtonLabel: 'Ir a Sede Electrónica',
    onActionButton: openElectronicOffice,
  );
}

String _userName(final JwtClaims? claims) {
  return claims?.name ?? claims?.givenName ?? claims?.preferredUsername ?? 'Ciudadano/a';
}
