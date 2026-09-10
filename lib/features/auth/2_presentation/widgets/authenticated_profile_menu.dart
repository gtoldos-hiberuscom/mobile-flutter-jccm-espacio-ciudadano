import 'dart:async' show unawaited;

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
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Initials of the authenticated person's name and first surname.
///
/// Returns `null` instead of an empty string when there are no claims — the
/// case while the session is being cleared and the authenticated pages are
/// still mounted for a frame. `AppNavBar` accepts `null` but asserts against
/// the empty string.
String? authenticatedProfileInitials(final WidgetRef ref) {
  final claims = ref.watch(jwtClaimsProvider);
  final initials = [
    _initial(claims?.givenName),
    _initial(claims?.firstSurname),
  ].whereType<String>().join();
  return initials.isEmpty ? null : initials;
}

void showAuthenticatedProfileMenu({
  required final BuildContext context,
  required final WidgetRef ref,
}) {
  final claims = ref.read(jwtClaimsProvider);
  final l10n = AppLocalizations.of(context);

  Future<void> pushAndRefresh(final String route) async {
    await context.push<void>(route);
    if (context.mounted && route == Routes.preferences) {
      ref.invalidate(recommendationsProvider);
    }
  }

  void closeMenuAndPush(final String route) {
    Navigator.of(context, rootNavigator: true).pop();
    unawaited(pushAndRefresh(route));
  }

  Future<void> openElectronicOffice() async {
    final catalog = ref.read(externalLinkCatalogProvider);
    final link = catalog.findById('sede_jccm');
    if (link == null) {
      return;
    }

    if (!await confirmExternalNavigation(context) || !context.mounted) {
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

    // Terminate the federated Cl@ve session (RP-initiated logout) so the
    // broker's SSO cookie is invalidated, then always clear the local session.
    try {
      final idToken = ref.read(tokenResponseProvider)?.idToken ?? '';
      if (idToken.isNotEmpty) {
        await ref.read(logoutUseCaseProvider).call(idToken: idToken);
      }
    } finally {
      await ref.read(authSessionControllerProvider).clear();
    }

    if (context.mounted) {
      context.go(Routes.landing);
    }
  }

  showAppDrawerMenu(
    context: context,
    userName: _userName(l10n, claims),
    nif: claims?.normalizedPersonIdentifier ?? claims?.idAgente ?? '-',
    primaryItems: [
      AppDrawerMenuItem(
        label: l10n.drawerPreferences,
        icon: Icons.settings_outlined,
        onTap: () => closeMenuAndPush(Routes.preferences),
      ),
      AppDrawerMenuItem(
        label: l10n.digitalCardsPageTitle,
        icon: Icons.badge_outlined,
        onTap: () => closeMenuAndPush(Routes.digitalCards),
      ),
    ],
    secondaryLinks: [
      AppDrawerLinkItem(
        label: l10n.drawerHelpAndContact,
        icon: Icons.help_outline_rounded,
        onTap: () => closeMenuAndPush(Routes.helpContact),
      ),
      AppDrawerLinkItem(
        label: l10n.legalAccessibilityTitle,
        icon: Icons.accessibility_new_rounded,
        onTap: () => closeMenuAndPush(Routes.legalAccessibility),
      ),
      AppDrawerLinkItem(
        label: l10n.legalNoticeTitle,
        onTap: () => closeMenuAndPush(Routes.legalNotice),
      ),
      AppDrawerLinkItem(
        label: l10n.legalPrivacyTitle,
        onTap: () => closeMenuAndPush(Routes.legalPrivacyInfo),
      ),
    ],
    onLogout: logout,
    actionButtonLabel: l10n.drawerGoToSedeElectronica,
    onActionButton: openElectronicOffice,
  );
}

String _userName(final AppLocalizations l10n, final JwtClaims? claims) {
  final givenName = claims?.givenName?.trim();
  final firstSurname = claims?.firstSurname?.trim();
  final nameParts = [
    if (givenName != null && givenName.isNotEmpty) givenName,
    if (firstSurname != null && firstSurname.isNotEmpty) firstSurname,
  ];

  if (nameParts.isNotEmpty) {
    return nameParts.join(' ');
  }

  return claims?.preferredUsername?.trim().isNotEmpty ?? false ? claims!.preferredUsername!.trim() : l10n.drawerDefaultUserName;
}

String? _initial(final String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized[0].toUpperCase();
}
