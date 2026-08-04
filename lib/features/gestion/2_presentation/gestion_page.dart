import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_divider.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Gestión hub — Figma node 41631:14940.
class GestionPage extends ConsumerWidget {
  const GestionPage({super.key});

  static const List<_GestionSectionDefinition> _sections = [
    _GestionSectionDefinition(
      title: _GestionText.expedientesTitle,
      route: Routes.gestionExpedientes,
    ),
    _GestionSectionDefinition(
      title: _GestionText.registrosTitle,
      route: Routes.gestionRegistros,
    ),
    _GestionSectionDefinition(
      title: _GestionText.aportacionTitle,
      hasDividerAbove: true,
      route: Routes.gestionAportacion,
    ),
  ];

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sections = _sections.map((final s) => s.resolve(l10n)).toList(growable: false);

    final citizenId = ref.watch(ciudadanosEndpointIdProvider);
    final contactState = ref.watch(notificationContactProvider(citizenId));
    final hasContact = contactState.asData?.value != null;

    return Scaffold(
      appBar: AppNavBar(
        title: l10n.gestionTitle,
        isLoggedIn: true,
        showNotifications: false,
        profileInitials: authenticatedProfileInitials(ref),
        showLeading: false,
        onAvatarTap: () => showAuthenticatedProfileMenu(context: context, ref: ref),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final section in sections) ...[
                  if (section.hasDividerAbove) ...[
                    const SizedBox(height: AppDimensions.space8),
                    const AppDivider(strength: AppDividerStrength.medium),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  AppNavigationCard(
                    title: section.title,
                    description: section.description,
                    onTap: () => context.go(section.route),
                  ),
                  if (!section.hasDividerAbove) const SizedBox(height: AppDimensions.space16),
                ],
                const SizedBox(height: AppDimensions.space8),
                const AppDivider(),
                const SizedBox(height: AppDimensions.space8),
                AppNavigationCard(
                  title: l10n.gestionNotificacionesTitle,
                  isDisabled: !hasContact,
                  onTap: () {
                    if (hasContact) {
                      context.go(Routes.gestionNotificaciones);
                    }
                  },
                ),
                if (!hasContact)
                  _NotificacionesContextualHelper(
                    onActivar: () => context.go(Routes.gestionNotificacionesAlta),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificacionesContextualHelper extends StatelessWidget {
  const _NotificacionesContextualHelper({required this.onActivar});

  final VoidCallback onActivar;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppAlertContextual(
      message: l10n.gestionNotificacionesContextualMessage,
      size: AppAlertContextualSize.small,
      action: AppButton(
        label: l10n.gestionNotificacionesContextualAction,
        hierarchy: AppButtonHierarchy.ghost,
        trailingIcon: AppIcons.callMade,
        onPressed: onActivar,
      ),
    );
  }
}

class _GestionSectionDefinition {
  const _GestionSectionDefinition({
    required this.title,
    required this.route,
    this.description,
    this.hasDividerAbove = false,
  });

  final _GestionText title;
  final _GestionText? description;
  final bool hasDividerAbove;
  final String route;

  _GestionSection resolve(final AppLocalizations l10n) {
    return _GestionSection(
      title: title.resolve(l10n),
      description: description?.resolve(l10n),
      hasDividerAbove: hasDividerAbove,
      route: route,
    );
  }
}

enum _GestionText {
  expedientesTitle,
  expedientesDescription,
  registrosTitle,
  registrosDescription,
  aportacionTitle,
  aportacionDescription,
  notificacionesTitle,
  notificacionesDescription
  ;

  String resolve(final AppLocalizations l10n) {
    return switch (this) {
      _GestionText.expedientesTitle => l10n.gestionExpedientesTitle,
      _GestionText.expedientesDescription => l10n.gestionExpedientesDescription,
      _GestionText.registrosTitle => l10n.gestionRegistrosTitle,
      _GestionText.registrosDescription => l10n.gestionRegistrosDescription,
      _GestionText.aportacionTitle => l10n.gestionAportacionTitle,
      _GestionText.aportacionDescription => l10n.gestionAportacionDescription,
      _GestionText.notificacionesTitle => l10n.gestionNotificacionesTitle,
      _GestionText.notificacionesDescription => l10n.gestionNotificacionesDescription,
    };
  }
}

class _GestionSection {
  const _GestionSection({
    required this.title,
    required this.hasDividerAbove,
    required this.route,
    this.description,
  });

  final String title;
  final String? description;
  final bool hasDividerAbove;
  final String route;
}
