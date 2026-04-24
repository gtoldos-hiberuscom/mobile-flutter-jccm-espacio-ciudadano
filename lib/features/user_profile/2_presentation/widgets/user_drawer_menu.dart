import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/2_presentation/widgets/user_avatar_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Navigation drawer for the logged-in user.
class UserDrawerMenu extends StatelessWidget {
  const UserDrawerMenu({
    required this.profile,
    required this.onLogout,
    required this.onClose,
    super.key,
  });

  final UserProfile profile;
  final VoidCallback onLogout;
  final VoidCallback onClose;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = profile.displayName ?? profile.idAgente;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserAvatarWidget(initials: profile.initials, radius: 32),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profile.idAgente,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Semantics(
              label: l10n.userMenuProfile,
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.userMenuProfile),
                onTap: () {
                  onClose();
                  context.go(Routes.home);
                },
              ),
            ),
            Semantics(
              label: l10n.userMenuNotifications,
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(l10n.userMenuNotifications),
                onTap: () {
                  onClose();
                  context.go(Routes.home);
                },
              ),
            ),
            Semantics(
              label: l10n.userMenuSettings,
              child: ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(l10n.userMenuSettings),
                onTap: () {
                  onClose();
                  context.go(Routes.home);
                },
              ),
            ),
            const Divider(),
            Semantics(
              label: l10n.userMenuLogout,
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: Text(
                  l10n.userMenuLogout,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
