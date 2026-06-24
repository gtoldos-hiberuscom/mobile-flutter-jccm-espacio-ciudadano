import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Gestión hub — Figma node 41631:14940.
class GestionPage extends ConsumerWidget {
  const GestionPage({super.key});

  static const List<_GestionSectionDefinition> _sections = [
    _GestionSectionDefinition(
      title: _GestionText.expedientesTitle,
      description: _GestionText.expedientesDescription,
      route: Routes.gestionExpedientes,
    ),
    _GestionSectionDefinition(
      title: _GestionText.registrosTitle,
      description: _GestionText.registrosDescription,
    ),
    _GestionSectionDefinition(
      title: _GestionText.aportacionTitle,
      description: _GestionText.aportacionDescription,
      hasDividerAbove: true,
    ),
    _GestionSectionDefinition(
      title: _GestionText.notificacionesTitle,
      description: _GestionText.notificacionesDescription,
      hasDividerAbove: true,
    ),
  ];

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sections = _sections.map((final s) => s.resolve(l10n)).toList(growable: false);

    return Scaffold(
      appBar: AppNavBar(
        title: l10n.gestionTitle,
        isLoggedIn: true,
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
                    const AppDivider(),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  AppNavigationCard(
                    title: section.title,
                    description: section.description,
                    onTap: () {
                      if (section.route != null) {
                        context.go(section.route!);
                      } else {
                        AppAlertSnackbar.show(
                          context,
                          message: l10n.gestionSectionComingSoon,
                        );
                      }
                    },
                  ),
                  if (!section.hasDividerAbove) const SizedBox(height: AppDimensions.space16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GestionSectionDefinition {
  const _GestionSectionDefinition({
    required this.title,
    required this.description,
    this.hasDividerAbove = false,
    this.route,
  });

  final _GestionText title;
  final _GestionText description;
  final bool hasDividerAbove;
  final String? route;

  _GestionSection resolve(final AppLocalizations l10n) {
    return _GestionSection(
      title: title.resolve(l10n),
      description: description.resolve(l10n),
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
  notificacionesDescription;

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
    required this.description,
    required this.hasDividerAbove,
    this.route,
  });

  final String title;
  final String description;
  final bool hasDividerAbove;
  final String? route;
}
